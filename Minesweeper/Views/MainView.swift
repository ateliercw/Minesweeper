//
//  MainView.swift
//  Minesweeper
//
//  Created by Michael Skiba on 25/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var state: GameState

    var body: some View {
        VStack {
            MinesweeperHeader(remainingMines: state.mineCount - state.flaggedCount,
                              elapsedTime: state.elapsed,
                              resetAction: state.reset)
            Spacer()
            GameBoard(state: state)
                .drawingGroup()
        }
        .padding()
        .font(Font.body)
        .fixedSize()
        .sheet(isPresented: $state.showSettings) { [self] in
            PreferencesView(width: self.$state.width,
                            height: self.$state.height,
                            mines: self.$state.mineCount) { self.state.showSettings.toggle() }
        }
    }
}
