//
//  MainView.swift
//  PushUpGoal
//
//  Created by Titouan Blossier on 18/03/2021.
//

import SwiftUI

struct MainView<Model: MainViewModel>: View {
    @EnvironmentObject var model: Model
    @State var isEditingRepsToAdd = false
    @State var bannerShown = false

    var body: some View {
        VStack(spacing : 5) {
            Group {
                Text("\(model.currentNumberOfPushUp)")
                    .font(.system(size: 110))

                Rectangle()
                    .frame(width: .infinity, height: 5, alignment: .top)
                    .padding(.horizontal, 40.0)
                Text("\(model.pushUpGoal)")
                    .font(.system(size: 110))
            }
            .foregroundColor(model.currentTextColor)

            Spacer()
            
            HStack(spacing : 4) {
                if !isEditingRepsToAdd {
                    Text("Add")
                    Text("+" + String(model.repsToAdd))
                        .foregroundColor(.orange)
                    Text("push ups.")
                    Button(action: {
                        isEditingRepsToAdd = true
                    }, label: {
                        Image(systemName: "pencil.circle.fill")
                    })
                } else {
                    Text("Add")
                    TextField(
                        "20",
                        text:
                            Binding(get: {
                                String(model.repsToAdd)
                            }, set: { (value) in
                                if let v = Int(value) {
                                    model.repsToAdd = v
                                }
                            })
                    )
                    .frame(width: 50, height: 20, alignment: .center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("push ups.")
                    Button(action: {
                        isEditingRepsToAdd = false
                    }, label: {
                        Image(systemName: "checkmark.circle.fill")
                    })
                }
            }
            .font(.system(size: 20))


            Button(action: {
                model.plusButtonPressed()
            }, label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 80))
            })
            Spacer()
            if model.streak.count >= 0 {
                HStack {
                    Spacer()
                    VStack {
                        Text("CURRENT STREAK")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                        Text("\(model.streak.count) days 🔥")
                            .font(.system(size: 21))
                    }
                    .padding()
                }
            }

            if bannerShown {
                AlertAddedPushUpView(undo: {
                    model.undoBanner()
                }, added: model.pushUpAddedBanner)
                //.animation(.default)
            }
        }
        .onChange(of: model.bannerShown, perform: { value in
            withAnimation {
                bannerShown = value
            }
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(MainViewModel(managedObjectContext: persistenceController.container.viewContext))
    }
}
