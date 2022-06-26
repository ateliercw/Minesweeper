//
//  RootView.swift
//  Minesweeper
//
//  Created by Michael Skiba on 21/06/2022.
//

import SwiftUI

struct RootView: View {
    @StateObject private var settingsService = SettingsService()
    @State private var showSettings: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
                Button("Show") {
                    showSettings = true
                }
                Spacer()
            }
            .withHeader(time: 10, mineCount: 10, gameState: .active) {}
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

    private func headerButtonTapped() {

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
