# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Session Initialization

When starting a session, read `README.md` and `DEVELOPER_GUIDE.md` for project overview and architecture details. Update these files when adding or modifying features.

## Build and Run

```bash
open BirthdaZ.xcodeproj
```

Command line builds:
```bash
# iOS Simulator
xcodebuild -project BirthdaZ.xcodeproj -scheme BirthdaZ -destination 'platform=iOS Simulator,name=iPhone 16' build

# macOS
xcodebuild -project BirthdaZ.xcodeproj -scheme BirthdaZ -destination 'platform=macOS' build
```

## Requirements

- iOS 18.0+, macOS 15.0+, Xcode 16.0+, Swift 6.0+

## Architecture

**MVVM with SwiftData**:
```
Views → @Environment(\.modelContext) → BirthdayModelHandler (Actor) → SwiftData
```

**Platform Routing** (`ContentView.swift`):
- iOS: `MainTabView` (TabView with 3 tabs)
- macOS: `MainNavView` (NavigationSplitView with sidebar + MenuBarExtra)

## Key Files

| Path | Purpose |
|------|---------|
| `App/BirthdaZApp.swift` | App entry, SwiftData setup |
| `App/ContentView.swift` | Platform routing |
| `Models/Person.swift` | Main `@Model` with transient properties |
| `Models/GiftModel.swift` | Gift `@Model` with cascade delete |
| `Services/BirthdayModelHandler.swift` | Actor-based CRUD |

## Data Layer

**Person** model has:
- Persisted: `id`, `name`, `nickname`, `gender`, `birthDate`, `birthdayCalendar`, `themeColor`, `sentGifts`
- `@Transient`: `nextBirthday`, `daysToNextBirthday`, `age`, `isBirthdayToday`, `birthDateInChineseCalendar`
- Relationship: `sentGifts: [GiftModel]` (cascade delete)

**BirthdayModelHandler** (`final actor`, `@MainActor` methods): `fetchBirthdays`, `insertBirthdayToDisk`, `updateBirthdayToDisk`, `deleteBirthdayInoDisk`, `deleteAllBirthdaysOnDisk`, `saveMockedBirthdaysToDisk`

## External Dependency

**ZhDate** (https://github.com/Zhouyuankun/ZhDate) - Chinese lunar calendar via `Date.nongDate`

## Platform Code

```swift
#if os(iOS)
// iOS code
#elseif os(macOS)
// macOS code
#endif
```

## Mock Data

Settings > "Load data" calls `BirthdayModelHandler.saveMockedBirthdaysToDisk()`. Defined in `DataGeneration/BirthdayModel+DataGeneration.swift`.