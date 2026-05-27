import Foundation
import CoreData

class BudgetViewModel: ObservableObject {
    
    @Published var budget: Double = 0
    
    func fetchBudget(
        context: NSManagedObjectContext
    ) {
        
        let request:
        NSFetchRequest<BudgetEntity> =
        BudgetEntity.fetchRequest()
        
        do {
            
            let result =
            try context.fetch(request)
            
            budget =
            result.first?.monthlyBudget ?? 0
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveBudget(
        amount: Double,
        context: NSManagedObjectContext
    ) {
        
        let request:
        NSFetchRequest<BudgetEntity> =
        BudgetEntity.fetchRequest()
        
        do {
            
            let results =
            try context.fetch(request)
            
            let budgetEntity =
            results.first ??
            BudgetEntity(
                context: context
            )
            
            budgetEntity.id = UUID()
            budgetEntity.monthlyBudget =
            amount
            
            try context.save()
            
            budget = amount
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
