//
//  ContentView.swift
//  PushUpGoal
//
//  Created by Titouan Blossier on 09/03/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    let goalCalculator = GoalCalculator.shared

    @State private var today : Day?

    @State var repsToAdd = 20 // Default value.
    @State var editingValueRepsToAdd : Bool = false
    @State var currentNumber : Int64 = 0

    @State var timerAddedPushUpAlert : Timer?
    @State var alertShown : Bool = false
    let displayAddedPushUpAlertHiddenFor = 6
    @State var repsAddedSinceAlertShown = 0

    
    var currentColor : Binding<Color>  {
        Binding {
            let intensity1 = CGFloat(currentNumber) / CGFloat(goalCalculator.numberPushUp)
            let intensity2 = 1 - intensity1
            return Color(UIColor.blend(color1: PushUpGoalApp.greenColor, intensity1: intensity1, color2: PushUpGoalApp.orangeColor, intensity2:intensity2))
        } set: { _ in

        }
    }


    var mainView : some View {
        VStack(spacing : 5) {
            Group {
                Text("\(currentNumber)")
                    .font(.system(size: 110))
                Rectangle()
                    .frame(width: .infinity, height: 5, alignment: .top)
                    .padding(.horizontal, 40.0)
                Text("\(goalCalculator.numberPushUp)")
                    .font(.system(size: 110))
            }
            .foregroundColor(currentColor.wrappedValue)
            Spacer()
            HStack {
                Spacer()
                HStack(spacing: 5) {
                    Text("Add")
                    if editingValueRepsToAdd {
                        TextField("title", text: Binding(get: {
                            String(repsToAdd)
                        }, set: { (value) in
                            if let v = Int(value) {
                                repsToAdd = v
                            }
                        }))
                        .frame(width: 50, height: 20, alignment: .center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        Text("+\(repsToAdd)")
                            .foregroundColor(.orange)
                    }
                    Text("push up")
                }
                .font(.title3)

                Button(action: {
                    editingValueRepsToAdd.toggle()
                }, label: {
                    ZStack {
                        Circle()
                        if editingValueRepsToAdd {
                            Text("OK")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                        } else {
                            Image(systemName: "pencil")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                    }
                    .frame(width: 30, height: 30, alignment: .center)
                })
                Spacer()

            }
            Button(action: {
                if let timer = timerAddedPushUpAlert {
                    if timer.isValid {
                        timer.invalidate()
                    } else {
                        // Need to reset here because if reset is shown just after view hidden, the reset is visible on the animation.
                        repsAddedSinceAlertShown = 0
                    }
                }
                withAnimation {
                    alertShown = true
                    add(reps: repsToAdd)
                }
                timerAddedPushUpAlert = Timer.scheduledTimer(withTimeInterval: TimeInterval(displayAddedPushUpAlertHiddenFor), repeats: false, block: { (_) in
                    withAnimation {
                        alertShown = false
                    }
                })

            }, label: {
                VStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 80))
                }
            })
            .foregroundColor(.red)
            Spacer()
        }
    }

    var body : some View {
        ZStack {
            mainView
            Spacer()
            VStack {
                Spacer()
                if alertShown {
                    AlertAddedPushUpView(undo: {
                        // Undo button pressed.
                        withAnimation {
                            alertShown = false
                            add(reps: -repsAddedSinceAlertShown)
                        }
                        if let timer = self.timerAddedPushUpAlert {
                            timer.invalidate()
                        }
                    }, added: $repsAddedSinceAlertShown)

                }
            }
        }
        .onAppear(perform: {

            let fetchTodayDataRequest : NSFetchRequest<Day> = Day.fetchRequest()

            fetchTodayDataRequest.sortDescriptors = [NSSortDescriptor(key: "day", ascending: true)]
            fetchTodayDataRequest.predicate = NSPredicate(format: "day == %@", Date().dateNoTime() as CVarArg)

            let result = try? managedObjectContext.fetch(fetchTodayDataRequest)

            if result == nil || result!.count == 0 { // No entity for today yet.
                let newEntity = Day(context: managedObjectContext)
                newEntity.day = Date().dateNoTime()
                newEntity.numberPushUp = 0
                PersistenceController.shared.save()
                today = newEntity
                return
            }
            today = result![0]
            currentNumber = today!.numberPushUp
        })
    }

    func add(reps : Int) {
        today!.numberPushUp += Int64(reps)
        currentNumber = today!.numberPushUp
        if reps > 0 { // WHen undo button process the number is negative. We odn't want this value set to 0 just yet as the user would be able to see the reset through the hiding animation.
            repsAddedSinceAlertShown += reps
        }
        PersistenceController.shared.save()
    }
}

let persistenceController = PersistenceController.shared

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
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

    func dateNoTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }

}
