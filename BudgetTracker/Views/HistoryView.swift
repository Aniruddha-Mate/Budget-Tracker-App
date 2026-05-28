import SwiftUI
import CoreData

struct HistoryView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss

    @StateObject private var expenseVM = ExpenseViewModel()
    @State private var selectedCategory = "All"
    @State private var selectedDate = Date()
    @State private var isDateFilterEnabled = false
    @State private var showAddExpense = false
    
    var showsCustomBackButton: Bool = false
    
    private let brandGreen = Color(red: 0.10, green: 0.60, blue: 0.35)
    private let brandMint = Color(red: 0.35, green: 0.78, blue: 0.55)

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
                    brandGreen.opacity(0.05),
                    brandMint.opacity(0.035)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(showsCustomBackButton)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbar {
            if showsCustomBackButton {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.subheadline.weight(.semibold))
                            Text("Dashboard")
                                .font(.subheadline.weight(.semibold))
                        }
                        .foregroundStyle(brandGreen)
                    }
                    .accessibilityIdentifier("history.back")
                }
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
            .accessibilityIdentifier("history.fabAdd")
            .padding(.trailing, 16)
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    HistoryView()
}

