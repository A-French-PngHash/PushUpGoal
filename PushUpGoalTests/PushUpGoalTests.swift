//
//  PushUpGoalTests.swift
//  PushUpGoalTests
//
//  Created by Titouan Blossier on 09/03/2021.
//

import XCTest
@testable import PushUpGoal

class PushUpGoalTests: XCTestCase {

    let context = PersistenceController.shared.container.viewContext
    let persistence = PersistenceController.shared

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStreakGivenFiveConsecutiveDayWhereMetWhenFetchingCurrentStreakThenIsFour() {
        let fakeData = createConsecutive(numberWanted: 5, metGoal: true)
        let fakeController = FakePersistenceController(data: fakeData)

        let streakService = StreakService(persistence: fakeController)

        XCTAssert(streakService.fetchStreak().count == 4)
    }

    func testStreakGivenXConsecutiveDayWhereThirdDidntMeetGoalWhenFetchingThenIsOne() {
        let fakeData = createConsecutive(numberWanted: 20, metGoal: true)
        // third element
        fakeData[2].metGoal = false

        let fakeController = FakePersistenceController(data: fakeData)

        let streakService = StreakService(persistence: fakeController)

        print(streakService.fetchStreak().count)
        XCTAssert(streakService.fetchStreak().count == 1)
    }

    func testStreakGivenXConsecutiveDayWhereFifthWasMissedWhenFetchingThenIsThree() {
        var fakeData = createConsecutive(numberWanted: 20, metGoal: true)
        // third element
        fakeData.remove(at: 4)

        let fakeController = FakePersistenceController(data: fakeData)

        let streakService = StreakService(persistence: fakeController)

        print(streakService.fetchStreak().count)
        XCTAssert(streakService.fetchStreak().count == 3)
    }

    func createConsecutive(numberWanted : Int, metGoal : Bool) -> [Day] {
        var fakeData : [Day] = []
        for i in 0...numberWanted-1 {
            let entity = Day(context: context)
            entity.day = Date.daysAgo(x: i)
            entity.metGoal = metGoal
            fakeData.append(entity)
        }
        return fakeData
    }
}

extension Date {

    static public func daysAgo(x : Int) -> Date{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let currentDate = calendar.date(from: components)!

        return calendar.date(byAdding: .day, value: -x, to: currentDate)!
    }
}
