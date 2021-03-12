//
//  GoalCalculator.swift
//  PushUpGoal
//
//  Created by Titouan Blossier on 10/03/2021.
//

import Foundation
import CoreData

/// Calculate the number of push up to do today.
class GoalCalculator {
    static let shared = GoalCalculator()
    private init() { }

    var context = PersistenceController.shared.container.viewContext

    init(context : NSManagedObjectContext?) {
        if let cont = context {
            self.context = cont
        }
    }


    var numberPushUp : Int {
        return calculateNumberPushup()
    }

    func calculateNumberPushup() -> Int {

        return 100
        let result = getDataFor(days: 5)

        if result?.count == 0 {
            let allTime = getDataFor(days: 9999)
            if allTime?.count == 0 { // This should never happend
                return 100
            }  
            let lastDay = allTime?.last
            let lastPushUpDate = lastDay!.day
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: lastPushUpDate!, to: calendar.startOfDay(for: Date()))
            //let theoreticalNewGoal = lastDay!.goal / (components.day! % 5)


        }
    }

    private func getDataFor(days : Int) -> [Day]?{
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
        let result = try? context.fetch(fetchRequest)
        return result

    }
}
