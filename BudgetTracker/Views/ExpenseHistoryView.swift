import SwiftUI

struct ExpenseHistoryView: View {
    
    let expenses:
    [ExpenseEntity]
    var title: String = "Expense History"
    var maxCount: Int? = nil
    let onDelete: (ExpenseEntity) -> Void
    
    var body: some View {
        let visibleExpenses = maxCount.map { Array(expenses.prefix($0)) } ?? expenses

        Section(title) {
            if visibleExpenses.isEmpty {
                Text("No expenses added")
                    .foregroundColor(.secondary)
            } else {
                ForEach(visibleExpenses) { expense in
                    ExpenseRow(expense: expense)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        onDelete(visibleExpenses[index])
                    }
                }
            }
        }
    }
}
