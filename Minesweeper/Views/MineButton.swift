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
    let probe: () -> Void

    var body: some View {
        ZStack {
            if gridState.state != .revealed {
                Image(Asset.unrevealed).blendMode(.multiply)
            }
            Text(gridState.label(status: status)).bold()
        }
        .foregroundColor(gridState.textColor)
        .frame(width: 30, height: 30)
        .background(gridState.backgroundColor)
        .highPriorityGesture(TapGesture().modifiers(.option).onEnded(flag))
        .gesture(TapGesture().onEnded { [reveal, probe] in reveal(); probe() })
    }
}

private extension GridState {
    var backgroundColor: Color {
        state == .revealed ?
            Color(Asset.Mine.revealed) :
            Color(Asset.Mine.unrevealed)
    }

    var textColor: Color {
        let color: ColorAsset
        switch self.info {
        case .empty, .mine: color = Asset.label
        case .count(let count):
            switch count {
            case 1: color = Asset.Mine.Colors.mine1
            case 2: color = Asset.Mine.Colors.mine2
            case 3: color = Asset.Mine.Colors.mine3
            case 4: color = Asset.Mine.Colors.mine4
            case 5: color = Asset.Mine.Colors.mine5
            case 6: color = Asset.Mine.Colors.mine6
            case 7: color = Asset.Mine.Colors.mine7
            case 8: color = Asset.Mine.Colors.mine8
            default: color = Asset.label
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
                   flag: {},
                   probe: {})
    }
}
