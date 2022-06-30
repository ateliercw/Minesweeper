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

struct Cell: View {
    let value: Game.SpaceState
    let click: () -> Void
    let flag: () -> Void

    @ViewBuilder var body: some View {
        Button(action: click) {
            Rectangle()
                .overlay {
                    overlay
                }
        }
        .foregroundColor(foregroundColor)
        .frame(width: 30, height: 30)
        .highPriorityGesture(longPressGesture)
    }

    private var longPressGesture: some Gesture {
        LongPressGesture()
            .onEnded { _ in
                flag()
            }
    }

    @ViewBuilder private var overlay: some View {
        Group {
            switch value {
            case .unrevealed:
                EmptyView()
            case .revealedMine:
                Image(systemName: "xmark.seal.fill")
            case .flagged:
                Image(systemName: "flag")
            case .revealed(let count):
                if count > 0 {
                    Text(count, format: .number)
                }
            case .flaggedMine:
                Image(systemName: "flag.fill")
            case .incorrectFlag:
                Image(systemName: "flag.slash")
            case .unrevealedMine:
                Image(systemName: "seal.fill")
            }
        }
        .foregroundColor(.primary)
    }

    private var foregroundColor: Color {
        switch value {
        case .flagged, .unrevealed, .unrevealedMine, .incorrectFlag, .flaggedMine:
            #if os(iOS)
            return Color(uiColor: .systemGray4)
            #elseif os(macOS)
            return Color(nsColor: .systemGray4)
            #endif
        case .revealed, .revealedMine:
            #if os(iOS)
            return Color(uiColor: .systemGray6)
            #elseif os(macOS)
            return Color(nsColor: .systemGray6)
            #endif
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameService(settingsService: SettingsService()))
    }
}
