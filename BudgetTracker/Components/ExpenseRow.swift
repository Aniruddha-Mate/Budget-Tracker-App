import SwiftUI

struct ExpenseRow: View {
    
    let expense:
    ExpenseEntity

    private var title: String { expense.category ?? "Other" }
    private var note: String { expense.note ?? "" }
    private var tint: Color { CategoryStyle.color(for: title) }
    private var icon: String { CategoryStyle.icon(for: title) }
    
    var body: some View {
        
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(tint.opacity(0.18))
                Image(systemName: icon)
                    .foregroundStyle(tint)
                    .imageScale(.medium)
            }
            .frame(width: 36, height: 36)
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body.weight(.medium))
                    .foregroundStyle(.primary)

                HStack(spacing: 8) {
                    if let date = expense.date {
                        Text(date, format: .dateTime.day().month().year())
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    if !note.isEmpty {
                        Text(note)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }

            Spacer(minLength: 0)

            Text(expense.amount, format: .currency(code: Locale.current.currency?.identifier ?? "INR"))
                .font(.body.weight(.semibold))
                .monospacedDigit()
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 6)
    }
}
