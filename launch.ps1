# Optional Windows Terminal pane launcher.
# Run from the project folder after installing requirements.

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

wt `
  new-tab --title "Monitor" --startingDirectory "$root" powershell -NoExit -ExecutionPolicy Bypass -Command "& '.\.venv\Scripts\python.exe' 'process_defender.py' monitor" `
  `; split-pane -H --title "Alerts" --startingDirectory "$root" powershell -NoExit -ExecutionPolicy Bypass -Command "& '.\.venv\Scripts\python.exe' 'process_defender.py' tail --log alerts" `
  `; split-pane -V --title "Actions" --startingDirectory "$root" powershell -NoExit -ExecutionPolicy Bypass -Command "& '.\.venv\Scripts\python.exe' 'process_defender.py' tail --log actions"
