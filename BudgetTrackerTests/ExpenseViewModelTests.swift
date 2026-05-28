import XCTest
@testable import BudgetTracker

final class ExpenseViewModelTests: XCTestCase {
    func test_fetchExpenses_sortsByDateDescending() throws {
        let stack = TestCoreDataStack()
        let vm = ExpenseViewModel()

        let d1 = Date(timeIntervalSince1970: 100)
        let d2 = Date(timeIntervalSince1970: 200)

        _ = stack.makeExpense(amount: 10, category: "Food", date: d1)
        _ = stack.makeExpense(amount: 20, category: "Travel", date: d2)
        try stack.context.save()

        vm.fetchExpenses(context: stack.context)

        XCTAssertEqual(vm.expenses.count, 2)
        XCTAssertEqual(vm.expenses.first?.amount ?? 0, 20, accuracy: 0.0001)
        XCTAssertEqual(vm.expenses.last?.amount ?? 0, 10, accuracy: 0.0001)
    }

    func test_addExpense_persistsAndRefreshes() throws {
        let stack = TestCoreDataStack()
        let vm = ExpenseViewModel()

        vm.addExpense(amount: 99, category: "Food", date: Date(), note: "Lunch", context: stack.context)

        // VM refresh happens inside save()
        XCTAssertEqual(vm.expenses.count, 1)
        XCTAssertEqual(vm.expenses.first?.amount ?? 0, 99, accuracy: 0.0001)
        XCTAssertEqual(vm.expenses.first?.category, "Food")
        XCTAssertEqual(vm.expenses.first?.note, "Lunch")

        let req = ExpenseEntity.fetchRequest()
        let all = try stack.context.fetch(req)
        XCTAssertEqual(all.count, 1)
    }

    func test_deleteExpense_removesAndRefreshes() {
        let stack = TestCoreDataStack()
        let vm = ExpenseViewModel()

        vm.addExpense(amount: 10, category: "Food", date: Date(), note: nil, context: stack.context)
        XCTAssertEqual(vm.expenses.count, 1)

        let toDelete = vm.expenses[0]
        vm.deleteExpense(expense: toDelete, context: stack.context)

        XCTAssertEqual(vm.expenses.count, 0)
    }

    func test_categoryTotals_groupsAndSortsDescending() {
        let stack = TestCoreDataStack()
        let vm = ExpenseViewModel()

        vm.addExpense(amount: 10, category: "Food", date: Date(), note: nil, context: stack.context)
        vm.addExpense(amount: 5, category: "Food", date: Date(), note: nil, context: stack.context)
        vm.addExpense(amount: 20, category: "Bills", date: Date(), note: nil, context: stack.context)

        let totals = vm.categoryTotals()

        XCTAssertEqual(totals.count, 2)
        XCTAssertEqual(totals[0].category, "Bills")
        XCTAssertEqual(totals[0].amount, 20, accuracy: 0.0001)
        XCTAssertEqual(totals[1].category, "Food")
        XCTAssertEqual(totals[1].amount, 15, accuracy: 0.0001)
    }
}

