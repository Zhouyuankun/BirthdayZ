# BirthdaZ

<p align="center">
    <img src="BirthdaZ/Assets.xcassets/AppIcon.appiconset/icon_128@1x.png" alt="BirthdaZ Logo" width="128" height="128">
</p>

A multiplatform birthday management app for iOS and macOS.

## Features

- **Birthday Tracking** - Gregorian and Chinese Lunar calendar support, countdown, age calculation
- **Gift Tracking** - Record gifts with categories, pie chart visualization
- **Multiplatform UI** - iOS TabView, macOS NavigationSplitView + MenuBarExtra
- **Data Storage** - SwiftData with local persistence

## Requirements

| Platform | Version |
|----------|---------|
| iOS | 18.0+ |
| macOS | 15.0+ |
| Xcode | 16.0+ |

## Installation

```bash
git clone https://github.com/yourusername/BirthdaZ.git
cd BirthdaZ
open BirthdaZ.xcodeproj
```

Press `Cmd+R` to build and run.

## Usage

- **Add Person**: Friends tab → `+` button → fill info → save
- **Record Gift**: Person detail → Edit → add gift in Gift History
- **My Birthday**: My Birthday tab → tap card to add
- **Mock Data**: Settings → "Load data"

## Tech Stack

| Technology | Purpose |
|------------|---------|
| SwiftUI | UI Framework |
| SwiftData | Persistence (@Model) |
| Charts | Pie chart visualization |
| ZhDate | Lunar calendar conversion |

## Architecture

- **MVVM** with `@Observable` macro
- **Actor** model for thread-safe data operations
- Platform-specific navigation via `#if os()`

## Project Structure

```
BirthdaZ/
├── App/                    # Entry point
├── Models/                 # SwiftData models
├── Views/                  # SwiftUI views
│   ├── Main/              # Platform navigation
│   ├── Birthday/          # Birthday views
│   ├── Settings/          # Settings
│   └── Components/        # View components
├── ViewComponents/        # Reusable components
├── ViewModifiers/         # Custom modifiers
├── Services/              # BirthdayModelHandler (Actor)
├── Extensions/            # Swift extensions
├── Helpers/               # Utilities
├── DataGeneration/        # Mock data
├── SwipeAction/           # Swipe actions
└── Resources/             # Assets
```

For details, see [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md).

## License

MIT License