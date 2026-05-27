import CoreData
import XCTest

final class TestCoreDataStack {
    let container: NSPersistentContainer

    var context: NSManagedObjectContext { container.viewContext }

    init() {
        // Try app bundle first (normal for iOS unit tests), then fall back.
        let bundlesToTry: [Bundle] = [Bundle.main, Bundle(for: TestCoreDataStack.self)]
        let modelURL =
            bundlesToTry
            .compactMap { $0.url(forResource: "BudgetTracker", withExtension: "momd") }
            .first

        guard let modelURL else {
            fatalError("Could not locate BudgetTracker.momd in bundles.")
        }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Could not load NSManagedObjectModel from \(modelURL).")
        }

        container = NSPersistentContainer(name: "BudgetTracker", managedObjectModel: model)

        let desc = NSPersistentStoreDescription()
        desc.type = NSInMemoryStoreType
        desc.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [desc]

        container.loadPersistentStores { _, error in
            if let error { fatalError("In-memory store failed: \(error)") }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    func makeExpense(
        amount: Double,
        category: String,
        date: Date,
        note: String? = nil
    ) -> ExpenseEntity {
        let e = ExpenseEntity(context: context)
        e.id = UUID()
        e.amount = amount
        e.category = category
        e.date = date
        e.note = note
        return e
    }
}

