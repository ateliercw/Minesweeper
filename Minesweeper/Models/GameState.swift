//
//  GameState.swift
//  Minesweeper
//
//  Created by Michael Skiba on 26/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import Foundation

class GameState: ObservableObject {
    enum Status {
        case active
        case win
        case loss
    }

    @Published var width: Int

    @Published var height: Int

    @Published var mineCount: Int

    @Published var elapsed: Int

    @Published private var minefield: Minefield?

    var status: Status {
        if minefield?.revealed.contains(.mine) == true {
            return .loss
        } else if minefield?.unrevealed.count == mineCount {
            return .win
        } else {
            return .active
        }
    }

    subscript(_ point: Point) -> GridState {
        return minefield?[point] ?? GridState(state: .unmarked, info: .empty)
    }

    func reveal(_ point: Point) {
        if minefield == nil {
            minefield = Minefield(initialPoint: point, width: width, height: height, mineCount: mineCount)
        }
        minefield?[point].state = .revealed
        revealSurrounding(point: point, alreadyChecked: [])
    }

    private func revealSurrounding(point: Point, alreadyChecked: Set<Point>) {
        minefield?[point].state = .revealed
        guard let gridPoint = minefield?[point], gridPoint.info == .empty, gridPoint.state != .flagged  else { return }
        let surrounding = Set(minefield?.pointsSurrounding(point) ?? [])
            .subtracting(alreadyChecked)
        for point in surrounding {
            revealSurrounding(point: point, alreadyChecked: surrounding.union(alreadyChecked).union([point]))
        }
    }

    init(width: Int, height: Int, minecount: Int) {
        self.elapsed = 0
        self.width = width
        self.height = height
        self.mineCount = minecount
    }
}
