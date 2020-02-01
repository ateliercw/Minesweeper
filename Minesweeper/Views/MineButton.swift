//
//  MineButton.swift
//  Minesweeper
//
//  Created by Michael Skiba on 27/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import SwiftUI

struct MineButton: View {
    var label: String
    var reveal: () -> Void
    var flag: () -> Void

    init(gridState: GridState,
         status: GameState.Status,
         reveal: @escaping () -> Void,
         flag: @escaping () -> Void) {
        self.label = gridState.label(status: status)
        self.reveal = reveal
        self.flag = flag
    }

    var body: some View {
        Text(label)
            .highPriorityGesture(TapGesture()
                .modifiers(.option)
                .onEnded(flag))
            .gesture(TapGesture()
                .onEnded(reveal))
            .frame(width: 20, height: 20)
    }
}

struct MineButton_Previews: PreviewProvider {
    static var previews: some View {
        MineButton(gridState: GridState(state: .flagged, info: .mine),
                   status: .active,
                   reveal: {},
                   flag: {})
    }
}
