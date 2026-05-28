import SwiftUI

struct FilterView: View {

    @Binding var selectedCategory: String
    @Binding var selectedDate: Date
    @Binding var isDateFilterEnabled: Bool
    @State private var showDatePickerSheet = false
    @State private var dateDraft = Date()

    let categories = [
        "All",
        "Food",
        "Travel",
        "Shopping",
        "Bills",
        "Other"
    ]
    
    private let brandGreen = Color(red: 0.10, green: 0.60, blue: 0.35)
    private var hasActiveFilter: Bool {
        selectedCategory != "All" || isDateFilterEnabled
    }

    var body: some View {

        Section {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Label("Filters", systemImage: "line.3.horizontal.decrease.circle")
                        .font(.headline)
                    Spacer()
                    if hasActiveFilter {
                        Button("Clear") {
                            selectedCategory = "All"
                            isDateFilterEnabled = false
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(brandGreen)
                    }
                }
                
                Text("Category")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                
                VStack(spacing: 0) {
                    ForEach(categories, id: \.self) { category in
                        categoryButton(for: category)
                        if category != categories.last {
                            Divider()
                                .padding(.leading, 44)
                        }
                    }
                }
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .accessibilityIdentifier("filters.category")
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Label("Date", systemImage: "calendar")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Spacer()
                        Toggle("Filter by date", isOn: $isDateFilterEnabled)
                            .labelsHidden()
                            .tint(brandGreen)
                            .accessibilityIdentifier("filters.dateToggle")
                    }
                    
                    if isDateFilterEnabled {
                        Button {
                            dateDraft = selectedDate
                            showDatePickerSheet = true
                        } label: {
                            HStack {
                                Text("Date")
                                Spacer()
                                Text(selectedDate, format: .dateTime.day().month().year())
                                    .foregroundStyle(.secondary)
                                Image(systemName: "calendar")
                                    .foregroundStyle(.secondary)
                            }
                            .font(.subheadline)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("filters.datePicker")
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )
            }
            .padding(.horizontal, 0)
            .padding(.vertical, 10)
        }
        .listRowInsets(
            EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        )
        .listRowBackground(
            Color.clear
        )
        .textCase(
            nil
        )
        .listSectionSeparator(
            .hidden
        )
        .animation(
            .easeInOut(duration: 0.2),
            value: isDateFilterEnabled
        )
        .animation(
            .easeInOut(duration: 0.2),
            value: selectedCategory
        )
        .sheet(isPresented: $showDatePickerSheet) {
            NavigationStack {
                VStack {
                    DatePicker(
                        "Filter Date",
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
                            selectedDate = dateDraft
                            showDatePickerSheet = false
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(brandGreen)
                    }
                }
                .onChange(of: dateDraft) { _, newValue in
                    selectedDate = newValue
                    showDatePickerSheet = false
                }
            }
            .presentationDetents([.medium])
            .accessibilityIdentifier("filters.datePickerSheet")
        }
    }
    
    @ViewBuilder
    private func categoryButton(for category: String) -> some View {
        let isSelected = selectedCategory == category
        
        Button {
            selectedCategory = category
        } label: {
            HStack(spacing: 8) {
                Image(systemName: CategoryStyle.icon(for: category))
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(
                        CategoryStyle.color(for: category)
                    )
                    .frame(width: 22, height: 22)
                    .background(
                        Circle()
                            .fill(
                                CategoryStyle.color(for: category).opacity(0.16)
                            )
                    )
                
                Text(category == "All" ? "All Categories" : category)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                
                Spacer(minLength: 0)
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.body)
                        .foregroundStyle(brandGreen)
                } else {
                    Image(systemName: "circle")
                        .font(.body)
                        .foregroundStyle(.tertiary)
                }
            }
            .foregroundStyle(.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("filters.category.\(category.lowercased())")
    }
}
