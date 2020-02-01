//
//  ContentView.swift
//  Minesweeper
//
//  Created by Michael Skiba on 25/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    /*
     -Beginner:       9x9  Area -  81 Squares - 10 mines
     -Intermediate:  16x16 Area - 256 Squares - 40 mines
     -Expert:        16x30 Area - 480 Squares - 99 mine
     */

    @ObservedObject var state = GameState(width: 9, height: 9, minecount: 10)

    var body: some View {
        ForEach(0..<state.height) { [state] row in
            HStack {
                ForEach(0..<state.width) { col in
                    Button(action: { state.reveal(Point(x: col, y: row)) },
                           label: { Text(state.label(Point(x: col, y: row))) })
                }
            }
        }
        .disabled(state.status != .active)
    }
}

extension GameState {
    func label(_ point: Point) -> String {
        let element = self[point]
        switch (element.state, status, element.info) {
        case (.flagged, .active, _): return "􀋊"
        case (.unmarked, .active, _): return "􀂓"
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

extension Int {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
