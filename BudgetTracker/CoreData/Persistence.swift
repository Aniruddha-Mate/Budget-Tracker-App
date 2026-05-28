import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        
        container = NSPersistentContainer(
            name: "BudgetTracker"
        )
        
        container.loadPersistentStores {
            _, error in
            
            if let error = error {
                fatalError(
                    "Core Data failed: \(error.localizedDescription)"
                )
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func clearAllData() {
        let context = container.viewContext
        let entityNames = ["ExpenseEntity", "BudgetEntity"]
        
        entityNames.forEach { entityName in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            _ = try? context.execute(deleteRequest)
        }
        
        context.reset()
    }
}
