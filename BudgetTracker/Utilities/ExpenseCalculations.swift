import Foundation

struct ExpenseCalculations {
    
    static func totalExpenses(
        expenses: [ExpenseEntity]
    ) -> Double {
        
        expenses.reduce(0) {
            $0 + $1.amount
        }
    }
    
    static func remainingBalance(
        budget: Double,
        expenses: [ExpenseEntity]
    ) -> Double {
        
        budget -
        totalExpenses(
            expenses: expenses
        )
    }
}
