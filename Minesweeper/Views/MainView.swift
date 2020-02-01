//
//  MainView.swift
//  Minesweeper
//
//  Created by Michael Skiba on 25/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import SwiftUI

struct MainView: View {
    /*
     -Beginner:       9x9  Area -  81 Squares - 10 mines
     -Intermediate:  16x16 Area - 256 Squares - 40 mines
     -Expert:        16x30 Area - 480 Squares - 99 mines
     */

    @ObservedObject var state = GameState(width: 9, height: 9, mineCount: 10)

    var body: some View {
        VStack {
            MinesweeperHeader(remainingMines: state.mineCount - state.flaggedCount,
                              elapsedTime: state.elapsed,
                              resetAction: state.reset)
            GameBoard(state: state)
        }.padding()
    }
}
