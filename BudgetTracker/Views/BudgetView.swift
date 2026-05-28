import SwiftUI

struct BudgetView: View {

    @Environment(\.managedObjectContext) var context

    @Environment(\.dismiss) var dismiss

    @StateObject var budgetVM = BudgetViewModel()

    @State private var budget = ""
    @FocusState private var isBudgetFieldFocused: Bool
    
    private let brandGreen = Color(red: 0.10, green: 0.60, blue: 0.35)
    private let brandMint = Color(red: 0.35, green: 0.78, blue: 0.55)

    private var currencyCode: String {
        Locale.current.currency?.identifier ?? "INR"
    }
    private var currencySymbol: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.currencySymbol ?? "₹"
    }
    
    private var budgetValue: Double? {
        Double(budget.replacingOccurrences(of: ",", with: ""))
    }
    private var canSave: Bool {
        guard let v = budgetValue else { return false }
        return v >= 0
    }
    
    private func saveBudget() {
        isBudgetFieldFocused = false
        budgetVM.saveBudget(
            amount: budgetValue ?? 0,
            context: context
        )
        dismiss()
    }

    var body: some View {

        NavigationStack {

            Form {
                Section("Monthly Budget") {
                    HStack(spacing: 10) {
                        Text(currencySymbol)
                            .font(.headline)
                            .foregroundStyle(.secondary)

                        TextField("0", text: $budget)
                            .keyboardType(.decimalPad)
                            .focused($isBudgetFieldFocused)
                            .accessibilityIdentifier("budget.amount")
                    }

                    Text("Current value: \(budgetVM.budget, format: .currency(code: currencyCode))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .scrollContentBackground(.hidden)
            .background(
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        brandGreen.opacity(0.05),
                        brandMint.opacity(0.035)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationTitle(
                "Set Budget"
            )
            .navigationBarTitleDisplayMode(.inline)
            .tint(brandGreen)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("budget.cancel")
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isBudgetFieldFocused = false
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    saveBudget()
                } label: {
                    Text("Save Budget")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(
                            LinearGradient(
                                colors: [brandGreen, brandMint],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 4)
                }
                .disabled(!canSave)
                .opacity(canSave ? 1 : 0.55)
                .accessibilityIdentifier("budget.save")
                .padding(.horizontal, 16)
                .padding(.top, 6)
                .padding(.bottom, 6)
                .background(.ultraThinMaterial)
            }
            .onAppear {
                budgetVM.fetchBudget(context: context)
                budget = budgetVM.budget == 0 ? "" : String(format: "%.0f", budgetVM.budget)
            }
        }
    }
}
