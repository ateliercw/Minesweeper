//
//  PreferencesView.swift
//  Minesweeper
//
//  Created by Michael Skiba on 28/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import SwiftUI

struct PreferencesView: View {
    let updateConfiguration: (Minefield.Configuration) -> Void
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
        updateConfiguration(.init(width: 9, height: 9, mineCount: 10))
        dismissAction()
    }

    func setIntermediate() {
        updateConfiguration(.init(width: 16, height: 16, mineCount: 40))
        dismissAction()
    }

    func setExpert() {
        updateConfiguration(.init(width: 30, height: 16, mineCount: 99))
        dismissAction()
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView(updateConfiguration: { _ in }, dismissAction: {})
    }
}
