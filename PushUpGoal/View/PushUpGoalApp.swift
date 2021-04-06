//
//  PushUpGoalApp.swift
//  PushUpGoal
//
//  Created by Titouan Blossier on 09/03/2021.
//

import SwiftUI

let persistenceController = PersistenceController.shared

@main
struct PushUpGoalApp: App {
    let persistenceController = PersistenceController.shared
    static let greenColor = UIColor(red:118/255.0, green:186/255.0, blue:63/255.0, alpha:1.0)
    static let orangeColor = UIColor(red:251/255.0, green:128/255.0, blue:126/255.0, alpha:1.0)

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(MainViewModel(managedObjectContext: persistenceController.container.viewContext))
        }
    }
}


extension UIColor {
    static func blend(color1: UIColor, intensity1: CGFloat = 0.5, color2: UIColor, intensity2: CGFloat = 0.5) -> UIColor {
        let total = intensity1 + intensity2
        let l1 = intensity1/total
        let l2 = intensity2/total
        guard l1 > 0 else { return color2}
        guard l2 > 0 else { return color1}
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)

        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return UIColor(red: l1*r1 + l2*r2, green: l1*g1 + l2*g2, blue: l1*b1 + l2*b2, alpha: l1*a1 + l2*a2)
    }
}

extension Date {

    /// Removes the time component on the date (hour, minutes, seconds).
    func dateNoTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }

}

