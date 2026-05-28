# BudgetTracker

BudgetTracker is an iOS application built using SwiftUI and Core Data that helps users manage their monthly budget and track daily expenses. The app allows users to add expenses, categorize spending, set a monthly budget, and visualize spending patterns using charts.

## Features

### Dashboard
- Display Monthly Budget
- Display Total Expenses
- Display Remaining Balance
- Real-time updates based on expense entries

### Expense Management
- Add new expenses
- Enter:
    - Amount
    - Category
    - Date
    - Optional Notes
- View expense history
- Delete expenses

### Budget Management
- Set monthly budget
- Edit monthly budget

### Filters
- Filter expenses by:
    - Category
    - Date

### Charts
- Pie chart visualization of spending categories
- Implemented using Swift Charts

### Data Persistence
- Local storage using Core Data
- No network/API dependency

---

## Architecture

Project follows MVVM architecture:

```text
BudgetTracker
│
├── Models
├── CoreData
├── ViewModels
├── Views
├── Components
├── Utilities
```

### Components

**Models**
- Handles application data structures

**ViewModels**
- Business logic
- Data handling
- Core Data operations

**Views**
- User interface screens

**Components**
- Reusable UI components

**Utilities**
- Helper methods and calculations

---

## Technologies Used

- Swift
- SwiftUI
- Core Data
- Swift Charts
- MVVM Architecture

---

## Core Data Entities

### ExpenseEntity

| Property | Type |
|-----------|------|
| id | UUID |
| amount | Double |
| category | String |
| date | Date |
| note | String |

### BudgetEntity

| Property | Type |
|-----------|------|
| id | UUID |
| monthlyBudget | Double |

---

## Requirements

- iOS 16+
- Xcode 16+
- Swift 5+

---

## Steps to Run

1. Clone repository

```bash
git clone https://github.com/yourusername/BudgetTracker.git
```

2. Open project

```bash
BudgetTracker.xcodeproj
```

3. Run application

Select simulator:

```text
iPhone 16
```

Press:

```text
⌘ + R
```

---

## Future Improvements

- Dark mode customization
- Expense editing functionality
- Monthly analytics
- Export reports as PDF
- Budget notifications

---

## Demo

Video demo link:

(Add Google Drive link here)

---

## Author

Aniruddha Mate
