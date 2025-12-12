# Pull Request Draft

Title: Fix/tests & state: Harmonize CartModel, tidy views, pass tests

Branch: `worksheet7` -> `main`

Summary:
- Convert internal `Cart` to `CartModel` (ChangeNotifier wrapper) and update views/tests to use it.
- Fix various UI and routing issues (drawer navigation fallbacks, AppBar leading overflow, non-const TextStyle usage).
- Add missing test keys (`add_to_cart`, `size_switch`, `cart_items`, `cart_total`) and update tests.
- Remove temporary inline confirmation UI; use SnackBar for feedback.
- Bump a few dev dependencies (`flutter_lints`, `image`) while keeping `sqflite_common_ffi` compatible with Dart SDK.
- Lint fixes (remove unnecessary multiple underscore parameters).

Tests: All `flutter test` pass locally (20 passed, 0 failed).

Notes:
- I couldn't use `gh` CLI to create the PR from this environment (not installed). You can open the PR with this URL:

https://github.com/rishutonk02/sandwich_shop_final/compare/main...worksheet7?expand=1

Or use the GitHub web UI to create a PR with the above title/body.

If you'd like, I can also open a PR body file with more details or create a branch-specific checklist.
