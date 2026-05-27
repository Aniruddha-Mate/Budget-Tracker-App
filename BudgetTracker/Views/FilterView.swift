import SwiftUI

struct FilterView: View {

    @Binding var selectedCategory: String
    @Binding var selectedDate: Date
    @Binding var isDateFilterEnabled: Bool

    let categories = [
        "All",
        "Food",
        "Travel",
        "Shopping",
        "Bills",
        "Other"
    ]

    var body: some View {

        Section("Filters") {
            Picker("Category", selection: $selectedCategory) {
                ForEach(categories, id: \.self) { Text($0) }
            }
            .pickerStyle(.segmented)
            .accessibilityIdentifier("filters.category")

            Toggle("Filter by date", isOn: $isDateFilterEnabled)
                .accessibilityIdentifier("filters.dateToggle")

            if isDateFilterEnabled {
                DatePicker(
                    "Date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
                .accessibilityIdentifier("filters.datePicker")
            }
        }
    }
}
