import XCTest
@testable import BudgetTracker

final class ExpenseCalculationsTests: XCTestCase {
    func test_totalExpenses_empty_isZero() {
        XCTAssertEqual(ExpenseCalculations.totalExpenses(expenses: []), 0, accuracy: 0.0001)
    }

    func test_totalExpenses_sumsAmounts() {
        let stack = TestCoreDataStack()
        let d = Date()
        let e1 = stack.makeExpense(amount: 10, category: "Food", date: d)
        let e2 = stack.makeExpense(amount: 25.5, category: "Bills", date: d)
        XCTAssertEqual(ExpenseCalculations.totalExpenses(expenses: [e1, e2]), 35.5, accuracy: 0.0001)
    }

    func test_remainingBalance_budgetMinusTotal() {
        let stack = TestCoreDataStack()
        let d = Date()
        let e1 = stack.makeExpense(amount: 40, category: "Food", date: d)
        let e2 = stack.makeExpense(amount: 10, category: "Travel", date: d)
        XCTAssertEqual(
            ExpenseCalculations.remainingBalance(budget: 100, expenses: [e1, e2]),
            50,
            accuracy: 0.0001
        )
    }
}

