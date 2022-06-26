//
//  Header.swift
//  Minesweeper
//
//  Created by Michael Skiba on 25/06/2022.
//

import SwiftUI

extension View {
    func withHeader(time: Int,
                    mineCount: Int,
                    gameState: Header.GameState,
                    onButtonTap: @escaping () -> Void) -> some View {
        self.modifier(Header(time: time, mineCount: mineCount, gameState: gameState, onButtonTap: onButtonTap))
    }
}

struct Header: ViewModifier {
    enum GameState {
        case active
        case win
        case lose
    }

    let time: Int
    let mineCount: Int
    let gameState: GameState
    let onButtonTap: () -> Void

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
            Text("\(time, format: .number.precision(.integerLength(3)))")
                .monospacedDigit()
        }
    }

    private var minesLabel: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text("Mines:")
                .foregroundColor(.secondary)
                .font(.callout)
            Text("\(mineCount, format: .number.precision(.integerLength(3)))")
                .monospacedDigit()
        }
    }

    private var actionButton: some View {
        Button(action: onButtonTap) {
            Image(systemName: gameState.image)
        }
        .buttonStyle(.borderedProminent)
    }
}

private extension Header.GameState {
    var image: String {
        switch self {
        case .active:
            return "face.smiling.fill"
        case .win:
            return "flag.checkered.fill"
        case .lose:
            return "xmark.seal.fill"
        }
    }
}
