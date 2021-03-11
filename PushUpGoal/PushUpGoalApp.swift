//
//  PushUpGoalApp.swift
//  PushUpGoal
//
//  Created by Titouan Blossier on 09/03/2021.
//

import SwiftUI

@main
struct PushUpGoalApp: App {
    let persistenceController = PersistenceController.shared
    static let greenColor = UIColor(red:118/255.0, green:186/255.0, blue:63/255.0, alpha:1.0)
    static let orangeColor = UIColor(red:251/255.0, green:128/255.0, blue:126/255.0, alpha:1.0)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
