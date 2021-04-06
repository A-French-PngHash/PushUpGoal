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

    var persistence : PersistenceController = PersistenceController.shared

    init(persistence : PersistenceController?) {
        self.persistence = persistence ?? PersistenceController.shared
    }


    var numberPushUp : Int {
        return calculateNumberPushup()
    }

    func calculateNumberPushup() -> Int {

        return 100
        let result = persistence.getDataFor(days: 5)

        if result?.count == 0 {
            let allTime = persistence.getDataFor(days: 9999)
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
}
