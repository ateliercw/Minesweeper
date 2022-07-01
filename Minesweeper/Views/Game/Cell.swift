//
//  Cell.swift
//  Minesweeper
//
//  Created by Michael Skiba on 01/07/2022.
//

import SwiftUI

struct Cell: View {
    let value: Game.SpaceState
    let click: () -> Void
    let flag: () -> Void

    @ViewBuilder var body: some View {
        Button(action: click) {
            content
                .frame(width: 30, height: 30)
                .background { value.fillColor }
        }
        .foregroundColor(value.foregroundColor)
        .highPriorityGesture(flagGesture)
        .disabled(isDisabled)
    }
}

private extension Cell {
    var isDisabled: Bool {
        switch value {
        case .revealed(let count):
            return count == 0
        case .flaggedMine,
                .incorrectFlag,
                .unrevealedMine,
                .revealedMine:
            return true
        case .unrevealed, .flagged:
            return false
        }
    }

    var flagGesture: some Gesture {
        LongPressGesture()
            .onEnded { _ in
                flag()
            }
    }

    @ViewBuilder var content: some View {
        switch value {
        case .unrevealed:
            Color.clear
        case .revealedMine:
            Image(systemName: "xmark.seal.fill")
        case .flagged:
            Image(systemName: "flag")
        case .revealed(let count):
            if count > 0 {
                Text(count, format: .number)
                    .fontWeight(.bold)
            } else {
                Color.clear
            }
        case .flaggedMine:
            Image(systemName: "flag.fill")
        case .incorrectFlag:
            Image(systemName: "flag.slash")
        case .unrevealedMine:
            Image(systemName: "seal.fill")
        }
    }
}

private extension Game.SpaceState {
    var foregroundColor: Color {
        switch self {
        case .revealedMine, .unrevealedMine, .unrevealed, .flagged:
            return .primary
        case .revealed(let count):
            return count.foregroundColor
        case .incorrectFlag:
            return .red
        case .flaggedMine:
            return .green
        }
    }

    var fillColor: Color {
        switch self {
        case .flagged, .unrevealed, .unrevealedMine, .incorrectFlag, .flaggedMine:
            #if os(iOS)
            return Color(uiColor: .systemGray4)
            #elseif os(macOS)
            return Color(nsColor: .systemGray4)
            #endif
        case .revealed:
            #if os(iOS)
            return Color(uiColor: .systemGray6)
            #elseif os(macOS)
            return Color(nsColor: .systemGray6)
            #endif
        case .revealedMine:
            return .red
        }
    }
}

private extension Int {
    var foregroundColor: Color {
        switch self {
        case 1: return .blue
        case 2: return .green
        case 3: return .red
        case 4: return .purple
        case 5: return .brown
        case 6: return .cyan
        case 7: return .primary
        case 8: return .secondary
        default: return .primary
        }
    }
}

struct Cell_Previews: PreviewProvider {
    static var previews: some View {
        Grid(horizontalSpacing: 1, verticalSpacing: 1) {
            GridRow {
                Cell(value: .flagged) {} flag: {}
                Cell(value: .incorrectFlag) {} flag: {}
                Cell(value: .unrevealedMine) {} flag: {}
                Cell(value: .flaggedMine) {} flag: {}
                Cell(value: .revealedMine) {} flag: {}
            }
            GridRow {
                Cell(value: .unrevealed) {} flag: {}
                Cell(value: .revealed(0)) {} flag: {}
                Cell(value: .revealed(1)) {} flag: {}
                Cell(value: .revealed(2)) {} flag: {}
                Cell(value: .revealed(3)) {} flag: {}
            }
            GridRow {
                Cell(value: .revealed(4)) {} flag: {}
                Cell(value: .revealed(5)) {} flag: {}
                Cell(value: .revealed(6)) {} flag: {}
                Cell(value: .revealed(7)) {} flag: {}
                Cell(value: .revealed(8)) {} flag: {}
            }
        }
        .padding(1)
        .background(.gray)
    }
}
