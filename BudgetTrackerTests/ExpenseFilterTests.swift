import XCTest
@testable import BudgetTracker

final class ExpenseFilterTests: XCTestCase {
    func test_apply_allCategory_noDateFilter_returnsAll() {
        let stack = TestCoreDataStack()
        let d = Date()
        let e1 = stack.makeExpense(amount: 1, category: "Food", date: d)
        let e2 = stack.makeExpense(amount: 2, category: "Bills", date: d)

        let result = ExpenseFilter.apply(
            expenses: [e1, e2],
            selectedCategory: "All",
            isDateFilterEnabled: false,
            selectedDate: d,
            calendar: Calendar(identifier: .gregorian)
        )

        XCTAssertEqual(result.count, 2)
    }

    func test_apply_categoryFiltersCorrectly() {
        let stack = TestCoreDataStack()
        let d = Date()
        let e1 = stack.makeExpense(amount: 1, category: "Food", date: d)
        let e2 = stack.makeExpense(amount: 2, category: "Bills", date: d)

        let result = ExpenseFilter.apply(
            expenses: [e1, e2],
            selectedCategory: "Food",
            isDateFilterEnabled: false,
            selectedDate: d,
            calendar: Calendar(identifier: .gregorian)
        )

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.category, "Food")
    }

    func test_apply_dateFilter_sameDayMatches() {
        let stack = TestCoreDataStack()
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(secondsFromGMT: 0)!

        let day = Date(timeIntervalSince1970: 86_400) // Jan 2, 1970 UTC
        let sameDayLater = Date(timeIntervalSince1970: 86_400 + 3600)
        let nextDay = Date(timeIntervalSince1970: 86_400 * 2)

        let e1 = stack.makeExpense(amount: 1, category: "Food", date: sameDayLater)
        let e2 = stack.makeExpense(amount: 2, category: "Food", date: nextDay)

        let result = ExpenseFilter.apply(
            expenses: [e1, e2],
            selectedCategory: "All",
            isDateFilterEnabled: true,
            selectedDate: day,
            calendar: cal
        )

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.amount ?? 0, 1, accuracy: 0.0001)
    }
}

