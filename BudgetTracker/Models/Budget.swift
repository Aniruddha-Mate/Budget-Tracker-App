import Foundation

struct Expense: Identifiable {
    
    let id: UUID
    let amount: Double
    let category: String
    let date: Date
    let note: String?
    
}
