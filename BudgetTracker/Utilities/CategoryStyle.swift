import SwiftUI

enum CategoryStyle {
    static func icon(for category: String) -> String {
        switch category {
        case "Food": return "fork.knife"
        case "Travel": return "airplane"
        case "Shopping": return "bag"
        case "Bills": return "doc.text"
        default: return "square.grid.2x2"
        }
    }

    static func color(for category: String) -> Color {
        switch category {
        case "Food": return .orange
        case "Travel": return .blue
        case "Shopping": return .purple
        case "Bills": return .pink
        default: return .teal
        }
    }
}

