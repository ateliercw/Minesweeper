//
//  GridState+Label.swift
//  Minesweeper
//
//  Created by Michael Skiba on 27/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import Foundation

extension GridState {
    func label(status: GameState.Status) -> String {
        switch (state, status, info) {
        case (.flagged, .active, _): return "🚩"
        case (.unmarked, .active, _),
             (.unmarked, .unstarted, _): return ""
        case (.unknown, .active, _): return "?"
        case (.probed, .active, .empty): return "🔍"
        case (.revealed, _, .mine): return "💥"
        case (_, .win, .mine): return "🚩"
        case (_, _, .mine): return "💣"
        case (_, _, .count(let count)): return (count).label
        case (_, _, .empty): return ""
        }
    }
}

private extension Int {
    var label: String {
        switch self {
        case 1: return "1"
        case 2: return "2"
        case 3: return "3"
        case 4: return "4"
        case 5: return "5"
        case 6: return "6"
        case 7: return "7"
        case 8: return "8"
        default: return "9"
        }
    }
}
