import SwiftUI
import CoreData

struct DashboardView: View {
    
    @Environment(
        \.managedObjectContext
    )
    var context
    
    @StateObject var expenseVM = ExpenseViewModel()
    @StateObject var budgetVM = BudgetViewModel()
    @State private var showAddExpense = false
    @State private var showBudget = false
    private var totalExpenses: Double {
        ExpenseCalculations.totalExpenses(expenses: expenseVM.expenses)
    }
    
    private var remainingBalance: Double {
        ExpenseCalculations.remainingBalance(budget: budgetVM.budget, expenses: expenseVM.expenses)
    }

    var body: some View {

        List {
            Section("Summary") {
                SummaryCard(
                    title: "Monthly Budget",
                    value: budgetVM.budget,
                    systemImage: "creditcard",
                    tint: .blue
                )
                    .listRowInsets(EdgeInsets())

                SummaryCard(
                    title: "Total Expenses",
                    value: totalExpenses,
                    systemImage: "tray.full",
                    tint: .orange
                )
                .listRowInsets(EdgeInsets())

                SummaryCard(
                    title: "Remaining Balance",
                    value: remainingBalance,
                    systemImage: "banknote",
                    tint: .green
                )
                .listRowInsets(EdgeInsets())

                BudgetProgressCard(budget: budgetVM.budget, spent: totalExpenses)
                    .listRowInsets(EdgeInsets())
            }

            Section("Spending by category") {
                PieChartView(categoryData: expenseVM.categoryTotals())
                    .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
            }
            
            ExpenseHistoryView(
                expenses: expenseVM.expenses,
                title: "Recent",
                maxCount: 5,
                onDelete: { expense in
                    expenseVM.deleteExpense(expense: expense, context: context)
                }
            )
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color.purple.opacity(0.08),
                    Color.blue.opacity(0.06)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Expense Tracker")
        .toolbar {
            
            ToolbarItem(
                placement:.topBarLeading
            ){

                Button{

                    showBudget=true

                }label:{

                    Image(
                        systemName:
                        "creditcard"
                    )
                }
                .accessibilityLabel("Set monthly budget")
                .accessibilityIdentifier("dashboard.setBudget")
            }
            
            ToolbarItem(
                placement:
                .topBarTrailing
            ) {
                
                Button {
                    
                    showAddExpense = true
                    
                } label: {
                    
                    Image(
                        systemName:
                        "cart.badge.plus"
                    )
                }
                .accessibilityLabel("Add expense")
                .accessibilityIdentifier("dashboard.add")
            }
        }
        .sheet(
            isPresented:
                $showAddExpense
        ) {
            
            AddExpenseView()
                .onDisappear {
                    expenseVM.fetchExpenses(context: context)
                }
        }
        .sheet(
            isPresented:
            $showBudget
        ){
            BudgetView()
                .onDisappear {
                    budgetVM.fetchBudget(context: context)
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
                    .frame(width: 54, height: 54)
                    .background(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 8)
            }
            .accessibilityLabel("Add expense")
            .accessibilityIdentifier("dashboard.fabAdd")
            .padding(.trailing, 18)
            .padding(.bottom, 18)
        }
    }
}
