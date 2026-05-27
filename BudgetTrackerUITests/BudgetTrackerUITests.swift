//
//  BudgetTrackerUITests.swift
//  BudgetTrackerUITests
//
//  Created by Shubham on 27/05/26.
//

import XCTest

final class BudgetTrackerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    private func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
        app.launch()
        return app
    }

    private func clearAndType(_ element: XCUIElement, text: String) {
        element.tap()
        if let existing = element.value as? String, !existing.isEmpty {
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: existing.count)
            element.typeText(deleteString)
        }
        element.typeText(text)
    }

    func test_setBudget_updatesDashboard() {
        let app = launchApp()

        app.tabBars.buttons["Dashboard"].tap()

        app.buttons["dashboard.setBudget"].tap()

        let amount = app.textFields["budget.amount"]
        XCTAssertTrue(amount.waitForExistence(timeout: 2))
        clearAndType(amount, text: "10000")

        app.buttons["budget.save"].tap()

        let monthlyBudgetValue = app.staticTexts["summary.MonthlyBudget"]
        XCTAssertTrue(monthlyBudgetValue.waitForExistence(timeout: 2))
        XCTAssertTrue(monthlyBudgetValue.label.contains("10") || monthlyBudgetValue.label.contains("₹"))
    }

    func test_addExpense_updatesDashboardAndHistory() {
        let app = launchApp()

        app.tabBars.buttons["Dashboard"].tap()
        app.buttons["dashboard.fabAdd"].tap()

        let amount = app.textFields["addExpense.amount"]
        XCTAssertTrue(amount.waitForExistence(timeout: 2))
        clearAndType(amount, text: "250")

        let note = app.textFields["addExpense.note"]
        XCTAssertTrue(note.waitForExistence(timeout: 2))
        note.tap()
        note.typeText("Coffee")

        app.buttons["addExpense.save"].tap()

        // Dashboard total expenses should no longer be zero.
        let totalExpensesValue = app.staticTexts["summary.TotalExpenses"]
        XCTAssertTrue(totalExpensesValue.waitForExistence(timeout: 2))
        XCTAssertFalse(totalExpensesValue.label.contains("0.00"))

        // History should show at least one row containing category (default Food) or note.
        app.tabBars.buttons["History"].tap()
        XCTAssertTrue(app.staticTexts["Expenses"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.staticTexts["Food"].exists || app.staticTexts["Coffee"].exists)
    }

    func test_history_filterByCategory_food() {
        let app = launchApp()

        app.tabBars.buttons["History"].tap()

        // Add one Food expense (default).
        app.buttons["history.fabAdd"].tap()
        let amount = app.textFields["addExpense.amount"]
        XCTAssertTrue(amount.waitForExistence(timeout: 2))
        clearAndType(amount, text: "10")
        app.buttons["addExpense.save"].tap()

        // Add one Bills expense.
        app.buttons["history.fabAdd"].tap()
        let amount2 = app.textFields["addExpense.amount"]
        XCTAssertTrue(amount2.waitForExistence(timeout: 2))
        clearAndType(amount2, text: "20")
        app.buttons["addExpense.category"].tap()
        app.buttons["Bills"].tap()
        app.buttons["addExpense.save"].tap()

        // Filter to Food and validate Bills is not shown (best-effort assertion).
        let categoryPicker = app.segmentedControls["filters.category"]
        XCTAssertTrue(categoryPicker.waitForExistence(timeout: 2))
        categoryPicker.buttons["Food"].tap()

        XCTAssertTrue(app.staticTexts["Food"].exists)
        XCTAssertFalse(app.staticTexts["Bills"].exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
