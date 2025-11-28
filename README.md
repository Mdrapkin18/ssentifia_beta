# Ssentifia

Ssentifia is an AI-forward fitness companion built with Flutter and Firebase. It combines workout programming, nutrition guidance, and profile-driven recommendations behind a cohesive brand experience that mirrors the look and feel of ssentifia.com. This README captures every screen, data shape, and visual decision so another developer can rebuild the full experience from scratch.

## Table of Contents
- [Brand & UX System](#brand--ux-system)
- [Platform & Toolchain](#platform--toolchain)
- [Architecture Overview](#architecture-overview)
- [Application Walkthrough](#application-walkthrough)
  - [Onboarding](#onboarding)
  - [Authentication](#authentication)
  - [Navigation Shell](#navigation-shell)
  - [Workout Plans](#workout-plans)
  - [Meals & Nutrition](#meals--nutrition)
- [Profile & Goals](#profile--goals)
- [Calendar Placeholder](#calendar-placeholder)
- [Settings & Utilities](#settings--utilities)
- [AI & Third-Party Keys](#ai--third-party-keys)
- [Data & Content Requirements](#data--content-requirements)
  - [Workout Documents](#workout-documents)
  - [Meal Documents](#meal-documents)
  - [User Documents](#user-documents)
- [Firebase Configuration](#firebase-configuration)
- [Deployment & Hosting](#deployment--hosting)
- [Assets & Branding](#assets--branding)
- [Local Development](#local-development)
- [Testing & Quality](#testing--quality)
- [Troubleshooting Notes](#troubleshooting-notes)

## Brand & UX System
- **Color palette:** Core colors are Granny Smith Apple (#9fd983) for primaries, Verdigris (#66b2b2) for secondary accents, Dark Slate Gray (#305f5f) for deep accents, Pakistan Green (#3b6d22) for highlights, and Misty Rose (#FDDDD8) for backgrounds.【F:lib/main.dart†L17-L43】 These colors drive AppBar, buttons, chips, floating action buttons, and typography defaults.
- **Typography:** Uses the default Material typography with primary text painted black to contrast the pastel background palette.【F:lib/main.dart†L30-L43】
- **Layout rhythm:** Rounded corners (10–20 px) on cards, dialogs, and text fields; list items use drop shadows for depth; gradients appear on the login background (Dark Slate Gray → Pakistan Green).【F:lib/login_screen.dart†L31-L71】【F:lib/meal_list.dart†L79-L135】
- **Iconography:** Material icons for navigation (fitness center, dining, person, calendar) and chips for selectable tags; SVG and raster logos are expected under `assets/images` and displayed on authentication screens.【F:lib/login_screen.dart†L31-L78】

## Platform & Toolchain
- **Framework:** Flutter 3.38.3 (Dart >= 2.18.6) targeting mobile and web builds.【F:pubspec.yaml†L1-L24】
- **Firebase services:** Auth, Firestore, Realtime Database, Storage, Analytics, Crashlytics, Dynamic Links configured for the `ssentifia-beta` project through generated `firebase_options.dart`.【F:lib/firebase_options.dart†L46-L88】
- **UI/utility packages:** `flutter_svg` (SVG logos), `calendar_view`, `flutter_spinbox`, `flutter_colorpicker`, `multi_image_picker_view`, and Sign-In button styles for OAuth affordances.【F:pubspec.yaml†L45-L54】【F:lib/login_screen.dart†L1-L20】

## Architecture Overview
- **Entry point:** `main.dart` initializes Firebase, applies the brand theme, and gates content on authentication status via `FirebaseAuth.authStateChanges`. Authenticated users land on `HomeScreen`; unauthenticated users see `LoginScreen`.【F:lib/main.dart†L9-L57】
- **State containers:** Each major feature is a stateful screen (e.g., `WorkoutPlanList`, `MealList`, `UserProfileScreen`) that hydrates itself from Firestore and retains filtered subsets in-memory for quick UI updates.【F:lib/home_screen.dart†L15-L118】【F:lib/meal_list.dart†L6-L70】
- **Navigation:** A bottom `BottomAppBar` with a center-docked FAB drives tab selection; a side drawer mirrors the same destinations. Floating dialogs are used for filter controls to keep the primary lists uncluttered.【F:lib/home_screen.dart†L224-L320】

## Application Walkthrough
### Onboarding
- `on_boarding.dart` provides a multi-card introduction that highlights AI-driven workouts, meal planning, and personalization. Integrate it before authentication to orient first-time users; each card uses brand colors and Material cards for visual consistency.【F:lib/on_boarding.dart†L5-L33】

### Authentication
- **Email/password:** Text fields with underlined inputs on a Misty Rose glassmorphic panel; errors currently print to console. Successful auth transitions via the auth-state listener to the home experience.【F:lib/login_screen.dart†L31-L136】
- **Google Sign-In:** Uses `flutter_signin_button` styling; the current implementation routes directly to `HomeScreen` on press (extend with real OAuth via `google_sign_in` for production).【F:lib/login_screen.dart†L137-L213】
- **Apple Sign-In placeholder:** Renders a disabled Apple button labeled “Coming Soon!” to communicate roadmap status.【F:lib/login_screen.dart†L192-L213】
- **Account creation:** `create_login_screen.dart` mirrors the login layout for sign-up flows (email/password creation stub).【F:lib/create_login_screen.dart†L1-L203】

### Navigation Shell
- **Tabs:** Workout Plans, Nutrition Tracking, Profile, and a “Not A Calendar” placeholder controlled by `currentIndex` state. Titles update dynamically in the AppBar header.【F:lib/home_screen.dart†L15-L220】【F:lib/home_screen.dart†L240-L320】
- **Drawer:** `drawer.dart` exposes the same destinations with ListTiles and keeps selection in sync with the active tab.【F:lib/drawer.dart†L1-L123】
- **Floating filters:** A center FAB opens either workout or meal filter dialogs depending on the active tab, keeping filtering one tap away.【F:lib/home_screen.dart†L320-L353】

### Workout Plans
- **Data loading:** Firestore `workouts` collection is read on init; data is transformed into `WorkoutPlan` models with normalized doubles and default imagery if none is provided.【F:lib/home_screen.dart†L63-L118】【F:lib/workout_plan.dart†L1-L50】
- **List presentation:** `WorkoutPlanList` adapts card grids to screen width, with hero imagery, titles, durations, experience level, and equipment callouts. Tapping pushes a detail page with exercise breakdowns (see `workout_plan_list.dart` and `workout_plan_detail.dart`).【F:lib/workout_plan_list.dart†L1-L220】
- **Filtering:** `FilterWorkoutsGeneralDialog` supplies a RangeSlider for duration (0–120 minutes) and a search field against titles; results update in-memory with `filterWorkouts`.【F:lib/filter_workouts_general_dialog.dart†L1-L107】【F:lib/home_screen.dart†L90-L176】
- **Completion state:** The model includes a `completed` flag for future tracking, defaulting to false.【F:lib/workout_plan.dart†L1-L33】

### Meals & Nutrition
- **Data loading:** Firestore `meals` collection is read on init and mapped into `Meal` models that coerce mixed numeric types and provide default photography when missing.【F:lib/home_screen.dart†L63-L118】【F:lib/meals.dart†L1-L38】
- **List presentation:** Responsive card list with full-width imagery, meal name, and calories; empty states show friendly messaging. Tapping opens `MealDetail` with ingredient lists, nutrition facts, and instructions.【F:lib/meal_list.dart†L46-L220】【F:lib/meal_detail.dart†L1-L250】
- **Filtering:** `FilterMealsGeneralDialog` offers a calorie RangeSlider (0–1000) plus name search; filtered results reuse the same card layout with instant feedback when no meals match.【F:lib/filter_meals_general_dialog.dart†L1-L102】【F:lib/home_screen.dart†L63-L176】
- **Nutrition structure:** Each meal exposes macronutrients (calories, protein, fat, carbohydrates), sodium, fiber, ingredient arrays, and free-form instructions for rendering.【F:lib/meals.dart†L10-L38】

### Profile & Goals
- **Data loading:** Fetches a specific user document from Firestore (replace with authenticated UID) and hydrates profile fields like name, email, age, gender, height (ft/in), weight, goal weight, and activity level.【F:lib/user_profile.dart†L72-L129】【F:lib/user_profile.dart†L210-L255】
- **Calculated metrics:** Uses `Nutrients` helper to compute BMR, TDEE, BMI, and macro targets (protein, carbs, fat, goal calories) displayed in card rows for quick reference.【F:lib/user_profile.dart†L210-L240】【F:lib/calculations.dart†L3-L111】
- **Selectable chips:** Fitness goals, dietary needs, and workout preferences rendered as `ChoiceChip` groups; tapping “add” opens a multi-select dialog for each category. Edit mode toggles via the AppBar action, enabling selection and future persistence.【F:lib/user_profile.dart†L1-L210】【F:lib/user_profile.dart†L260-L352】
- **Profile header:** Circular avatar placeholder, name/email text, and stacked metric cards organized in two flexible columns for responsiveness.【F:lib/user_profile.dart†L240-L352】

### Calendar Placeholder
- The fourth tab currently reuses the profile screen as a stub; replace `calendarScreen` with a real calendar experience using `calendar_view` when ready.【F:lib/home_screen.dart†L40-L118】

### Settings & Utilities
- **Settings panel:** `settings.dart` renders a themable Settings page with sections for General, Organization, and Support. Dark mode toggles the enclosing `Theme`, while other list tiles are placeholders for notifications, security, messaging, and calling. The “Profile” item routes back to the home shell with the Profile tab preselected.【F:lib/settings.dart†L1-L144】
- **Legacy meal list:** `edit_meal_screen.dart` contains an older meal list layout with loading state and commented-out filter dialog logic; keep it for reference or remove once the newer `MealList` is primary.【F:lib/edit_meal_screen.dart†L1-L129】

## Data & Content Requirements
### Workout Documents
Store each workout under `workouts` with the following fields consumed by `WorkoutPlan.fromJson`:
- `title` (string), `description` (string), `experience_level` (string), `location_to_complete` (string).
- `workout_duration` (number), `estimated_MET` (number).
- `workout_equipment` (array of strings) and `exercises` (map or list of exercise maps rendered in detail view).
- Optional `imgURL` (string) for hero imagery; defaults to a hosted stock photo if omitted.【F:lib/workout_plan.dart†L1-L33】

### Meal Documents
Store meals under `meals` with:
- `name` (string), `ingredients` (array of strings), `instructions` (string).
- `nutrition` map containing `calories`, `protein`, `fat`, `carbohydrates`, `fiber`, `sodium` (capitalization flexible; helper coerces values to doubles).【F:lib/meals.dart†L10-L38】
- Optional `imgURL` (string) for meal photography; defaults to a vegetable stock image if missing.【F:lib/meals.dart†L30-L38】

### User Documents
User records (e.g., in `users/<uid>`) should include the profile fields read today:
- `full_name`, `email`, `gender` (`male`/`female` expected), `age` (int), `height_ft` (int), `height_in` (int), `weight` (int), `goalWeight` (int), `activityLevel` (string matching “Sedentary”, “Lightly Active”, “Moderately Active”, “Very Active”).【F:lib/user_profile.dart†L72-L129】
- Optional `profileComplete` marker for onboarding state.
- Extend with arrays for `fitnessGoals`, `dietaryNeeds`, and `workoutPreferences` to persist chip selections; current UI keeps them in memory only.【F:lib/user_profile.dart†L1-L210】

## Firebase Configuration
- The repo ships with platform-specific options for project `ssentifia-beta` (web/appId `1:579612853398:web:1036b59d1e4946057a6eb7`). Replace `lib/firebase_options.dart` via `flutterfire configure` if targeting a different project.【F:lib/firebase_options.dart†L46-L88】
- Firestore rules, Realtime Database rules, Storage rules, and index templates are present at the repo root (`firestore.rules`, `database.rules.json`, `storage.rules`, `firestore.indexes.json`)—deploy them alongside your Firebase project for parity.
- Current rule defaults are restrictive for Realtime Database and Storage (both disallow reads/writes) but permissive for Firestore (open only until February 9, 2023). Update all rules before shipping to ensure authentication-gated access and least-privilege behavior.【F:database.rules.json†L1-L7】【F:storage.rules†L1-L7】【F:firestore.rules†L1-L8】

## Deployment & Hosting
- `firebase.json` is configured for Firebase Hosting with the Flutter web build output at `build/web` and links the same rules/index files noted above. Use `firebase deploy --only hosting,firestore,database,storage` after running `flutter build web` to publish a parity environment.【F:firebase.json†L1-L18】
- No Cloud Functions are present; analytics/crashlytics are initialized via Firebase core configuration and require the corresponding services enabled in the Firebase console.

## AI & Third-Party Keys
- The repository includes `lib/api.dart` with hard-coded OpenAI secret and organization IDs. **Do not ship this to production**—replace with environment-driven configuration (e.g., `--dart-define` at build time) or secure remote config. Remove the committed secret and rotate the key in your provider dashboard before release.【F:lib/api.dart†L1-L2】

## Assets & Branding
- Configure Flutter assets to point to brand logos under `assets/images/`, including `ssentifia_word_logo_transparent_2.svg` used on the login screen. Update `pubspec.yaml` if paths change.【F:lib/login_screen.dart†L49-L70】【F:pubspec.yaml†L75-L89】
- App title is “Ssentifia”; ensure app store metadata and splash screens use the green “S” logomark and wordmark as shown in the attached references.
- `tools.md` documents the toolchain versions (Flutter 3.38.3, linting, and test utilities) that this repo was created with—align your local environment to avoid version drift during deployments.【F:tools.md†L1-L5】

## Local Development
1. **Prerequisites**
   - Install Flutter 3.38.3 (Dart >= 2.18.6) and ensure `flutter` is on PATH.【F:tools.md†L1-L4】【F:pubspec.yaml†L1-L24】
   - Install the FlutterFire CLI for regenerating Firebase config when switching projects.
2. **Install packages**
   ```bash
   flutter pub get
   ```
3. **Seed Firebase**
   - Add `workouts`, `meals`, and `users` collections per the schemas above so lists and profile cards populate on first load.【F:lib/home_screen.dart†L63-L118】【F:lib/user_profile.dart†L72-L129】
4. **Run**
   - Mobile: `flutter run`
   - Web: `flutter run -d chrome` (web config already present).【F:lib/firebase_options.dart†L46-L88】
5. **Hot reload**
   - All screens are stateful; filters and edits update in-memory lists, so hot reload is safe during UI iteration.

## Testing & Quality
- Linting follows `flutter_lints`; run `flutter analyze` to enforce the style guide.【F:analysis_options.yaml†L1-L13】
- Add integration and widget tests with `flutter_test`, `flutter_driver`, and `mockito` as needed; no tests ship today.【F:pubspec.yaml†L56-L69】

## Troubleshooting Notes
- Missing images in Firestore will fall back to stock URLs defined in the models; broken links will render as failed network images, so prefer uploading assets to Firebase Storage and referencing them via `imgURL`.【F:lib/meals.dart†L30-L38】【F:lib/workout_plan.dart†L20-L33】
- The calendar tab is a placeholder; wire it to a real calendar screen to avoid duplicate profile content.【F:lib/home_screen.dart†L40-L118】
- The Google/Apple buttons currently bypass real OAuth; integrate `google_sign_in` and `sign_in_with_apple` for production readiness.【F:lib/login_screen.dart†L137-L213】
- `calendar.dart` is an empty stub and `temp_code.dart` contains an archived grid prototype—both can be removed once the production calendar and workout layouts supersede them.【F:lib/calendar.dart†L1-L1】【F:lib/temp_code.dart†L1-L90】
