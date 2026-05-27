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
}
