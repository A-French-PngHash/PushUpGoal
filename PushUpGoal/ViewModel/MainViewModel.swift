//
//  MainViewModel.swift
//  PushUpGoal
//
//  Created by Titouan Blossier on 17/03/2021.
//

import CoreData
import Combine
import SwiftUI

class MainViewModel : ObservableObject {
    //MARK: - Variables

    /// Number of reps to add when the user press the + button.
    ///
    /// Can be edited by the user.
    @Published var repsToAdd : Int = 20
    /// Number of pushup done today. Increases as the user adds more.
    @Published var currentNumberOfPushUp : Int = 0

    @Published var bannerShown : Bool = false
    /// Number of push up that were added since the banner was triggered.
    @Published var pushUpAddedBanner : Int = 0

    private var bannerShouldHideAt : Date = Date()

    /// Number of push up the user should aim for. Defined on init.
    let pushUpGoal : Int
    /// Current streak (number of consecutive day where the goal was met).
    let streak : Streak

    private (set) var today : Day! = nil
    let managedObjectContext : NSManagedObjectContext

    let streakService = StreakService()

    /// Foreground color to set for the number of push up done today.
    ///
    /// It ranges from orange to green, greener as the user approaches the daily goal.
    var currentTextColor : Color {
        let intensity1 = CGFloat(currentNumberOfPushUp) / CGFloat(pushUpGoal)
        let intensity2 = 1 - intensity1
        return Color(UIColor.blend(color1: PushUpGoalApp.greenColor, intensity1: intensity1, color2: PushUpGoalApp.orangeColor, intensity2:intensity2))
    }


    init(managedObjectContext : NSManagedObjectContext) {
        let goalCalculator = GoalCalculator.shared
        self.managedObjectContext = managedObjectContext
        self.pushUpGoal = goalCalculator.numberPushUp
        self.streak = streakService.fetchStreak()
        fetchToday()
        self.currentNumberOfPushUp = Int(today.numberPushUp)

        Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true) { (timer) in
            if self.bannerShown && self.bannerShouldHideAt < Date() {
                self.bannerShown = false
                self.pushUpAddedBanner = 0
            }
        }

    }

    func fetchToday() {
        let fetchTodayDataRequest : NSFetchRequest<Day> = Day.fetchRequest()

        fetchTodayDataRequest.sortDescriptors = [NSSortDescriptor(key: "day", ascending: true)]
        fetchTodayDataRequest.predicate = NSPredicate(format: "day == %@", Date().dateNoTime() as CVarArg)

        let result = try? managedObjectContext.fetch(fetchTodayDataRequest)

        if result == nil || result!.count == 0 { // No entity for today yet.
            let newEntity = Day(context: managedObjectContext)
            newEntity.day = Date().dateNoTime()
            newEntity.numberPushUp = 0
            newEntity.metGoal = false
            newEntity.goal = Int64(pushUpGoal)
            PersistenceController.shared.save()
            today = newEntity
            return
        }
        today = result![0]
    }

    //MARK: - Functions

    /// The user pressed the plus button.
    ///
    /// This function increase the number of push up done today. It stores it in the local database. Additionaly it manages a small banner that appear at the bottom of the screen. This banner enables the user to undo their action.
    func plusButtonPressed() {
        addToTodaysCount(x: repsToAdd)

        pushUpAddedBanner += repsToAdd
        bannerShown = true
        bannerShouldHideAt = Date() + TimeInterval(3)
    }

    func undoBanner() {
        bannerShown = false
        addToTodaysCount(x: -pushUpAddedBanner)
        pushUpAddedBanner = 0
    }

    func addToTodaysCount(x : Int) {
        today.numberPushUp += Int64(x)
        currentNumberOfPushUp = Int(today.numberPushUp)
        if today.numberPushUp >= today.goal {
            today.metGoal = true
        }
        PersistenceController.shared.save()
    }
}
