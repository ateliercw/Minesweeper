//
//  RootView.swift
//  Minesweeper
//
//  Created by Michael Skiba on 21/06/2022.
//

import SwiftUI

struct RootView: View {
    @ObservedObject private var gameService: GameService
    @ObservedObject private var settingsService: SettingsService

    @State private var showSettings: Bool = false

    init(gameService: GameService, settingsService: SettingsService) {
        _gameService = ObservedObject(wrappedValue: gameService)
        _settingsService = ObservedObject(wrappedValue: settingsService)
    }

    var body: some View {
        NavigationStack {
            VStack {
                GameView()
                    .environmentObject(gameService)
                Spacer()
                Button("Settings") {
                    showSettings = true
                }
            }
            .padding()
            .withHeader(gameService: gameService)
            .onChange(of: settingsService.width) { _ in gameService.resetGame() }
            .onChange(of: settingsService.height) { _ in gameService.resetGame() }
            .onChange(of: settingsService.mineCount) { _ in gameService.resetGame() }
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                SettingsView(width: $settingsService.width,
                             height: $settingsService.height,
                             mines: $settingsService.mineCount)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let settingsService = SettingsService()
        RootView(gameService: GameService(settingsService: settingsService),
                 settingsService: settingsService)
    }
}
