//
//  AlertAddedPushUpView.swift
//  PushUpGoal
//
//  Created by Titouan Blossier on 09/03/2021.
//

import SwiftUI

struct AlertAddedPushUpView: View {
    var undo : () -> Void // Called when the user wants to undo.

    @Binding var added : Int // Number of push up added.
    var body: some View {
        HStack {
            Spacer()
            Text("+\(added) push up added")
            Spacer()
            Button(action: {
                undo()
            }, label: {
                Text("Undo")
                    .foregroundColor(.black)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 3)
                    )
            })
            Spacer()
        }
        .transition(.move(edge: .bottom))
        .font(.system(size: 22))
        .padding()
        .background(Color.blue)
    }
}

struct AlertAddedPushUpView_Previews: PreviewProvider {
    @State static var added = 10
    static var previews: some View {
        AlertAddedPushUpView(undo: {
        }, added: $added)
    }
}
