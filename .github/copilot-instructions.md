<!-- .github/copilot-instructions.md - guidance for AI coding agents working on this repo -->
# Guidance for AI code contributors (concise, actionable)

The following notes summarise the essential knowledge an AI assistant needs to be productive in this Flutter project.

1) Big picture / architecture
- This is a Flutter mobile/web app (see `pubspec.yaml`).
- State & routing: the app uses GetX (`get` package). Root widget is `lib/main.dart` which chooses `Home()` or `AuthScreen()` depending on `AppConst.userId`.
- Folder responsibilities:
  - `lib/Controllers/` — screen-specific GetxControllers (e.g. `HomeController`, `AuthScreenController`, `AllPostsController`). Follow the existing pattern: controllers expose Rx fields (e.g. `var isLoading = false.obs`) and are created with `Get.put()` in the corresponding UI.
  - `lib/Screens/` — Widgets representing screens; they instantiate controllers via `Get.put` or `Get.find` and observe state with `Obx`/`GetX`.
  - `lib/Models/` — lightweight DTOs with fromJson methods (e.g. `Post.fromJson`). Use these models when decoding HTTP JSON responses.
  - `lib/Globle/` — global helpers and theme/colors. `AppConst` is the single source for persisted user data (via `SharedPreferences`).

2) Important patterns & conventions
- Network calls are done directly in controllers using `http` (e.g. `AllPostsController.fetchPosts()` calls `http.get` on `https://technewstips.com/api/...`). When adding or changing calls, preserve the existing URL host and field names unless explicitly migrating the backend.
- Form handling: controllers own `TextEditingController`s and `GlobalKey<FormState>` (see `AddPostViewController`). Validate in controller and call backend there.
- File uploads: where used, controllers construct `http.MultipartRequest` and send it (see `AuthScreenController.login` and `ProfileViewController.fetchProfile`). Keep using MultipartRequest when uploading files or posting form fields.
- Persistence: `AppConst.saveUserData` and `AppConst.loadUserData` wrap `SharedPreferences`. Use these for login/logout flows — `main.dart` awaits `AppConst.loadUserData()` before runApp.
- UI state: prefer Rx observables (`.obs`) and `Obx`/`GetX` in UI. Controllers expose reactive lists (e.g. `var posts = <Post>[].obs`) and booleans (`isLoading = false.obs`). Update state via `.value` or Rx collection methods.

3) Key files to inspect for examples
- `lib/main.dart` — app bootstrap, theme, initial route decision
- `lib/Globle/app_const.dart` — global state and shared_prefs helpers
- `lib/Globle/themes.dart` and `lib/Globle/colors.dart` — theming
- `lib/Controllers/*.dart` — examples for networking, validation, Rx usage (`all_posts_controller.dart`, `auth_screen_controller.dart`, `profile_view_controller.dart`)
- `lib/Screens/home.dart` — app shell with bottom nav and `HomeController` usage

4) Build / run / test workflows
- Local dev (macOS): standard Flutter flows apply.
  - Get dependencies: `flutter pub get`
  - Run on iOS simulator: `flutter run -d macos` or `flutter run -d ios` (ensure Xcode tooling + cocoapods installed)
  - Run on Android emulator: `flutter run -d android` (ensure Android SDK + emulator configured)
  - Web: `flutter run -d web` or `flutter run -d chrome`
- Tests: unit/widget tests live under `test/`. Run `flutter test` to run all tests.
- Formatting & linting: repo uses `flutter_lints`. Use `dart format .` and `flutter analyze`.

5) Common pitfalls and how to fix them (from code patterns)
- App startup depends on `AppConst.loadUserData()` being awaited in `main`. If navigation appears broken on cold start, ensure asynchronous initialization hasn't been removed.
- Network calls reference a hard-coded host (`technewstips.com`). If backend changes, update every controller endpoint consistently.
- Controllers often log debug prints (e.g. "DEBUG: ..."). When creating new production code, follow the same lightweight print-based debugging or replace with a common logger if adding one.

6) What to modify and how to test changes
- Adding a new screen:
  - Create `lib/Screens/<feature>/` with UI widget.
  - Add a controller in `lib/Controllers/` and expose Rx fields.
  - Wire the controller via `Get.put()` in the screen or a binding. Use existing `HomeController.pages` pattern when adding a tab.
  - Test: run the app (`flutter run`) and exercise the new screen. Add a widget test in `test/` for basic rendering.
- Changing API contracts:
  - Update model `fromJson`/`toJson` in `lib/Models/`.
  - Update all controllers that decode that API response.
  - Run `flutter test` and manual smoke test with emulator.

7) Security & secrets
- No secrets are present in the repo. When adding API keys or credentials, use secure storage or env config and never commit them to source.

8) Examples (copyable snippets from this codebase)
- Load user data at app startup (already used in `main.dart`):
  await AppConst.loadUserData();

- Simple HTTP GET in a controller (see `AllPostsController.fetchPosts`):
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) { final List data = jsonDecode(response.body); posts.value = data.map((e) => Post.fromJson(e)).toList(); }

- Multipart POST (file upload/login pattern):
  var request = http.MultipartRequest('POST', Uri.parse('...'));
  request.fields.addAll({'email': AppConst.useremail ?? ''});
  var response = await request.send();

9) When to ask clarifying questions
- If you need to change the API host, confirm with the maintainer before sweeping edits.
- If adding a global binding vs. screen-level controller, confirm lifecycle expectations (permanent vs fenix lazyPut).

If anything here is unclear or you want more examples (e.g. common test patterns, CI commands, or a repo-specific logger), tell me which area to expand and I'll iterate.
