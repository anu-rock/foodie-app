# Database Design

We are using a NoSQL backend, so data duplication and denormalization is expected. Nothing to freak out.

See this wonderful Google I/O 19 talk on Firestore data modelling:  
https://www.youtube.com/watch?v=lW7DWV2jST0

Also this video about structuring data in Firestore:  
https://www.youtube.com/watch?v=haMOUb3KVSo&list=LLwzfmF6Imu2lIG3IhQsa84w&index=2&t=0s

## Collections

> **Note:** Subcollections help optimize and secure data. This is because, by default, a document is returned as a shallow record (without subcollections) in Firestore.

### users

```
{
  id: string,
  displayName: string,
  email: string,
  photoUrl: string,
  favoriteRecipes: number, // kept in sync via Cloud Function
  playedRecipes: number, // kept in sync via Cloud Function
  followers: number, // kept in sync via Cloud Function
  following: number, // kept in sync via Cloud Function
  private: [ // subcollection
    {
      key: string, value: dynamic
      // eg. 'isEmailVerified': true
      // eg. 'phoneNumber': '9876543210',
    }
  ],
}
```

### ingredients

This is just a static, one-time master list mostly for typeahead searching.

```
{
  name: string,
  unitOfMeasure: string,
}
```

### user_ingredients

```
{
  name: string,
  unitOfMeasure: string,
  quantity: number,
  userId: string,
  createdAt: string,
  updatedAt: string,
  removedAt: string,
}
```

### recipes

```
{
  id: string,
  title: string,
  desc: string,
  photoUrl: string,
  ingredients: string[]
  sourceRecipeId: string,
  sourceName: string,
  sourceUrl: string,
  difficulty: string,
  cookingTime: string,
  servings: string,
  plays: number, // kept in sync via Cloud Function
  favs: number, // kept in sync via Cloud Function
  views: number, // kept in sync via Cloud Function
  instructions: string[],
}
```

### user_recipes

```
{
  recipeId: string,
  recipeTitle: string,
  userId: string,
  userName: string, // kept in sync via Cloud Function
  userPhotoUrl: string,
  isFavorite: bool,
  isPlayed: bool,
  favoritedAt: string // timestamp
  playedAt: string[] // timestamps
  viewedAt: string[], // timestamps
}
```

### network

```
{
  followerId: string,
  followerName: string, // kept in sync via Cloud Function
  followerPhotoUrl: string, // kept in sync via Cloud Function
  followeeId: string,
  followeeName: string, // kept in sync via Cloud Function
  followeePhotoUrl: string, // kept in sync via Cloud Function
  followedAt: string,
}
```

### status

```
{
  userId: string,
  type: string, // [ recipe_played, recipe_favorited, custom ]
  message: string, // only used with type == custom
  photoUrl: string,
  recipeId: string,
  recipeName: string,
  createdAt: string,
}
```

### event_log

```
{
  code: string,
  message: string,
  userId: string,
  data: map
}
```
