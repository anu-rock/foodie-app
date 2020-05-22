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
