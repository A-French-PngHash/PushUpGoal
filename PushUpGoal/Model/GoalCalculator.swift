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
        return 60
    }
}
