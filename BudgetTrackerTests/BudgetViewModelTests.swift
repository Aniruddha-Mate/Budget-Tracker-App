import XCTest
@testable import BudgetTracker

final class BudgetViewModelTests: XCTestCase {
    func test_fetchBudget_whenNoneSaved_returnsZero() {
        let stack = TestCoreDataStack()
        let vm = BudgetViewModel()

        vm.fetchBudget(context: stack.context)

        XCTAssertEqual(vm.budget, 0, accuracy: 0.0001)
    }

    func test_saveBudget_thenFetchBudget_persistsValue() throws {
        let stack = TestCoreDataStack()
        let vm = BudgetViewModel()

        vm.saveBudget(amount: 25000, context: stack.context)
        vm.fetchBudget(context: stack.context)

        XCTAssertEqual(vm.budget, 25000, accuracy: 0.0001)

        // Verify only one budget record exists (edit vs create)
        let req = BudgetEntity.fetchRequest()
        let budgets = try stack.context.fetch(req)
        XCTAssertEqual(budgets.count, 1)
        XCTAssertEqual(budgets.first?.monthlyBudget ?? 0, 25000, accuracy: 0.0001)
    }

    func test_saveBudget_twice_editsExistingEntity() throws {
        let stack = TestCoreDataStack()
        let vm = BudgetViewModel()

        vm.saveBudget(amount: 1000, context: stack.context)
        vm.saveBudget(amount: 2000, context: stack.context)
        vm.fetchBudget(context: stack.context)

        XCTAssertEqual(vm.budget, 2000, accuracy: 0.0001)

        let req = BudgetEntity.fetchRequest()
        let budgets = try stack.context.fetch(req)
        XCTAssertEqual(budgets.count, 1)
        XCTAssertEqual(budgets.first?.monthlyBudget ?? 0, 2000, accuracy: 0.0001)
    }
}

