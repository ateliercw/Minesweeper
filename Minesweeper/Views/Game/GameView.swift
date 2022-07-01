//
//  GameView.swift
//  Minesweeper
//
//  Created by Michael Skiba on 27/06/2022.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameService: GameService

    var body: some View {
        Grid(horizontalSpacing: 1, verticalSpacing: 1) {
            ForEach(gameService.gridRows) { row in
                GridRow {
                    ForEach(row.points, content: cellFor(gridPoint:))
                }
            }
        }
        .padding(1)
        .background(backgroundColor)
        .disabled(isDisabled)
    }
}

private extension GameView {
    var isDisabled: Bool {
        switch gameService.state {
        case .lose, .win:
            return true
        case .active:
            return false
        }
    }

    func cellFor(gridPoint: GridPoint) -> some View {
        let value = gameService[gridPoint]

        return Cell(value: value) {
            if case .revealed = value {
                gameService.revealSurroundingIfSafe(gridPoint)
            } else {
                gameService.reveal(gridPoint)
            }
        } flag: {
            gameService.toggleFlag(gridPoint)
        }
    }

    var backgroundColor: Color {
        #if os(iOS)
        return Color(uiColor: .systemGray)
        #elseif os(macOS)
        return Color(nsColor: .systemGray)
        #endif
    }
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameService(settingsService: SettingsService()))
    }
}
