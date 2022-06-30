//
//  GameService.swift
//  Minesweeper
//
//  Created by Michael Skiba on 26/06/2022.
//

import SwiftUI
import Combine

@MainActor
class GameService: ObservableObject {
    @Published private var game: Game?
    private let settingsService: SettingsService

    init(settingsService: SettingsService) {
        self.settingsService = settingsService
    }

    var gridRows: [GridPointRow] {
        (0..<height).map { row in
            GridPointRow(row: row, width: width)
        }
    }

    var width: Int {
        settingsService.width
    }

    var height: Int {
        settingsService.height
    }

    var state: Game.State {
        game?.state ?? .active
    }

    var elapsedTime: TimeInterval {
        game?.elapsedTime ?? 0
    }

    var remainingMines: Int {
        game?.remainingMines ?? settingsService.mineCount
    }

    func resetGame() {
        game = nil
    }

    func reveal(_ gridPoint: GridPoint) {
        createGameIfNeeded()
        game?.reveal(gridPoint)
    }

    func revealSurroundingIfSafe(_ gridPoint: GridPoint) {
        game?.revealSurroundingIfSafe(gridPoint)
    }

    func toggleFlag(_ gridPoint: GridPoint) {
        createGameIfNeeded()
        game?.toggleFlag(gridPoint)
    }

    subscript(_ gridPoint: GridPoint) -> Game.SpaceState {
        game?[gridPoint] ?? .unrevealed
    }
}

private extension GameService {
    func createGameIfNeeded() {
        guard game == nil else { return }
        game = Game(width: settingsService.width,
                    height: settingsService.height,
                    mineCount: settingsService.mineCount)
    }
}
