# TODO

## Database

- [x] Ingredients master list

## UI

- [ ] Ingredients screen
  - [x] Add/remove (manual)
  - [ ] Add from receipt (OCR)
  - [ ] Time machine (see ingredients during a time range)
- [x] Recipe suggestions screen (wire up repository with existing screen)
- [ ] Recipe details screen (wire up repository with existing screen)
  - [x] Save
  - [ ] Favorite
  - [ ] Play
  - [ ] Share
- [ ] User Profile screen
  - [ ] profile settings
  - [ ] account settings
- [ ] Friend Profile screen
  - [ ] friend's user profile details
- [ ] Better login screen
- [ ] Sign up screen
- [ ] Status screen
- [ ] Splash screen
- [ ] Launcher icon
- [ ] Refactor styling into ThemeData (optional)

## Business Logic

- [ ] User repository
  - [ ] store users in Firestore
- [ ] Friend repository
- [x] Recipe repository (recipes + user_recipes collections)
  - [x] find recipes by ingredients
  - [x] add recipe (automatically done by viewing a recipe the first time from search results)
  - [x] get recipe by id/title
  - [ ] get popular recipes
- [ ] Status repository
  - [ ] "my next cook is \_\_\_" message
  - [ ] now playing recipe (à la Steam)
  - [ ] custom status message (à la WhatsApp)
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
- [ ] More integration tests

## CI/CD

- [ ] Build automation

# Phase 2

#### Ingredients from photo

Use image classification to identify ingredient names (and possibly quantities) from photo clicked from camera.

#### Cook along

Option to set photo status at each step of recipe instructions. Friends/followers to be able to get "live" status update about the recipe being played/cooked. This feature will help in creating **food influencers**.

#### Karaoke-style play/cook screen

Playing a recipe will be like playing a song in karaoke mode (more precisely like lyrics mode in Apple Music).
