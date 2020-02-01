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
            .foregroundColor(gridState.textColor)
            .frame(width: 30, height: 30)
            .background(gridState.backgroundColor)
            .highPriorityGesture(TapGesture()
                .modifiers(.option)
                .onEnded(flag))
            .gesture(TapGesture()
                .onEnded(reveal))
    }
}

private extension GridState {
    var backgroundColor: Color {
        state == .revealed ?
            Color(Asset.unselectedButton) :
            Color(Asset.selectedButton)
    }

    var textColor: Color {
        let color: ColorAsset
        switch self.info {
        case .empty, .mine: color = Asset.textColor
        case .count(let count):
            switch count {
            case 1: color = Asset.Solarized.blue
            case 2: color = Asset.Solarized.cyan
            case 3: color = Asset.Solarized.green
            case 4: color = Asset.Solarized.yellow
            case 5: color = Asset.Solarized.orange
            case 6: color = Asset.Solarized.red
            case 7: color = Asset.Solarized.magenta
            case 8: color = Asset.Solarized.violet
            default: color = Asset.textColor
            }
        }
        return Color(color)
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
