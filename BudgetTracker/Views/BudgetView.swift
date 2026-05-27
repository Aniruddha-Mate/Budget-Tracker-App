import SwiftUI

struct BudgetView: View {

    @Environment(\.managedObjectContext)
    var context

    @Environment(\.dismiss)
    var dismiss

    @StateObject
    var budgetVM = BudgetViewModel()

    @State private var budget = ""
    
    private var budgetValue: Double? {
        Double(budget.replacingOccurrences(of: ",", with: ""))
    }
    private var canSave: Bool {
        guard let v = budgetValue else { return false }
        return v >= 0
    }

    var body: some View {

        NavigationStack {

            Form {

                Section("Monthly budget") {
                    TextField("Amount", text: $budget)
                        .keyboardType(.decimalPad)
                        .accessibilityIdentifier("budget.amount")
                }

            }
            .navigationTitle(
                "Set Budget"
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("budget.cancel")
                }

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button("Save") {

                        budgetVM.saveBudget(
                            amount: budgetValue ?? 0,
                            context: context
                        )

                        dismiss()
                    }
                    .disabled(!canSave)
                    .accessibilityIdentifier("budget.save")
                }
            }
            .onAppear {
                budgetVM.fetchBudget(context: context)
                budget = budgetVM.budget == 0 ? "" : String(format: "%.0f", budgetVM.budget)
            }
        }
    }
}
