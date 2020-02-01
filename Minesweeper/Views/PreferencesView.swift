//
//  PreferencesView.swift
//  Minesweeper
//
//  Created by Michael Skiba on 28/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import SwiftUI

struct PreferencesView: View {
    @Binding var width: Int
    @Binding var height: Int
    @Binding var mines: Int
    let dismissAction: () -> Void

    var body: some View {
        VStack {
            Button(action: setBeginner) { Text("Beginner") }
            Button(action: setIntermediate) { Text("Intermediate") }
            Button(action: setExpert) { Text("Expert") }
            Button(action: dismissAction) { Text("Cancel") }
        }
        .padding()
    }

    func setBeginner() {
        width = 9
        height = 9
        mines = 10
        dismissAction()
    }

    func setIntermediate() {
        width = 16
        height = 16
        mines = 40
        dismissAction()
    }

    func setExpert() {
        width = 30
        height = 16
        mines = 99
        dismissAction()
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView(width: Binding<Int>(get: { 0 }, set: { _ in }),
                        height: Binding<Int>(get: { 0 }, set: { _ in }),
                        mines: Binding<Int>(get: { 0 }, set: { _ in })) {}
    }
}
