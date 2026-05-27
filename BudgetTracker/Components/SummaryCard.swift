import SwiftUI

struct SummaryCard: View {
    
    let title: String
    let value: Double
    var systemImage: String? = nil
    var tint: Color = .accentColor
    var gradient: LinearGradient? = nil
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                if let systemImage {
                    ZStack {
                        Circle()
                            .fill(tint.opacity(0.18))
                        Image(systemName: systemImage)
                            .imageScale(.medium)
                            .foregroundStyle(tint)
                    }
                    .frame(width: 34, height: 34)
                    .accessibilityHidden(true)
                }

                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer(minLength: 0)
            }

            Text(value, format: .currency(code: Locale.current.currency?.identifier ?? "INR"))
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
                .monospacedDigit()
                .accessibilityIdentifier("summary.\(title.replacingOccurrences(of: " ", with: ""))")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(gradient ?? LinearGradient(
                    colors: [tint.opacity(0.16), Color(.systemBackground)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(.white.opacity(0.35), lineWidth: 1)
                )
        }
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)
    }
}

#Preview {
    
    SummaryCard(
        title: "Budget",
        value: 20000,
        systemImage: "creditcard",
        tint: .blue
    )
}
