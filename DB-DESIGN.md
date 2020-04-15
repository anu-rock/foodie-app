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
  phoneNumber: string,
  photoUrl: string,
  favorite_recipes: number, // kept in sync via Cloud Function
  played_recipes: number, // kept in sync via Cloud Function
  private: [ // subcollection
    {
      key: string, value: dynamic // eg. 'isEmailVerified': true
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
  user_id: string,
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
  sourceUrl: string,
  plays: number, // kept in sync via Cloud Function
  favs: number, // kept in sync via Cloud Function
  views: number, // kept in sync via Cloud Function
  instructions: [ // subcollection
    {
      step_num: int,
      step_inst: string,
    }
  ],
}
```

### user_recipes

```
{
  user_id: string,
  user_name: string, // kept in sync via Cloud Function
  user_photoUrl: string,
  recipe_id: string,
  recipe_title: string,
  favorite: bool,
  favorited_on: string
  plays: string[], // timestamps
  views: string[], // timestamps
}
```

### friends

```
{
  user_id: string,
  user_name: string, // kept in sync via Cloud Function
  user_photoUrl: string, // kept in sync via Cloud Function
  friend_id: string,
  friend_name: string, // kept in sync via Cloud Function
  friend_photoUrl: string, // kept in sync via Cloud Function
}
```

### status

```
{
  user_id: string,
  status: string,
}
```

### event_log

```
{
  code: string,
  message: string,
  user_id: string,
  data: map
}
```
