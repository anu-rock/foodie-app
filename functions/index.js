'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const db = admin.firestore();

/**
 * Keeps a recipe's counters such as views, favs and plays in sync.
 */
exports.syncRecipeCounters = functions.firestore
  .document('/user_recipes/{userRecipeId}')
  .onWrite(async (change) => {
    const prevData = change.before.data();
    const newData = change.after.data();
    const recipeId = newData.recipeId;
    const userId = newData.userId;

    const recipeDoc = db.collection('recipes').doc(recipeId);
    const userDoc = db.collection('users').doc(userId);

    let viewsIncrement;
    if (!prevData || newData.viewedAt.length > prevData.viewedAt.length) {
      viewsIncrement = 1;
    }

    let favsIncrement;
    if (prevData) {
      if (prevData.isFavorite === false && newData.isFavorite === true) {
        favsIncrement = 1;
      } else if (prevData.isFavorite === true && newData.isFavorite === false) {
        favsIncrement = -1;
      }
    }

    let playsIncrement;
    if (prevData && newData.playedAt.length > prevData.playedAt.length) {
      playsIncrement = 1;
    }

    await db.runTransaction(async (t) => {
      const recipe = await t.get(recipeDoc);

      if (viewsIncrement) {
        const userViewedRecipesDoc = userDoc
          .collection('private')
          .doc('viewedRecipes');
        const userViewedRecipes = await t.get(userViewedRecipesDoc);

        const recipeViews = recipe.data().views || 0;
        t.update(recipeDoc, { views: recipeViews + viewsIncrement });
        const userRecipeViews = userViewedRecipes.data().value || 0;
        t.update(userViewedRecipesDoc, {
          value: userRecipeViews + viewsIncrement,
        });
      }

      if (favsIncrement) {
        const user = await t.get(userDoc);

        const recipeFavs = recipe.data().favs || 0;
        t.update(recipeDoc, { favs: recipeFavs + favsIncrement });
        const userRecipeFavs = user.data().favoriteRecipes || 0;
        t.update(userDoc, { favoriteRecipes: userRecipeFavs + favsIncrement });
      }

      if (playsIncrement) {
        const user = await t.get(userDoc);

        const recipePlays = recipe.data().plays || 0;
        t.update(recipeDoc, { plays: recipePlays + playsIncrement });
        const userRecipePlays = user.data().playedRecipes || 0;
        t.update(userDoc, { playedRecipes: userRecipePlays + playsIncrement });
      }
    });

    console.log('Counters synced.');
    return null;
  });

/**
 * Keeps a user's network counters such as followers and following in sync.
 */
exports.syncUserNetworkCounters = functions.firestore
  .document('/network/{connectionId}')
  .onWrite(async (change) => {
    const prevData = change.before.data();
    const newData = change.after.data();

    let increment;
    let followerId;
    let followeeId;

    if (!prevData && newData) {
      // connection added
      increment = 1;
      followerId = newData.followerId;
      followeeId = newData.followeeId;
    } else if (prevData && !newData) {
      // connection deleted
      increment = -1;
      followerId = prevData.followerId;
      followeeId = prevData.followeeId;
    }

    const followerDoc = db.collection('users').doc(followerId);
    const followeeDoc = db.collection('users').doc(followeeId);

    await db.runTransaction(async (t) => {
      const follower = await t.get(followerDoc);
      const followee = await t.get(followeeDoc);

      if (increment) {
        const numFollowees = follower.data().following || 0;
        t.update(followerDoc, { following: numFollowees + increment });
        const numFollowers = followee.data().followers || 0;
        t.update(followeeDoc, { followers: numFollowers + increment });
      }
    });

    if (!prevData && newData) {
      await sendPushNotification(
        newData.followeeId,
        'You have a new follower!',
        `${newData.followerName} is now following you.`,
        newData.followerPhotoUrl
      );
    }

    console.log('Counters synced.');
    return null;
  });

/**
 * Keeps a user's profile details such as name and photoUrl in sync.
 * TODO: This is a work in progress.
 */
// exports.syncUserDetails = functions.firestore
//   .document('/users/{userId}')
//   .onUpdate(async (change) => {
//     const prevData = change.before.data();
//     const newData = change.after.data();
//     const userId = prevData.userId;

//     const isNameChanged = prevData.displayName !== newData.displayName;
//     const isPhotoChanged = prevData.photoUrl !== newData.photoUrl;

//     const userRecipeDocs = db
//       .collection('user_recipes')
//       .where('userId', '==', userId);
//     const followerDocs = db
//       .collection('network')
//       .where('followerId', '==', userId);
//     const followeeDocs = db
//       .collection('network')
//       .where('followeeId', '==', userId);

//     if (isNameChanged || isPhotoChanged) {
//       await db.runTransaction(async (t) => {});

//       console.log('User details synced.');
//     }
//     return null;
//   });

async function sendPushNotification(userId, title, body, icon) {
  console.log('Sending push notification...');

  const tokensDoc = db
    .collection('users')
    .doc(userId)
    .collection('private')
    .doc('fcmTokens');
  const tokens = (await tokensDoc.get()).data().value;

  console.log(tokens);

  // Check if there are any device tokens
  if (!tokens.length) {
    return console.log('There are no notification tokens to send to.');
  }

  // Notification details
  const payload = {
    notification: {
      title,
      body,
      icon,
    },
  };

  // Send notifications to all tokens
  const response = await admin.messaging().sendToDevice(tokens, payload);
  // For each message check if there was an error
  const tokensToRemove = [];
  response.results.forEach((result, index) => {
    const error = result.error;
    if (error) {
      console.error('Failure sending notification to', tokens[index], error);
      // Cleanup the tokens who are not registered anymore
      if (
        error.code === 'messaging/invalid-registration-token' ||
        error.code === 'messaging/registration-token-not-registered'
      ) {
        tokensToRemove.push(
          tokensDoc.update({
            value: admin.firestore.FieldValue.arrayRemove(tokens[index]),
          })
        );
      }
    }
  });
  return Promise.all(tokensToRemove);
}
