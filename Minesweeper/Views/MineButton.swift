//
//  MineButton.swift
//  Minesweeper
//
//  Created by Michael Skiba on 27/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import SwiftUI

struct MineButton: View {
    let gridState: GridState
    let status: GameState.Status
    let reveal: () -> Void
    let flag: () -> Void

    var body: some View {
        Text(gridState.label(status: status))
            .frame(width: 30, height: 30)
            .background(gridState.color)
            .highPriorityGesture(TapGesture()
                .modifiers(.option)
                .onEnded(flag))
            .gesture(TapGesture()
                .onEnded(reveal))
    }
}

private extension GridState {
    var color: Color {
        Color(state == .revealed ?
            NSColor.underPageBackgroundColor :
            NSColor.controlColor)
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
