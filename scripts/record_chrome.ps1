Param(
  [string]$Url = 'http://localhost:5170',
  [int]$DebugPort = 9222,
  [string]$Out = 'recording.mp4'
)

if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
  Write-Error 'ffmpeg not found on PATH. Please install ffmpeg first.'
  exit 1
}

Start-Process -FilePath 'chrome' -ArgumentList "--user-data-dir=$env:TEMP\ffmpeg_chrome_profile --remote-debugging-port=$DebugPort --new-window $Url"
Start-Sleep -Seconds 2

Write-Host 'Recording. Press Ctrl+C to stop.'
ffmpeg -f gdigrab -framerate 30 -i title="Sandwich Shop App - Google Chrome" -video_size 1280x720 -y $Out
