# Academic Assessment System (Faculty App)

Local, offline classroom feedback app implemented in Flutter.

## Features
- First-run faculty onboarding (save name locally)
- Start a local session; server serves student page via local network
- Students submit name, roll, and A/B/C/D understanding
- Real-time dashboard on faculty device (via WebSocket)
- Sessions saved as JSON files under device storage

## How to run
1. flutter pub get
2. Configure Android permissions if needed (see AndroidManifest)
3. Build and install on Android device on same Wi-Fi network as students
4. Start app → enter name → create session → share link

## Storage
Session JSON files are stored in device external/app directory:
`/storage/emulated/0/Android/data/<package>/files/AcademicAssessment/`

## Notes
- No cloud or external backend used.
- Network requires both devices on same LAN.
