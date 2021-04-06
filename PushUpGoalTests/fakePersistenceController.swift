//
//  fakePersistenceController.swift
//  PushUpGoalTests
//
//  Created by Titouan Blossier on 06/04/2021.
//

import Foundation
@testable import PushUpGoal

class FakePersistenceController : PersistenceController {
    /// Data to return when the fetchAllData fucntion is called.
    let data : [Day]

    init(data : [Day]) {
        self.data = data
    }

    override func fetchAllData() -> [Day] {
        return data
    }
}
