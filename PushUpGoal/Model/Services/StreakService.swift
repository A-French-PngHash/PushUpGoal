//
//  StreakService.swift
//  PushUpGoal
//
//  Created by Titouan Blossier on 06/04/2021.
//

import Foundation
import CoreData

class StreakService {
    var persistence : PersistenceController

    init(persistence : PersistenceController = PersistenceController.shared) {
        self.persistence = persistence
    }

    func fetchStreak() -> Streak {
        let data = persistence.fetchAllData()

        var currentCount : Int = 0
        var lastDate : Date = Date()
        for i in data {
            if i.day == Date().dateNoTime() {
                continue
            }
            let difference = Calendar.current.dateComponents([.day], from: i.day!, to: lastDate)
            if difference.day! != 1 {
                // Missed a day.
                break
            }
            if !i.metGoal {
                // Didn't meet the goal
                break
            }
            currentCount += 1
            lastDate = i.day!

        }
        return Streak(count: currentCount)
    }

}
