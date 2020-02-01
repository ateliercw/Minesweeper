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
            ForEach(Array(0..<state.height), id: \.self) { row in
                Self.row(row, state: state)
            }
        }
        .padding(1)
        .background(Color(Asset.outline))
        .disabled(!state.status.isPlayable)
    }

    private static func row(_ row: Int, state: GameState) -> some View {
        HStack(spacing: 1) {
            ForEach(Array(0..<state.width), id: \.self) { col in
                MineButton(point: Point(x: col, y: row), state: state)
            }
        }
    }
}

private extension MineButton {
    init(point: Point, state: GameState) {
        self = MineButton(
            gridState: state[point],
            status: state.status,
            reveal: { state.reveal(point) },
            flag: { state.toggleFlag(point) }
        )
    }
}
