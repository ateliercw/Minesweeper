//
//  MinesweeperHeader.swift
//  Minesweeper
//
//  Created by Michael Skiba on 27/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import SwiftUI

struct MinesweeperHeader: View {
    let remainingMines: Int
    let elapsedTime: Int
    let resetAction: () -> Void

    var body: some View {
        HStack {
            HStack {
                Text("\(remainingMines)")
                Spacer()
            }
            Button(action: resetAction) { Text("🔄") }
            HStack {
                Spacer()
                Text("\(elapsedTime)")
            }
        }
        .buttonStyle(PlainButtonStyle())
        .font(Font.system(.body).monospacedDigit())
    }
}
