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
        case (.flagged, .active, _): return "􀋊"
        case (.unmarked, .active, _),
             (.unmarked, .unstarted, _): return "􀂓"
        case (.unknown, .active, _): return "􀃭"
        case (.probed, .active, .empty): return "􀕮"
        case (.revealed, _, .mine): return "􀃮"
        case (_, .win, .mine): return "􀋊"
        case (_, _, .mine): return "􀕴"
        case (_, _, .count(let count)): return (count).label
        case (_, _, .empty): return "􀂒"
        }
    }
}

private extension Int {
    var label: String {
        switch self {
        case 1: return "􀃊"
        case 2: return "􀃌"
        case 3: return "􀃎"
        case 4: return "􀃐"
        case 5: return "􀃒"
        case 6: return "􀃔"
        case 7: return "􀃖"
        case 8: return "􀃘"
        default: return "􀃚"
        }
    }
}
