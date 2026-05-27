import Foundation
import CoreData
import SwiftUI

class ExpenseViewModel: ObservableObject {
    
    @Published var expenses: [ExpenseEntity] = []
    
    func fetchExpenses(
        context: NSManagedObjectContext
    ) {
        
        let request: NSFetchRequest<ExpenseEntity> =
        ExpenseEntity.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(
                keyPath: \ExpenseEntity.date,
                ascending: false
            )
        ]
        
        do {
            expenses = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addExpense(
        amount: Double,
        category: String,
        date: Date,
        note: String?,
        context: NSManagedObjectContext
    ) {
        
        let expense = ExpenseEntity(
            context: context
        )
        
        expense.id = UUID()
        expense.amount = amount
        expense.category = category
        expense.date = date
        expense.note = note
        
        save(context: context)
    }
    
    func deleteExpense(
        expense: ExpenseEntity,
        context: NSManagedObjectContext
    ) {
        
        context.delete(expense)
        
        save(context: context)
    }
    
    func save(
        context: NSManagedObjectContext
    ) {
        
        do {
            try context.save()
            
            fetchExpenses(
                context: context
            )
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func categoryTotals(
        expenses: [ExpenseEntity]? = nil
    ) -> [CategoryTotal] {
        let source = expenses ?? self.expenses

        let grouped = Dictionary(grouping: source) { $0.category ?? "Other" }

        return grouped
            .map {
                CategoryTotal(
                    category: $0.key,
                    amount: $0.value.reduce(0) { $0 + $1.amount }
                )
            }
            .sorted { $0.amount > $1.amount }
    }
}
