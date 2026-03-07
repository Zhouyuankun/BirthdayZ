# BirthdaZ

<p align="center">
    <img src="BirthdaZ/Assets.xcassets/AppIcon.appiconset/icon_128@1x.png"
         alt="BirthdaZ Logo" width="128" height="128">
</p>

<p align="center">
    <strong>A beautiful birthday management app for iOS and macOS</strong>
</p>

<p align="center">
    <a href="#features">Features</a> •
    <a href="#screenshots">Screenshots</a> •
    <a href="#requirements">Requirements</a> •
    <a href="#installation">Installation</a> •
    <a href="#usage">Usage</a> •
    <a href="#technology-stack">Technology Stack</a>
</p>

---

## Features

### Birthday Management
- Track birthdays of friends and family
- Support for both Gregorian (公历) and Chinese Lunar calendar (农历)
- Automatic countdown to next birthday
- Age calculation

### Gift Tracking
- Record gifts sent to each person
- Categorize gifts by type (electronics, books, clothing, etc.)
- View gift history with pie chart visualization

### User Interface
- Beautiful animated countdown ring
- Custom swipe actions for quick operations
- Platform-optimized navigation
  - iOS: TabView with 3 tabs
  - macOS: NavigationSplitView with sidebar + MenuBarExtra
- Personalized theme colors for each person

### Data Management
- Local data storage with SwiftData
- Mock data generation for testing
- Import/export capabilities

---

## Screenshots

### iOS

| My Birthday | Friends List | Person Detail |
|-------------|--------------|---------------|
| *Placeholder* | *Placeholder* | *Placeholder* |

| Edit Person | Gift History | Settings |
|-------------|--------------|----------|
| *Placeholder* | *Placeholder* | *Placeholder* |

### macOS

| Main Window | Menu Bar Extra |
|-------------|----------------|
| *Placeholder* | *Placeholder* |

---

## Requirements

| Platform | Version |
|----------|---------|
| iOS | 18.0+ |
| macOS | 15.0+ |
| Xcode | 16.0+ |
| Swift | 6.0+ |

---

## Installation

### From Source

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/BirthdaZ.git
   cd BirthdaZ
   ```

2. **Open in Xcode**
   ```bash
   open BirthdaZ.xcodeproj
   ```

3. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd+R` to build and run

### Using Xcode

1. Open Xcode
2. File > Open
3. Navigate to the project directory
4. Select `BirthdaZ.xcodeproj`

---

## Usage

### Adding a New Person

1. Navigate to "好友生日" (Friends' Birthdays) tab
2. Tap the `+` button in the top right
3. Fill in the person's information:
   - Name
   - Nickname
   - Gender
   - Birth date
   - Calendar type (Gregorian or Lunar)
   - Theme color
4. Save the changes

### Recording a Gift

1. Open a person's detail page
2. Tap "Edit" button
3. Add a new gift in the Gift History section:
   - Gift description
   - Date sent
   - Gift type
4. Save changes

### Setting Up Your Own Birthday

1. Navigate to "我的生日" (My Birthday) tab
2. Tap the card to add your birthday
3. Enter your birth information

### Loading Mock Data

1. Go to Settings tab
2. Tap "Load data" to populate with sample data

---

## Technology Stack

| Technology | Purpose |
|------------|---------|
| **SwiftUI** | Declarative UI framework |
| **SwiftData** | Data persistence with @Model |
| **Charts** | Pie chart visualization |
| **ZhDate** | Chinese lunar calendar conversion |

### Architecture

- **MVVM Pattern** - Model-View-ViewModel architecture
- **Observable Pattern** - Using `@Observable` macro
- **Actor Model** - Thread-safe data operations with `BirthdayModelHandler`

### Key Frameworks

```
SwiftUI           - UI Development
SwiftData         - Data Persistence
Charts            - Data Visualization
UserNotifications - Birthday Reminders
OSLog             - Logging
```

---

## Project Structure

```
BirthdaZ/
├── BirthdaZApp.swift            # App entry point
├── ContentView.swift            # Platform routing
├── Person.swift                 # Person model (@Model)
├── GiftModel.swift              # Gift model (@Model)
├── BirthdayModelHandler.swift   # CRUD operations (Actor)
├── BirthdayStore.swift          # Observable store
│
├── Views/
│   ├── MainTabView.swift        # iOS tab navigation
│   ├── MainNavView.swift        # macOS split view navigation
│   ├── PeopleListView.swift     # Friends list
│   ├── PersonalView.swift       # Person detail
│   ├── EditPersonalView.swift   # Edit form
│   ├── MyBirthdayView.swift     # User's birthday
│   └── SettingsView.swift       # App settings
│
├── Components/
│   ├── AnimatedRingView.swift   # Countdown ring
│   └── SwipeAction/             # Custom swipe actions
│
├── Extensions/
│   ├── Date+Helpers.swift       # Date utilities
│   ├── NongDate+Helpers.swift   # Lunar calendar helpers
│   ├── Calendar+Helpers.swift   # Calendar utilities
│   └── Color+BirthdayModel.swift
│
└── Assets.xcassets/             # Image assets
```

For detailed documentation, see [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md).

---

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- [ZhDate](https://github.com/Zhouyuankun/ZhDate) - Chinese lunar calendar library
- Apple SwiftUI team for the amazing framework

---

<p align="center">
    Made with ❤️ by Celeglow
</p>