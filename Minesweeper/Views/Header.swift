//
//  Header.swift
//  Minesweeper
//
//  Created by Michael Skiba on 25/06/2022.
//

import SwiftUI

extension View {
    func withHeader(gameService: GameService) -> some View {
        modifier(Header(gameService: gameService))
    }
}

struct Header: ViewModifier {
    @ObservedObject var gameService: GameService

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { timeLabel }
                ToolbarItem(placement: .navigationBarTrailing) { minesLabel }
                ToolbarItem(placement: .principal) { actionButton }
            }
    }

    private var timeLabel: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text("Time:")
                .foregroundColor(.secondary)
                .font(.callout)
            TimerView(gameService: gameService)
        }
    }

    private var minesLabel: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text("Mines:")
                .foregroundColor(.secondary)
                .font(.callout)
            Text("\(gameService.remainingMines, format: .number.precision(.integerLength(3)))")
                .monospacedDigit()
        }
    }

    private var actionButton: some View {
        Button {
            gameService.resetGame()
        } label: {
            Image(systemName: gameService.state.image)
        }
        .buttonStyle(.borderedProminent)
    }
}

private struct TimerView: View {
    @ObservedObject var gameService: GameService
    @State private var elapsedTime: TimeInterval = 0

    var body: some View {
        Text("\(elapsedTime, format: .number.precision(.integerAndFractionLength(integer: 3, fraction: 0)))")
            .monospacedDigit()
            .onReceive(Timer.publish(every: 0.2, on: .main, in: .default).autoconnect()) { _ in
                elapsedTime = gameService.elapsedTime
            }
    }

}

private extension Game.State {
    var image: String {
        switch self {
        case .active:
            return "face.smiling.fill"
        case .win:
            return "flag.checkered"
        case .lose:
            return "xmark.seal.fill"
        }
    }
}
