Recording the running Chrome app (Windows)

This project runs a Flutter web app on Chrome via `flutter run -d chrome`.
Below are instructions to record the running app using `ffmpeg` (Windows).

Prerequisites
- Install `ffmpeg` and make sure it's on your PATH.

Quick steps (PowerShell)

1. Start the Flutter app in Chrome (if not already running):

```powershell
cd 'C:\Users\Rishu Tonk\Desktop\programming\dart programming\sandwich_shop'
flutter run -d chrome
```

2. Open the app in Chrome and confirm the page title shows (e.g. "Sandwich Shop App").

3. Record the Chrome window (replace the window title with your browser title):

```powershell
ffmpeg -f gdigrab -framerate 30 -i title="Sandwich Shop App - Google Chrome" -video_size 1280x720 -y recording.mp4
```

Notes
- If you prefer to record the whole desktop instead of a specific window, use `-i desktop` instead of `-i title=...`.
- OBS Studio provides a friendly GUI for screen recording and may be easier for longer sessions.

Optional: PowerShell helper script `scripts\record_chrome.ps1` (provided) will start Chrome with a temporary profile and record a window by title using `ffmpeg`.
