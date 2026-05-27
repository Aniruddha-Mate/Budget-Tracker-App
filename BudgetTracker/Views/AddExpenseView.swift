import SwiftUI

struct AddExpenseView: View {
    
    @Environment(
        \.dismiss
    )
    var dismiss
    
    @Environment(
        \.managedObjectContext
    )
    var context
    
    @StateObject
    var vm =
    ExpenseViewModel()
    
    @State private var amount =
    ""
    
    @State private var category =
    "Food"
    
    @State private var date =
    Date()
    
    @State private var note =
    ""
    
    let categories = [
        "Food",
        "Travel",
        "Shopping",
        "Bills",
        "Other"
    ]

    private var amountValue: Double? {
        Double(amount.replacingOccurrences(of: ",", with: ""))
    }
    private var canSave: Bool {
        guard let v = amountValue else { return false }
        return v > 0
    }
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                Section("Details") {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                        .accessibilityIdentifier("addExpense.amount")
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { Text($0) }
                    }
                    .accessibilityIdentifier("addExpense.category")
                    
                    DatePicker(
                        "Date",
                        selection: $date,
                        displayedComponents: .date
                    )
                    .accessibilityIdentifier("addExpense.date")
                }
                
                Section("Note (optional)") {
                    TextField("Note", text: $note, axis: .vertical)
                        .lineLimit(1...3)
                        .accessibilityIdentifier("addExpense.note")
                }
            }
            
            .navigationTitle(
                "Add Expense"
            )
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("addExpense.cancel")
                }
                
                ToolbarItem(
                    placement:
                    .topBarTrailing
                ) {
                    
                    Button(
                        "Save"
                    ) {
                        
                        vm.addExpense(
                            amount: amountValue ?? 0,
                            
                            category:
                            category,
                            
                            date:
                            date,
                            
                            note:
                            note,
                            
                            context:
                            context
                        )
                        
                        dismiss()
                    }
                    .disabled(!canSave)
                    .accessibilityIdentifier("addExpense.save")
                }
            }
        }
    }
}
