import Foundation

enum ExpenseFilter {
    static func apply(
        expenses: [ExpenseEntity],
        selectedCategory: String,
        isDateFilterEnabled: Bool,
        selectedDate: Date,
        calendar: Calendar = .current
    ) -> [ExpenseEntity] {
        expenses.filter { expense in
            if selectedCategory != "All" {
                if (expense.category ?? "Other") != selectedCategory { return false }
            }

            if isDateFilterEnabled {
                guard let expenseDate = expense.date else { return false }
                return calendar.isDate(expenseDate, inSameDayAs: selectedDate)
            }

            return true
        }
    }
}

