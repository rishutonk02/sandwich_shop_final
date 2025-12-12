# Pull Request Draft

Title: Fix/tests & state: Harmonize CartModel, tidy views, pass tests

Branch: `worksheet7` -> `main`

Summary:

Tests: All `flutter test` pass locally (20 passed, 0 failed).

Notes:

https://github.com/rishutonk02/sandwich_shop_final/compare/main...worksheet7?expand=1

Or use the GitHub web UI to create a PR with the above title/body.

If you'd like, I can also open a PR body file with more details or create a branch-specific checklist.
Title: fix(drawer): Home fallback and add navigation tests

Summary:
- Ensure the Drawer 'Home' item reliably returns to the app root when `GoRouter` is not available. The drawer now prefers `context.go('/')` and falls back to `Navigator.of(context).popUntil((r) => r.isFirst)`.
- Added and extended widget tests to cover Drawer navigation: Cart, Settings, Profile, About and Home fallback.

Why:
- In some environments the `GoRouter` instance isn't available (tests or simplified navigator stacks). The previous fallback did nothing which made the Home button appear non-functional. This change makes Home behave consistently across both router and Navigator-based navigation.

Testing:
- Ran `flutter analyze` (no issues) and `flutter test` — all tests pass locally.

Notes:
- I pushed these changes to the branch `worksheet7`. Open the compare page to create the PR: https://github.com/rishutonk02/sandwich_shop_final/compare/main...worksheet7?expand=1
