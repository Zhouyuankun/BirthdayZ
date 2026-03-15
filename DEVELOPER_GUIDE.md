# BirthdaZ Developer Guide

## Architecture

**MVVM with SwiftData**:
```
┌─────────────────────────────────────────┐
│              Views Layer                 │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│  BirthdayModelHandler (Actor) - CRUD    │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│  SwiftData: Person, GiftModel (@Model)  │
└─────────────────────────────────────────┘
```

**Data Flow**: `View → @Environment(\.modelContext) → BirthdayModelHandler → SwiftData → @Query refresh`

## Directory Structure

```
BirthdaZ/
├── App/                         # BirthdaZApp.swift, ContentView.swift, Constant.swift
├── Models/                      # Person, GiftModel, Gender, BirthdayCalendar, ColorComponents
├── Views/
│   ├── Main/                    # MainTabView (iOS), MainNavView (macOS)
│   ├── Birthday/                # MyBirthdayView, PeopleListView, PersonalView, EditPersonalView
│   ├── Settings/                # SettingsView
│   └── Components/Personal/     # BaseInfoView, BirthdayCountView, GiftSentView, etc.
├── ViewComponents/              # AnimatedRingView, FriendCardView, GiftPieChartView
├── ViewModifiers/               # PersonalCardModifier, PersonalButtonStyle
├── Services/                    # BirthdayModelHandler (Actor)
├── Extensions/                  # Date+Helpers, Calendar+Helpers, NongDate+Helpers, Color+, UserDefaults+
├── Helpers/                     # ZodiacHelper, Mockjson
├── DataGeneration/              # BirthdayModel+DataGeneration
├── SwipeAction/                 # CustomSwipeAction, PanGesture
└── Resources/                   # Assets.xcassets, birthdays.json
```

## Data Models

### Person
```swift
@Model final public class Person: Identifiable {
    @Attribute(.unique) public var id: String
    var name, nickname: String
    var gender: Gender
    var birthDate: Date
    var birthdayCalendar: BirthdayCalendar
    var themeColor: ColorComponents
    @Relationship(deleteRule: .cascade, inverse: \GiftModel.person) var sentGifts: [GiftModel]

    @Transient var nextBirthday: Date
    @Transient var daysToNextBirthday: Int
    @Transient var age: Int
    @Transient var isBirthdayToday: Bool
    @Transient var birthDateInChineseCalendar: NongDate
}
```

### GiftModel
```swift
@Model public final class GiftModel {
    @Attribute(.unique) public var id: String
    var person: Person
    var sentDate: Date
    var giftType: GiftType
    var giftDesc: String
}
```

### Enums
- `Gender`: undefined, male, female
- `BirthdayCalendar`: undefined, gregorian, nongli
- `GiftType`: electronics, foods, money, clothing, books, toys, jewelry, cosmetics, etc.

## BirthdayModelHandler

Actor-based CRUD in `Services/BirthdayModelHandler.swift`:

```swift
final actor BirthdayModelHandler {
    @MainActor static func fetchBirthdays(mainContext: ModelContext, predicate: Predicate<Person>?, sort: [SortDescriptor<Person>]) -> [Person]
    @MainActor static func insertBirthdayToDisk(mainContext: ModelContext, birthdayModel: Person)
    @MainActor static func updateBirthdayToDisk(mainContext: ModelContext, birthdayModel: Person)
    @MainActor static func deleteBirthdayInoDisk(mainContext: ModelContext, persistentID: PersistentIdentifier)
    @MainActor static func deleteAllBirthdaysOnDisk(mainContext: ModelContext)
    @MainActor static func saveMockedBirthdaysToDisk(mainContext: ModelContext)
}
```

## Navigation

**iOS** (`MainTabView`):
```
Tab 1: MyBirthdayView → Tab 2: PeopleListView → PersonalView → EditPersonalView → Tab 3: SettingsView
```

**macOS** (`MainNavView`):
```
NavigationSplitView: Sidebar (Home, Add, Settings) → Detail views
MenuBarExtra: Show panel, Quit
```

## Custom Components

### AnimatedRingView
Circular countdown progress. `Ring(progress: CGFloat, value: String, keyIcon: String, keyColor: Color)`

### CustomSwipeAction
Result builder swipe actions. `.swipeActions { Action(...) }`

## Extensions

| File | Key Methods |
|------|-------------|
| `Date+Helpers` | `nongDate`, `nextBirthday(birthdayCalendar:)`, `isBirthdayToday(birthdayCalendar:)` |
| `NongDate+Helpers` | `equalMonthAndDay(with:)`, `sameMonthAndDayInNextYear` |
| `Calendar+Helpers` | `numberOfDaysBetween(from:to:)` |
| `Color+BirthdayModel` | `getRandomColor()` |
| `UserDefaults+BirthdayModel` | `saveBirthdayModelID()`, `loadBirthdayModelID()` |

## Third-Party

**ZhDate** (https://github.com/Zhouyuankun/ZhDate) - Lunar calendar:
```swift
let nongDate = Date.now.nongDate  // NongDate with lunarMonth, lunarDay, leapMonth
```

## Requirements

iOS 18.0+, macOS 15.0+, Xcode 16.0+, Swift 6.0+

## Getting Started

```bash
git clone <repo>
cd BirthdaZ
open BirthdaZ.xcodeproj
# Cmd+R to build and run
# Settings > Load data for mock data
```