import SwiftUI

struct BudgetProgressCard: View {
    let budget: Double
    let spent: Double

    private var progress: Double {
        guard budget > 0 else { return 0 }
        return min(max(spent / budget, 0), 1)
    }

    private var tint: Color {
        if budget <= 0 { return .gray }
        if progress < 0.7 { return .green }
        if progress < 0.9 { return .orange }
        return .red
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                ZStack {
                    Circle().fill(tint.opacity(0.18))
                    Image(systemName: "chart.bar.fill")
                        .foregroundStyle(tint)
                }
                .frame(width: 34, height: 34)
                .accessibilityHidden(true)

                Text("Budget used")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer(minLength: 0)

                Text(progress, format: .percent.precision(.fractionLength(0)))
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                    .foregroundStyle(.primary)
            }

            ProgressView(value: progress)
                .tint(tint)

            HStack {
                Text(spent, format: .currency(code: Locale.current.currency?.identifier ?? "INR"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
                Spacer()
                if budget > 0 {
                    Text(budget, format: .currency(code: Locale.current.currency?.identifier ?? "INR"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                } else {
                    Text("Set a budget")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [tint.opacity(0.14), Color(.systemBackground)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(.white.opacity(0.35), lineWidth: 1)
                )
        }
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)
    }
}

#Preview {
    BudgetProgressCard(budget: 20000, spent: 8200)
        .padding()
}

