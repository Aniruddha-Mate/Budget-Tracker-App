import SwiftUI

@main
struct BudgetTrackerApp: App {
    
    let persistenceController =
    PersistenceController.shared
    
    init() {
        if ProcessInfo.processInfo.arguments.contains("-ui-testing") {
            persistenceController.clearAllData()
            return
        }
        
        let wipeKey = "didWipeExistingDataOnce"
        if !UserDefaults.standard.bool(forKey: wipeKey) {
            persistenceController.clearAllData()
            UserDefaults.standard.set(true, forKey: wipeKey)
        }
    }
    
    var body: some Scene {
        
        WindowGroup {
            
            ContentView()
                .environment(
                    \.managedObjectContext,
                     persistenceController
                        .container
                        .viewContext
                )
        }
    }
}
