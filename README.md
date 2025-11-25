# Ssentifia

Ssentifia is an AI-powered fitness companion that pairs workout planning, nutrition tracking, and personalized coaching in a single Flutter application. The app is built around Firebase-backed content (meals, workouts, and user profiles) and a branded UI consistent with the experience at [ssentifia.com](https://ssentifia.com).

## Core Features

- **Firebase-backed authentication** – Email/password sign-in, optional Google entry point, and an auth-state listener that routes users directly into the main experience once authenticated.【F:lib/login_screen.dart†L1-L207】【F:lib/main.dart†L70-L83】  
- **Workout discovery & filtering** – Pulls workouts from the `workouts` Firestore collection, displays responsive card grids, and lets users filter by title and duration via a floating filter dialog.【F:lib/home_screen.dart†L66-L222】【F:lib/workout_plan_list.dart†L1-L220】  
- **Nutrition browsing & filtering** – Loads meals from the `meals` collection, renders them in responsive lists with imagery, and filters by name and calorie range using the same dialog pattern.【F:lib/home_screen.dart†L101-L160】【F:lib/meal_list.dart†L1-L220】  
- **Structured content models** – Dedicated `Meal` and `WorkoutPlan` models normalize Firestore payloads, account for mixed numeric types, and provide default imagery.【F:lib/meals.dart†L1-L53】【F:lib/workout_plan.dart†L1-L50】  
- **User profile & goal tracking** – A profile screen loads Firestore-backed user data, gathers fitness goals, dietary needs, and workout preferences through multi-select dialogs, and surfaces calculated metrics (BMR, TDEE, BMI) from the `calculations.dart` helper.【F:lib/user_profile.dart†L1-L320】  
- **Navigation shell** – A bottom navigation bar and drawer toggle between workouts, meals, profile, and a placeholder calendar experience while retaining shared filtering controls.【F:lib/home_screen.dart†L224-L412】  
- **Onboarding** – Multi-page onboarding content introduces AI-powered workouts, meal planning, and profile personalization for new users.【F:lib/on_boarding.dart†L5-L33】

## Tech Stack

- **Framework:** Flutter (Dart SDK >=2.18.6), targeting mobile and web surfaces.【F:pubspec.yaml†L1-L24】  
- **Backend:** Firebase (Auth, Firestore, Realtime Database, Storage, Analytics, Crashlytics, Dynamic Links). Project ID: `ssentifia-beta` with platform-specific configs in `lib/firebase_options.dart`.【F:pubspec.yaml†L31-L55】【F:lib/firebase_options.dart†L46-L88】  
- **UI & utilities:** `flutter_svg`, `calendar_view`, `flutter_spinbox`, `flutter_colorpicker`, and `multi_image_picker_view` provide visuals and input controls.【F:pubspec.yaml†L45-L54】  
- **Tooling:** Flutter SDK 3.38.3 with linting via `flutter_lints` and testing support through `flutter_test`, `flutter_driver`, and `mockito`.【F:tools.md†L1-L4】【F:pubspec.yaml†L56-L69】

## Project Structure

```
lib/
├── main.dart                # App entry point, theme, and auth gate
├── home_screen.dart         # Navigation shell plus workout/meal filtering
├── login_screen.dart        # Email/Google sign-in experience
├── create_login_screen.dart # Account creation flow
├── on_boarding.dart         # Intro carousel for new users
├── workout_plan*.dart       # Workout data model, list, and detail pages
├── meal*.dart               # Meal model, list, detail, and editor screens
├── user_profile.dart        # Profile, goals, dietary needs, and metrics
├── filter_*_dialog.dart     # Shared filtering dialogs for meals/workouts
├── drawer.dart              # Navigation drawer
└── firebase_options.dart    # FlutterFire-generated Firebase configs
```

## Local Setup

1. **Prerequisites**
   - Install Flutter 3.38.3 (or newer compatible with Dart 2.18) and ensure `flutter` is on your PATH.【F:tools.md†L1-L4】【F:pubspec.yaml†L22-L24】  
   - Install the FlutterFire CLI if you need to regenerate Firebase configs.

2. **Clone & install packages**
   ```bash
   flutter pub get
   ```

3. **Firebase configuration**
   - The repo already includes `lib/firebase_options.dart` with project ID `ssentifia-beta`. If you own a different Firebase project, run `flutterfire configure` and replace the generated file.【F:lib/firebase_options.dart†L46-L88】  
   - Ensure Firestore collections `workouts`, `meals`, and `users` contain documents matching the fields expected by `WorkoutPlan.fromJson`, `Meal.fromJson`, and the profile loader in `user_profile.dart`.【F:lib/workout_plan.dart†L28-L46】【F:lib/meals.dart†L37-L50】【F:lib/user_profile.dart†L169-L216】

4. **Run the app**
   - For mobile: `flutter run` with an attached emulator or device.  
   - For web: `flutter run -d chrome` (the Firebase web config is present).  

5. **Testing & linting**
   - Add or run tests with `flutter test`.  
   - Use `flutter analyze` to apply the lint rules defined in `analysis_options.yaml` (via `flutter_lints`).

## Usage Notes

- The login flow currently navigates directly to the home screen after successful auth state changes; add password reset or Apple sign-in handling as needed.【F:lib/login_screen.dart†L29-L207】  
- Workout and meal filtering use floating dialogs and in-memory filtering; Firestore reads occur at app start via the home screen state init hooks.【F:lib/home_screen.dart†L66-L170】【F:lib/home_screen.dart†L224-L412】  
- Profile calculations depend on the `Nutrients` helper (see `calculations.dart`) and assume user data exists in Firestore; seed data accordingly.【F:lib/user_profile.dart†L169-L216】

## Resources

- Brand site: [ssentifia.com](https://ssentifia.com)
- Flutter documentation: https://docs.flutter.dev/
- Firebase for Flutter: https://firebase.google.com/docs/flutter
