import SwiftUI
import CoreData

struct HistoryView: View {
    @Environment(\.managedObjectContext) private var context

    @StateObject private var expenseVM = ExpenseViewModel()
    @State private var selectedCategory = "All"
    @State private var selectedDate = Date()
    @State private var isDateFilterEnabled = false
    @State private var showAddExpense = false

    private var filteredExpenses: [ExpenseEntity] {
        ExpenseFilter.apply(
            expenses: expenseVM.expenses,
            selectedCategory: selectedCategory,
            isDateFilterEnabled: isDateFilterEnabled,
            selectedDate: selectedDate
        )
    }

    var body: some View {
        List {
            FilterView(
                selectedCategory: $selectedCategory,
                selectedDate: $selectedDate,
                isDateFilterEnabled: $isDateFilterEnabled
            )

            ExpenseHistoryView(
                expenses: filteredExpenses,
                title: "Expenses",
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
                    Color.teal.opacity(0.07),
                    Color.pink.opacity(0.06)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .navigationTitle("History")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddExpense = true
                } label: {
                    Image(systemName: "cart.badge.plus")
                }
                .accessibilityLabel("Add expense")
                .accessibilityIdentifier("history.add")
            }
        }
        .sheet(isPresented: $showAddExpense) {
            AddExpenseView()
                .onDisappear {
                    expenseVM.fetchExpenses(context: context)
                }
        }
        .onAppear {
            expenseVM.fetchExpenses(context: context)
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
                            colors: [.pink, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 8)
            }
            .accessibilityLabel("Add expense")
            .accessibilityIdentifier("history.fabAdd")
            .padding(.trailing, 18)
            .padding(.bottom, 18)
        }
    }
}

#Preview {
    HistoryView()
}

