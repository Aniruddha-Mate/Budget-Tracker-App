import SwiftUI

struct AddExpenseView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context
    @StateObject var vm = ExpenseViewModel()
    @State private var amount = ""
    @State private var category = "Food"
    @State private var date = Date()
    @State private var dateDraft = Date()
    @State private var showDatePickerSheet = false
    @State private var note = ""
    private let brandGreen = Color(red: 0.10, green: 0.60, blue: 0.35)
    private let brandMint = Color(red: 0.35, green: 0.78, blue: 0.55)
    
    @FocusState private var isAmountFocused: Bool
    @FocusState private var isNoteFocused: Bool
    
    private var currencyCode: String {
        Locale.current.currency?.identifier ?? "INR"
    }
    private var currencySymbol: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter.currencySymbol ?? "₹"
    }
    
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
    
    private func saveExpense() {
        isAmountFocused = false
        isNoteFocused = false
        
        vm.addExpense(
            amount: amountValue ?? 0,
            category: category,
            date: date,
            note: note,
            context: context
        )
        
        dismiss()
    }
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                Section("Details") {
                    HStack(spacing: 10) {
                        Text(currencySymbol)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        TextField("0", text: $amount)
                            .keyboardType(.decimalPad)
                            .focused($isAmountFocused)
                            .accessibilityIdentifier("addExpense.amount")
                    }
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.menu)
                    .accessibilityIdentifier("addExpense.category")
                    
                    Button {
                        dateDraft = date
                        showDatePickerSheet = true
                    } label: {
                        HStack {
                            Text("Date")
                            Spacer()
                            Text(date, format: .dateTime.day().month().year())
                                .foregroundStyle(.secondary)
                            Image(systemName: "calendar")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .accessibilityIdentifier("addExpense.date")
                }
                
                Section("Note (optional)") {
                    TextField("Note", text: $note, axis: .vertical)
                        .lineLimit(1...3)
                        .focused($isNoteFocused)
                        .accessibilityIdentifier("addExpense.note")
                }
                
                if let amountValue {
                    Section("Preview") {
                        LabeledContent("Amount") {
                            Text(
                                amountValue,
                                format: .currency(code: currencyCode)
                            )
                            .fontWeight(.semibold)
                        }
                        LabeledContent("Category") {
                            Text(category)
                        }
                        LabeledContent("Date") {
                            Text(date, format: .dateTime.day().month().year())
                        }
                    }
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
                "Add Expense"
            )
            .navigationBarTitleDisplayMode(.inline)
            .tint(brandGreen)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(brandGreen)
                    }
                    .accessibilityLabel("Close")
                        .accessibilityIdentifier("addExpense.cancel")
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isAmountFocused = false
                        isNoteFocused = false
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 10) {
                    Button {
                        saveExpense()
                    } label: {
                        Text("Save Expense")
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
                    .accessibilityIdentifier("addExpense.save")
                }
                .padding(.horizontal, 16)
                .padding(.top, 6)
                .padding(.bottom, 6)
                .background(.ultraThinMaterial)
            }
            .sheet(isPresented: $showDatePickerSheet) {
                NavigationStack {
                    VStack {
                        DatePicker(
                            "Expense Date",
                            selection: $dateDraft,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .padding()
                    }
                    .navigationTitle("Select Date")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") {
                                date = dateDraft
                                showDatePickerSheet = false
                            }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(brandGreen)
                        }
                    }
                    .onChange(of: dateDraft) { _, newValue in
                        date = newValue
                        showDatePickerSheet = false
                    }
                }
                .presentationDetents([.medium])
                .accessibilityIdentifier("addExpense.datePickerSheet")
            }
        }
    }
}
