//
//  MinesweeperApp.swift
//  Minesweeper
//
//  Created by Michael Skiba on 21/06/2022.
//

import SwiftUI

@main
struct MinesweeperApp: App {
    private let settingsService: SettingsService
    private let gameService: GameService

    init() {
        settingsService = SettingsService()
        gameService = GameService(settingsService: settingsService)
    }

    var body: some Scene {
        WindowGroup {
            RootView(gameService: gameService, settingsService: settingsService)
        }
    }
}
