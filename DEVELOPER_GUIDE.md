# BirthdaZ Developer Guide

## Table of Contents
1. [Introduction](#introduction)
2. [Project Architecture](#project-architecture)
3. [Code Structure and Organization](#code-structure-and-organization)
4. [Data Models and Relationships](#data-models-and-relationships)
5. [Key Modules Explanation](#key-modules-explanation)
6. [UI Components and Navigation](#ui-components-and-navigation)
7. [Custom Components](#custom-components)
8. [Extensions and Helpers](#extensions-and-helpers)
9. [Third-Party Dependencies](#third-party-dependencies)
10. [Development Setup](#development-setup)
11. [Best Practices](#best-practices)

---

## Introduction

BirthdaZ is a multiplatform birthday management application built with SwiftUI and SwiftData. This guide provides comprehensive documentation for developers who want to understand, maintain, or extend the application.

### Target Audience
- iOS/macOS developers joining the project
- Contributors looking to add features
- Maintainers performing code reviews

### Key Features
- Birthday tracking with Gregorian and Chinese Lunar calendar support
- Gift tracking and visualization with pie charts
- Animated countdown rings
- Custom swipe actions for list operations
- Platform-optimized navigation (iOS TabView / macOS NavigationSplitView)

---

## Project Architecture

### Architecture Overview

BirthdaZ follows the **MVVM (Model-View-ViewModel)** architecture pattern with modern SwiftUI and SwiftData technologies:

```
┌─────────────────────────────────────────────────────────────┐
│                        Views Layer                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ ContentView  │  │PeopleListView│  │ PersonalView │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                    ViewModel Layer                          │
│  ┌──────────────┐  ┌──────────────────────────────────────┐ │
│  │ BirthdayStore│  │ BirthdayModelHandler (Actor)         │ │
│  │ (@Observable)│  │ - CRUD Operations                     │ │
│  └──────────────┘  └──────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                    Data Layer (SwiftData)                   │
│  ┌──────────────┐  ┌──────────────┐                        │
│  │    Person    │  │  GiftModel   │                        │
│  │   (@Model)   │  │   (@Model)   │                        │
│  └──────────────┘  └──────────────┘                        │
└─────────────────────────────────────────────────────────────┘
```

### Key Architectural Decisions

| Decision | Rationale |
|----------|-----------|
| SwiftData over Core Data | Modern API, less boilerplate, native SwiftUI integration |
| Actor-based data handler | Thread-safe CRUD operations, prevents data races |
| @Observable macro | Modern state management, reduces boilerplate |
| Platform-specific entry points | Optimized UX for iOS (TabView) and macOS (NavigationSplitView) |

### Data Flow

```
User Action → View → @Environment(\.modelContext) → BirthdayModelHandler → SwiftData → Disk
                     ↑                                                            │
                     └────────────────── @Query auto-refresh ────────────────────┘
```

---

## Code Structure and Organization

### Directory Structure

```
BirthdaZ/
├── App/                         # Application entry point
│   ├── BirthdaZApp.swift       # Main app entry (@main)
│   ├── ContentView.swift       # Platform routing view
│   └── Constant.swift          # App constants and enums
│
├── Models/                      # Data models
│   ├── Person.swift             # Person model (@Model)
│   ├── GiftModel.swift          # Gift tracking model (@Model)
│   ├── Gender.swift             # Gender enum
│   ├── BirthdayCalendar.swift   # Calendar type enum
│   └── ColorComponents.swift    # Color storage struct
│
├── Views/                       # View layer
│   ├── Main/
│   │   ├── MainTabView.swift    # iOS TabView navigation
│   │   └── MainNavView.swift    # macOS NavigationSplitView
│   ├── Birthday/
│   │   ├── MyBirthdayView.swift # User's birthday view
│   │   ├── PeopleListView.swift # Friends list view
│   │   ├── PersonalView.swift   # Person detail view
│   │   ├── PersonalPage.swift   # Person detail page
│   │   └── EditPersonalView.swift # Edit person form
│   ├── Settings/
│   │   └── SettingsView.swift   # App settings
│   └── Components/Personal/     # PersonalView subcomponents
│       ├── BaseInfoView.swift
│       ├── BirthdayCountView.swift
│       ├── GiftSentView.swift
│       ├── WishListView.swift
│       ├── BirthdayMomentView.swift
│       └── SingleGiftCard.swift
│
├── ViewComponents/              # Reusable UI components
│   ├── AnimatedRingView.swift   # Countdown ring component
│   ├── FriendCardView.swift     # Friend card component
│   ├── LeapMonthIconView.swift  # Leap month icon
│   └── GiftPieChartView.swift   # Pie chart view
│
├── ViewModifiers/               # View modifiers
│   ├── PersonalCardModifier.swift
│   └── PersonalButtonStyle.swift
│
├── Services/                    # Data services
│   └── BirthdayModelHandler.swift # Actor-based CRUD handler
│
├── Extensions/                  # Swift extensions
│   ├── Date+Helpers.swift       # Date utilities
│   ├── Calendar+Helpers.swift   # Calendar utilities
│   ├── NongDate+Helpers.swift   # Lunar calendar helpers
│   ├── Color+Platform.swift     # Cross-platform color helpers
│   ├── Color+BirthdayModel.swift
│   └── UserDefaults+BirthdayModel.swift
│
├── Helpers/                     # Utility functions
│   ├── ZodiacHelper.swift       # Zodiac calculation helpers
│   └── Mockjson.swift           # JSON parsing utilities
│
├── DataGeneration/              # Data generation
│   └── BirthdayModel+DataGeneration.swift
│
├── SwipeAction/                 # Swipe action module (iOS only)
│   └── Helpers/
│       ├── CustomSwipeAction.swift
│       └── PanGesture.swift
│
├── Resources/                   # Assets and resources
│   ├── Assets.xcassets/         # Image assets
│   ├── Preview Content/         # SwiftUI previews
│   └── birthdays.json           # Mock data
│
└── BirthdaZ.entitlements        # App entitlements
```

### File Naming Conventions

| Pattern | Example | Description |
|---------|---------|-------------|
| `+` suffix | `Date+Helpers.swift` | Extensions on existing types |
| `View` suffix | `PersonalView.swift` | SwiftUI views |
| `Model` suffix | `GiftModel.swift` | SwiftData models |
| `Handler` suffix | `BirthdayModelHandler.swift` | Business logic handlers |
| `Helper` suffix | `ZodiacHelper.swift` | Utility functions |

---

## Data Models and Relationships

### Person Model

**File:** `Models/Person.swift`

```swift
@Model
final public class Person: Identifiable {
    @Attribute(.unique) public var id: String
    var name: String
    var nickname: String
    var gender: Gender
    var birthDate: Date
    var birthdayCalendar: BirthdayCalendar
    var themeColor: ColorComponents
    @Relationship(deleteRule: .cascade, inverse: \GiftModel.person)
    var sentGifts: [GiftModel]

    // Transient computed properties
    @Transient var birthDateInChineseCalendar: NongDate
    @Transient var nextBirthday: Date
    @Transient var daysToNextBirthday: Int
    @Transient var age: Int
    @Transient var isBirthdayToday: Bool
}
```

### GiftModel

**File:** `Models/GiftModel.swift`

```swift
@Model
public final class GiftModel {
    @Attribute(.unique) public var id: String
    var person: Person
    var sentDate: Date
    var giftType: GiftType
    var giftDesc: String
}
```

### Entity Relationship Diagram

```
┌─────────────────┐       ┌─────────────────┐
│     Person      │       │   GiftModel     │
├─────────────────┤       ├─────────────────┤
│ id (PK)         │       │ id (PK)         │
│ name            │       │ person (FK)     │──┐
│ nickname        │       │ sentDate        │  │
│ gender          │       │ giftType        │  │
│ birthDate       │       │ giftDesc        │  │
│ birthdayCalendar│       └─────────────────┘  │
│ themeColor      │                            │
│ sentGifts ──────│────────────────────────────┘
└─────────────────┘    (1:N with cascade delete)
```

### Supporting Enums

```swift
enum Gender: String, Codable, CaseIterable {
    case undefined, male, female
}

enum BirthdayCalendar: String, Codable, CaseIterable {
    case undefined, gregorian, nongli
}

enum GiftType: String, Codable, CaseIterable {
    case electronics, foods, money, clothing, books,
         toys, jewelry, cosmetics, homeAppliances,
         furniture, subscriptions, giftCards,
         sportsEquipment, collectibles, beautyProducts,
         petSupplies, others
}
```

### ColorComponents

```swift
struct ColorComponents: Codable {
    let red: Float
    let green: Float
    let blue: Float

    var color: Color { ... }
    static func fromColor(_ color: Color) -> ColorComponents { ... }
}
```

---

## Key Modules Explanation

### BirthdayModelHandler (Actor)

**File:** `Services/BirthdayModelHandler.swift`

The `BirthdayModelHandler` is a final actor that provides thread-safe CRUD operations:

```swift
final actor BirthdayModelHandler {

    // Fetch birthdays with optional predicate and sort
    @MainActor
    static func fetchBirthdays(
        mainContext: ModelContext,
        predicate: Predicate<Person>? = nil,
        sort: [SortDescriptor<Person>] = []
    ) -> [Person]

    // Insert new birthday
    @MainActor
    static func insertBirthdayToDisk(
        mainContext: ModelContext,
        birthdayModel: Person
    )

    // Update existing birthday
    @MainActor
    static func updateBirthdayToDisk(
        mainContext: ModelContext,
        birthdayModel: Person
    )

    // Delete single birthday
    @MainActor
    static func deleteBirthdayInoDisk(
        mainContext: ModelContext,
        persistentID: PersistentIdentifier
    )

    // Delete all birthdays
    @MainActor
    static func deleteAllBirthdaysOnDisk(mainContext: ModelContext)

    // Save mock data for testing
    @MainActor
    static func saveMockedBirthdaysToDisk(mainContext: ModelContext)
}
```

**Usage Example:**
```swift
// Fetch with predicate
let results = BirthdayModelHandler.fetchBirthdays(
    mainContext: context,
    predicate: #Predicate { $0.id == myBirthdayModelID }
)

// Insert
BirthdayModelHandler.insertBirthdayToDisk(
    mainContext: context,
    birthdayModel: newPerson
)

// Delete
BirthdayModelHandler.deleteBirthdayInoDisk(
    mainContext: context,
    persistentID: person.persistentModelID
)
```

### Platform Routing (ContentView)

**File:** `App/ContentView.swift`

The `ContentView` handles platform-specific navigation:

```swift
struct ContentView: View {
    var body: some View {
        #if os(iOS)
        MainTabView()      // Tab-based navigation for iOS
        #elseif os(macOS)
        MainNavView()      // Split view navigation for macOS
        #endif
    }
}
```

---

## UI Components and Navigation

### Navigation Structure

**iOS Navigation (TabView):**
```
MainTabView
├── Tab 1: MyBirthdayView (我的生日)
├── Tab 2: PeopleListView (好友生日)
│   └── NavigationLink → PersonalView
│       └── Sheet → EditPersonalView
└── Tab 3: SettingsView
```

**macOS Navigation (NavigationSplitView):**
```
MainNavView
├── Sidebar: Menu items (Home, Add, Settings)
└── Detail: Respective views
```

### Main Views

| View | Purpose | Key Features |
|------|---------|--------------|
| `ContentView` | Platform router | Routes to MainTabView (iOS) or MainNavView (macOS) |
| `MainTabView` | iOS navigation | 3 tabs: My Birthday, Friends, Settings |
| `MainNavView` | macOS navigation | NavigationSplitView with sidebar |
| `PeopleListView` | Friends list | Sorted by next birthday, swipe-to-delete |
| `PersonalView` | Person detail | Countdown ring, gift history, pie chart |
| `EditPersonalView` | Edit form | Form-based editing, gift management |
| `MyBirthdayView` | User's birthday | Special card display |
| `SettingsView` | App settings | Notifications, data management |

---

## Custom Components

### AnimatedRingView

**File:** `ViewComponents/AnimatedRingView.swift`

Circular progress indicator for birthday countdown:

```swift
struct AnimatedRingView: View {
    var ring: Ring
    @State var showRing: Bool = false
}

struct Ring: Identifiable {
    var id = UUID().uuidString
    var progress: CGFloat    // 0-100
    var value: String
    var keyIcon: String
    var keyColor: Color
    var isText: Bool = false
}
```

**Usage:**
```swift
let progress = Int(Double(366 - daysToNextBirthday) / Double(366) * 100)
AnimatedRingView(ring: Ring(
    progress: CGFloat(progress),
    value: "Days",
    keyIcon: "figure.walk",
    keyColor: themeColor
))
```

### CustomSwipeAction

**File:** `SwipeAction/Helpers/CustomSwipeAction.swift`

Result builder-based swipe action system:

```swift
// Define actions with @ActionBuilder
.swipeActions {
    Action(symbolImage: "trash.fill",
           tint: .white,
           background: .red) { resetPosition in
        resetPosition.toggle()
        context.delete(item)
    }
}

// Configuration options
struct ActionConfig {
    var leadingPadding: CGFloat = 10
    var trailingPadding: CGFloat = 10
    var spacing: CGFloat = 10
    var occupiesFullWidth: Bool = true
}
```

**Action Model:**
```swift
struct Action: Identifiable {
    var id = UUID().uuidString
    var symbolImage: String
    var tint: Color
    var background: Color
    var font: Font = .title3
    var size: CGSize = .init(width: 45, height: 45)
    var shape: some Shape = .circle
    var action: (inout Bool) -> ()
}
```

---

## Extensions and Helpers

### Date+Helpers

**File:** `Extensions/Date+Helpers.swift`

| Method | Description |
|--------|-------------|
| `sameMonthDayInYear(year:)` | Get same date in specified year |
| `equalMonthAndDay(with:)` | Compare month/day equality |
| `nongDate` | Convert to lunar date (NongDate) |
| `sameMonthAndDayInNextYear` | Get next occurrence of this date |
| `isBirthdayToday(birthdayCalendar:)` | Check if birthday is today |
| `nextBirthday(birthdayCalendar:)` | Calculate next birthday |
| `dateToString(stringFormat:)` | Format date to string |
| `monthdayCHString` | Chinese month/day string (一月一日) |

**Example:**
```swift
// Check if birthday is today
let isToday = birthDate.isBirthdayToday(birthdayCalendar: .nongli)

// Get next birthday
let next = birthDate.nextBirthday(birthdayCalendar: .gregorian)

// Convert to lunar date
let lunar = Date.now.nongDate
```

### NongDate+Helpers

**File:** `Extensions/NongDate+Helpers.swift`

```swift
extension NongDate {
    func equalMonthAndDay(with anotherDate: NongDate) -> Bool
    var sameMonthAndDayInNextYear: NongDate
    var monthdayNumString: String  // "MM-DD" format
}
```

### Calendar+Helpers

**File:** `Extensions/Calendar+Helpers.swift`

```swift
extension Calendar {
    func numberOfDaysBetween(from: Date, to: Date) -> Int
}
```

### Color+BirthdayModel

**File:** `Extensions/Color+BirthdayModel.swift`

```swift
extension Color {
    static func getRandomColor() -> Color
}
```

### UserDefaults+BirthdayModel

**File:** `Extensions/UserDefaults+BirthdayModel.swift`

```swift
extension UserDefaults {
    static func saveBirthdayModelID(birthdayModelID: String)
    static func loadBirthdayModelID() -> String?
}
```

---

## Third-Party Dependencies

### ZhDate

**Repository:** https://github.com/Zhouyuankun/ZhDate

**Purpose:** Chinese lunar calendar conversion

**Usage:**
```swift
import ZhDate

// Convert Gregorian to Lunar
let nongDate = Date.now.nongDate  // NongDate type

// Access lunar components
nongDate.lunarMonth
nongDate.lunarDay
nongDate.leapMonth
```

**Integration:** Swift Package Manager (SPM)

---

## Development Setup

### Requirements

| Platform | Version |
|----------|---------|
| iOS | 18.0+ |
| macOS | 15.0+ |
| Xcode | 16.0+ |
| Swift | 6.0+ |

### Getting Started

```bash
# Clone the repository
git clone <repository-url>
cd BirthdaZ

# Open in Xcode
open BirthdaZ.xcodeproj
```

### Project Configuration

1. Select target device/simulator
2. Build and run (Cmd+R)
3. For testing mock data: Settings > Load data

### SwiftData Model Container

The app initializes SwiftData at app launch:

```swift
@main
struct BirthdazApp: App {
    var body: some Scene {
        WindowGroup(id: Constant.WindowID_BirthdazPanel.rawValue) {
            ContentView()
                .modelContainer(for: [Person.self])
        }
        #if os(macOS)
        MenuBarExtra(content: {
            Button("Show panel") { openWindow(id: WindowID.birthdazPanel.rawValue) }
            Button("Quit") { NSApplication.shared.terminate(nil) }
        }, label: {
            Label("Birthdaz", systemImage: "gift.fill")
        })
        #endif
    }
}
```

---

## Best Practices

### SwiftData Best Practices

- Always use `@Attribute(.unique)` for IDs
- Use `@Relationship` with delete rules for cascading deletes
- Perform saves on MainActor
- Use `@Query` for automatic UI updates
- Use `@Transient` for computed properties that shouldn't be persisted

### SwiftUI Best Practices

- Extract reusable components into separate files
- Use `@Environment` for dependency injection
- Prefer `@State` for local view state
- Use `@Bindable` for two-way binding with @Observable classes
- Use `#if os(iOS)` / `#elseif os(macOS)` for platform-specific code

### Code Style

- Use meaningful variable names
- Document complex logic with comments
- Follow Swift naming conventions
- Keep views focused and small
- Use extensions to organize related functionality

### Platform Considerations

```swift
// Use conditional compilation for platform-specific code
#if os(iOS)
// iOS-specific code
#elseif os(macOS)
// macOS-specific code
#endif
```

---

## License

This project is licensed under the MIT License.

---

*Generated for BirthdaZ - A multiplatform birthday management app*