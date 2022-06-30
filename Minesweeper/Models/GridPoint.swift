//
//  GridPoint.swift
//  Minesweeper
//
//  Created by Michael Skiba on 30/06/2022.
//

import Foundation

struct GridPoint: Hashable, Identifiable {
    var id: GridPoint { self }

    let x: Int
    let y: Int
}

struct GridPointRow: Hashable, Identifiable {
    var id: Int { row }
    let row: Int
    let points: [GridPoint]

    init(row: Int, width: Int) {
        self.row = row
        points = (0..<width).map { column in
            GridPoint(x: column, y: row)
        }
    }
}
