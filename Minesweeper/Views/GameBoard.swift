//
//  GameBoard.swift
//  Minesweeper
//
//  Created by Michael Skiba on 27/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import SwiftUI

struct GameBoard: View {
    @ObservedObject var state = GameState(width: 9, height: 9, mineCount: 10)

    var body: some View {
        VStack(spacing: 1) { [state] in
            ForEach(0..<state.height) { row in
                HStack(spacing: 1) {
                    ForEach(0..<state.width) { col in
                        MineButton(point: Point(x: row, y: col), state: state)
                    }
                }
            }
        }
        .padding(1)
        .background(Color.black)
        .disabled(state.status == .win || state.status == .loss)
    }
}

private extension MineButton {
    init(point: Point, state: GameState) {
        self = MineButton(
            gridState: state[point],
            status: state.status,
            reveal: { [state] in state.reveal(point) },
            flag: { [state] in state.toggleFlag(point) }
        )
    }
}
