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
     -Expert:        16x30 Area - 480 Squares - 99 mines
     */

    @ObservedObject var state = GameState(width: 9, height: 9, mineCount: 10)

    var body: some View {
        VStack {
            HStack {
                Text("\(state.mineCount - state.flaggedCount)")
                Spacer()
                Button(action: { self.state.reset() }, label: { Text("􀊯") })
                Spacer()
                Text("\(state.elapsed)")
            }
            board
        }.padding()
    }

    var board: some View {
        ForEach(0..<state.height) { [state] row in
            HStack {
                ForEach(0..<state.width) { col in
                    MineButton(label: state.label(Point(x: col, y: row)),
                               reveal: { state.reveal(Point(x: col, y: row)) },
                               flag: { state.flag(Point(x: col, y: row)) })
                }
            }.font(Font.body)
        }
        .disabled(state.status == .win || state.status == .loss)
    }
}

struct MineButton: View {
    var label: String
//    var reveal: () -> Void
//    var flag: () -> Void

    private let revealGesture: AnyGesture<()>
    private let flagGesture: AnyGesture<()>

    init(label: String, reveal: @escaping () -> Void, flag: @escaping () -> Void) {
        self.label = label
        let revealGesture = TapGesture()
            .onEnded(reveal)
        self.revealGesture = AnyGesture(revealGesture)
        let flagGesture = TapGesture()
            .modifiers(.option)
            .onEnded(flag)
        self.flagGesture = AnyGesture(flagGesture)
    }

    var body: some View {
        Text(label)
            .gesture(flagGesture)
            .gesture(revealGesture)
    }
}

extension GameState {
    func label(_ point: Point) -> String {
        let element = self[point]
        switch (element.state, status, element.info) {
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
