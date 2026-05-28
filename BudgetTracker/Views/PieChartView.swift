import SwiftUI
import Charts

struct CategoryTotal: Identifiable {

    let id = UUID()
    let category: String
    let amount: Double
}

struct PieChartView: View {

    let categoryData:
    [CategoryTotal]

    var body: some View {

        if categoryData.isEmpty {
            ContentUnavailableView("No expenses yet", systemImage: "chart.pie")
                .frame(height: 220)
        } else {
            Chart(categoryData) { item in
                SectorMark(
                    angle: .value("Amount", item.amount),
                    innerRadius: .ratio(0.6),
                    angularInset: 1
                )
                .foregroundStyle(by: .value("Category", item.category))
            }
            .chartForegroundStyleScale(
                domain: categoryData.map { $0.category },
                range: categoryData.map { CategoryStyle.color(for: $0.category) }
            )
            .chartLegend(position: .bottom, alignment: .leading, spacing: 8)
            .frame(height: 260)
        }
    }
}
