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
            LabelStack(alignment: .leading,
                       caption: Text("Mines"),
                       detail: Text("\(remainingMines)"))
            Button(action: resetAction) { Text("🔄") }
            LabelStack(alignment: .trailing,
                       caption: Text("Time"),
                       detail: Text("\(elapsedTime)"))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

private struct LabelStack: View {
    let alignment: HorizontalAlignment
    let caption: Text
    let detail: Text

    var body: some View {
        HStack {
            if alignment == .trailing { Spacer() }
            VStack(alignment: alignment) {
                caption
                    .font(Font.caption)
                    .foregroundColor(Color(Asset.secondaryLabel))
                detail
                    .font(Font.system(.body).monospacedDigit())
            }
            if alignment == .leading { Spacer() }
        }
    }
}
