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

    const recipeDoc = db.collection('recipes').doc(recipeId);

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
        const views = recipe.data().views || 0;
        t.update(recipeDoc, { views: views + viewsIncrement });
      }

      if (favsIncrement) {
        const favs = recipe.data().favs || 0;
        t.update(recipeDoc, { favs: favs + favsIncrement });
      }

      if (playsIncrement) {
        const plays = recipe.data().plays || 0;
        t.update(recipeDoc, { plays: plays + playsIncrement });
      }
    });

    console.log('Counters synced.');
    return null;
  });
