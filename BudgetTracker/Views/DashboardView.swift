import SwiftUI
import CoreData

struct DashboardView: View {
    var onSeeAllTapped: () -> Void = {}
    
    @Environment(
        \.managedObjectContext
    )
    var context
    
    @StateObject var expenseVM = ExpenseViewModel()
    @StateObject var budgetVM = BudgetViewModel()
    @State private var showAddExpense = false
    @State private var isEditingBudget = false
    @State private var budgetInput = ""
    
    private let brandGreen = Color(red: 0.10, green: 0.60, blue: 0.35)
    private let brandMint = Color(red: 0.35, green: 0.78, blue: 0.55)
    private var totalExpenses: Double {
        ExpenseCalculations.totalExpenses(expenses: expenseVM.expenses)
    }
    
    private var remainingBalance: Double {
        ExpenseCalculations.remainingBalance(budget: budgetVM.budget, expenses: expenseVM.expenses)
    }
    
    private var spentPercent: Double {
        guard budgetVM.budget > 0 else { return 0 }
        return min(max(totalExpenses / budgetVM.budget, 0), 1)
    }
    
    private var currencyCode: String {
        Locale.current.currency?.identifier ?? "INR"
    }
    
    private var parsedBudgetInput: Double? {
        Double(budgetInput.replacingOccurrences(of: ",", with: ""))
    }
    
    private var canSaveInlineBudget: Bool {
        guard let value = parsedBudgetInput else { return false }
        return value >= 0
    }
    
    private func beginBudgetEdit() {
        budgetInput = budgetVM.budget == 0 ? "" : String(format: "%.0f", budgetVM.budget)
        isEditingBudget = true
    }
    
    private func cancelBudgetEdit() {
        isEditingBudget = false
    }
    
    private func saveInlineBudget() {
        guard canSaveInlineBudget else { return }
        budgetVM.saveBudget(amount: parsedBudgetInput ?? 0, context: context)
        cancelBudgetEdit()
    }

    var body: some View {

        ScrollView {
            LazyVStack(alignment: .leading, spacing: 14) {
                HeroBudgetCard(
                    budget: budgetVM.budget,
                    budgetInput: $budgetInput,
                    isEditingBudget: $isEditingBudget,
                    currencyCode: currencyCode,
                    brandGreen: brandGreen,
                    brandMint: brandMint,
                    canSave: canSaveInlineBudget,
                    onStartEdit: beginBudgetEdit,
                    onCancelEdit: cancelBudgetEdit,
                    onSaveEdit: saveInlineBudget
                )
                .padding(.top, 8)
                
                HStack(spacing: 12) {
                    MetricMiniCard(
                        title: "Expenses",
                        valueText: totalExpenses.formatted(.currency(code: currencyCode)),
                        systemImage: "tray.full",
                        tint: .red
                    )
                    MetricMiniCard(
                        title: "Balance",
                        valueText: remainingBalance.formatted(.currency(code: currencyCode)),
                        systemImage: "banknote",
                        tint: brandMint
                    )
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Spending Overview")
                            .font(.headline)
                        Spacer()
                        Text("This Month")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    PieChartView(categoryData: expenseVM.categoryTotals())
                        .frame(maxWidth: .infinity)
                }
                .padding(16)
                .background(CardBackground())
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Recent Expenses")
                            .font(.headline)
                        Spacer()
                        Button {
                            onSeeAllTapped()
                        } label: {
                            Text("See all")
                                .font(.subheadline)
                                .foregroundStyle(brandGreen)
                        }
                    }
                    
                    let recent = Array(expenseVM.expenses.prefix(5))
                    if recent.isEmpty {
                        Text("No expenses added")
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 10)
                    } else {
                        VStack(spacing: 0) {
                            let lastId = recent.last?.objectID
                            ForEach(recent) { expense in
                                ExpenseRow(expense: expense)
                                    .padding(.vertical, 2)
                                
                                if let lastId, expense.objectID != lastId {
                                    Divider()
                                        .opacity(0.6)
                                }
                            }
                        }
                        .padding(.top, 2)
                    }
                }
                .padding(16)
                .background(CardBackground())
                
                BudgetProgressCard(budget: budgetVM.budget, spent: totalExpenses)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 90)
        }
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
        .navigationTitle("Expense Tracker")
        .navigationBarTitleDisplayMode(.large)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .sheet(
            isPresented:
                $showAddExpense
        ) {
            AddExpenseView()
                .onDisappear {
                    expenseVM.fetchExpenses(context: context)
                }
        }
        .onAppear {
            expenseVM.fetchExpenses(
                context: context
            )
            budgetVM.fetchBudget(
                context: context
            )
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                showAddExpense = true
            } label: {
                Image(systemName: "cart.badge.plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(
                        LinearGradient(
                            colors: [brandGreen, brandMint],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.14), radius: 8, x: 0, y: 5)
            }
            .accessibilityLabel("Add expense")
            .accessibilityIdentifier("dashboard.fabAdd")
            .padding(.trailing, 16)
            .padding(.bottom, 16)
        }
    }
}

private struct CardBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(.thinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(.white.opacity(0.20), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

private struct HeroBudgetCard: View {
    let budget: Double
    @Binding var budgetInput: String
    @Binding var isEditingBudget: Bool
    let currencyCode: String
    let brandGreen: Color
    let brandMint: Color
    let canSave: Bool
    let onStartEdit: () -> Void
    let onCancelEdit: () -> Void
    let onSaveEdit: () -> Void
    
    private var currencySymbol: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = .current
        return formatter.currencySymbol ?? "₹"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Monthly Budget")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                Spacer()
                if isEditingBudget {
                    Button("Cancel", action: onCancelEdit)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.92))
                } else {
                    Button(action: onStartEdit) {
                        Text("Set budget")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.95))
                    }
                    .accessibilityLabel("Edit monthly budget")
                    .accessibilityIdentifier("dashboard.setBudget")
                }
            }
            
            if isEditingBudget {
                HStack(spacing: 10) {
                    Text(currencySymbol)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.9))
                    TextField("0", text: $budgetInput)
                        .keyboardType(.decimalPad)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                        .monospacedDigit()
                        .accessibilityIdentifier("dashboard.inlineBudget")
                }
                
                Button(action: onSaveEdit) {
                    Text("Save Budget")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(brandGreen)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .disabled(!canSave)
                .opacity(canSave ? 1 : 0.55)
            } else {
                Text(budget, format: .currency(code: currencyCode))
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .monospacedDigit()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [brandGreen, brandGreen.opacity(0.92), brandMint.opacity(0.80)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.10), radius: 10, x: 0, y: 6)
        )
    }
}

private struct MetricMiniCard: View {
    let title: String
    let valueText: String
    let systemImage: String
    let tint: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(tint.opacity(0.16))
                    Image(systemName: systemImage)
                        .foregroundStyle(tint)
                        .imageScale(.small)
                }
                .frame(width: 26, height: 26)
                .accessibilityHidden(true)
                
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer(minLength: 0)
            }
            
            Text(valueText)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(CardBackground())
    }
}
