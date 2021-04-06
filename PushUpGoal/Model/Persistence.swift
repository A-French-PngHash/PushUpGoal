//
//  Persistence.swift
//  PushUpGoal
//
//  Created by Titouan Blossier on 09/03/2021.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let newItem = Day(context: viewContext)
        newItem.day = Date()
        newItem.numberPushUp = 80
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PushUpGoal")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
            }
        }
    }


    /// Fetch all data in database.
    func fetchAllData() -> [Day] {
        let fetchRequest : NSFetchRequest<Day> = Day.fetchRequest()
        return try! container.viewContext.fetch(fetchRequest)
    }

    /// Fetch and return the data for the past [days].
    func getDataFor(days : Int) -> [Day]?{
        let calendar = Calendar.current

        func dateMinus(days : Int) -> Date {
            let now = Date()
            let daysAgo : Date = calendar.date(byAdding: DateComponents(day: -days), to: now)!
            return daysAgo
        }

        let daysAgo = dateMinus(days: days)

        let startDate = calendar.startOfDay(for: daysAgo)
        let predicate = NSPredicate(format:"(date >= %@) AND (date < %@)", startDate as CVarArg, Date() as CVarArg)

        let fetchRequest : NSFetchRequest<Day> = Day.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "day", ascending: true)]
        let result = try? container.viewContext.fetch(fetchRequest)
        return result

    }
}
