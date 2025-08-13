# Expense Planner

A Flutter app to track expenses with category-based filtering and animated UI.

## Features
- Add expenses with title, amount, and category.
- Filter expenses by category or view all.
- Animated addition of expense items.
- Dynamic total expense calculation per category.
- Custom icons for each expense category.
- Responsive modal dialog for adding new expenses.

## Technical Details
- Uses **StatefulWidget** for state management.
- Expense data modeled with a simple `Expense` class.
- Uses `AnimatedList` for smooth insertion animations.
- Category filtering implemented via `ChoiceChip`.
- Dialog built with `showGeneralDialog` and `StatefulBuilder` for local state.
- Amount input validated and parsed with `double.tryParse`.
- UI styled using Material Design with custom fonts and icons.

## Getting Started
1. Clone repo
2. Run `flutter pub get`
3. Run `flutter run`
