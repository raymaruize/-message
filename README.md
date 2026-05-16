# -message

A first native iOS prototype for a private couples app where you can save updates, facts, quotes, and photos for each other.

## What is in this repo

- `MessageForTwo.xcodeproj`: open this in Xcode
- `MessageForTwo/`: SwiftUI app source
- Local-only MVP state stored with `UserDefaults`
- Seed content so the first launch already feels like a real app

## Current MVP

- Timeline of shared memories
- Filters for updates, quotes, facts, and photos
- Composer for creating a new entry
- Optional photo attachment from the iPhone photo library
- Local persistence on-device

## Open in Xcode

1. Open `MessageForTwo.xcodeproj` in Xcode.
2. In the target settings, set your own signing team.
3. If you want a unique bundle id, change `com.raymaruize.MessageForTwo`.
4. Pick your iPhone or simulator and run.

## Getting to TestFlight

1. Replace the placeholder app icon in `MessageForTwo/Assets.xcassets/AppIcon.appiconset`.
2. Add your Apple Developer signing team in Xcode.
3. Archive the app in Xcode.
4. Upload the archive to App Store Connect.
5. Invite internal or external testers through TestFlight.

## Important limitation of this first version

This is a local prototype. It is ready to install from Xcode and shape into a real product, but it does **not** sync data between two phones yet. The next major step is adding a backend and authentication so both people see the same shared timeline.
