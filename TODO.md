# TODO

## Micro Tasks

#### Remove tasks when they get completed

- Fix broken tests
- On `ProfileScreen`:
  - implement 'Preferences'
  - implement 'About Foodie App'
  - add option to change password
- Add a background image on home page to reduce boringness

## Database

- [x] Ingredients master list

## UI

- [x] Ingredients screen
  - [x] Add/remove (manual)
- [x] Recipe suggestions screen (wire up repository with existing screen)
- [x] Recipe details screen (wire up repository with existing screen)
  - [x] Save
  - [x] Favorite
  - [x] Play
  - [x] Share
- [x] User Profile screen
  - [x] favorites
  - [x] played history
  - [x] profile settings
  - [x] account settings
- [ ] Friend Profile screen
  - [ ] friend's user profile details
- [x] Sign up screen
- [ ] Status screen (updates from friends)
- [ ] Splash screen
- [ ] Launcher icon
- [ ] Refactor styling into ThemeData (optional)

## Business Logic

- [x] User repository
  - [x] store users in Firestore
  - [x] while creating user, documentID should be set as `FirebaseUser.uid` and photoUrl should be set as Gravatar url
- [ ] Friend repository
- [x] Recipe repository (recipes + user_recipes collections)
  - [x] find recipes by ingredients
  - [x] add recipe (automatically done by viewing a recipe the first time from search results)
  - [x] get recipe by id/title
  - [ ] get popular recipes
- [ ] Status repository
  - [ ] now playing recipe (à la Steam)
- [ ] Log respository
  - [ ] recipe search
  - [ ] errors
- [ ] Push Notifications (use Firebase Functions)
  - [ ] status updates for friends
- [ ] Email Notifications (use Firebase Functions)
  - [ ] email verification
  - [ ] welcome email
  - [ ] password reset
  - [ ] all push notification scenarios
- [ ] Facebook login
- [ ] Google login
- [ ] iOS support (Firebase and smoke testing)

## Tests

- [ ] More screen/widget tests
  - [ ] Widget tests for `RecipeOverviewScreen`
    - is recipe displayed when coming from search screen?
    - is recipe displayed when coming from some other screen?
    - is favorite button visible?
    - is total favorites for recipe data visible?
- [ ] More integration tests

## CI/CD

- [ ] Build automation

# Phase 2

#### Ingredient screen improvements

Option to add from receipt (OCR).  
Time machine (see ingredients during a time range).

#### Custom status

Phase 1 manages status automatically. Last cooked recipe is auto-set as the current status. Phase 2 to have an option to set a custom status text & pic (a la WhatsApp).

#### Cook along

Option to set photo status at each step of recipe instructions. Friends/followers to be able to get "live" status update about the recipe being played/cooked. This feature will help in creating **food influencers**.

# Phase 3

#### Ingredients from photo

Use image classification to identify ingredient names (and possibly quantities) from photo clicked from camera.

#### Karaoke-style play/cook screen

Playing a recipe will be like playing a song in karaoke mode (more precisely like lyrics mode in Apple Music).
