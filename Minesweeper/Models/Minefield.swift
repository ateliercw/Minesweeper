//
//  Minefield.swift
//  Minesweeper
//
//  Created by Michael Skiba on 25/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import Foundation

struct Minefield {
    private var data: [Point: GridState]
    let width: Int
    let height: Int

    var revealed: [MineInfo] {
        data.values
            .filter { $0.state == .revealed }
            .map { $0.info }
    }

    var unrevealed: [MineInfo] {
        data.values
            .filter { $0.state != .revealed }
            .map { $0.info }
    }

    init(initialPoint: Point, width: Int, height: Int, mineCount: Int) {
        self.width = width
        self.height = height
        assert(mineCount <= (width * height) - 1)
        let allPoints = (0..<width).flatMap { x in
            (0..<height).map { Point(x: x, y: $0) }
        }
        let minePoints = allPoints
            .filter { $0 != initialPoint }
            .shuffled()[0..<mineCount]
        var initialField = [Point: MineInfo]()
        for point in minePoints {
            initialField[point] = .mine
        }
        for point in allPoints where initialField[point] != .mine {
            let mineCount = Self.pointsSurrounding(point, width: width, height: height)
                .map { initialField[$0] }
                .filter { $0 == .mine }
                .count
            initialField[point] = mineCount == 0 ? .empty : .count(mineCount)
        }
        data = initialField.mapValues { GridState(state: .unmarked, info: $0) }
    }

    subscript(_ point: Point) -> GridState {
        get {
            guard let data = data[point] else { fatalError("\(point) is out of bounds") }
            return data
        }
        set {
            data[point] = newValue
        }
    }

    func pointsSurrounding(_ point: Point) -> [Point] {
        Self.pointsSurrounding(point, width: width, height: height)
    }

    private static func pointsSurrounding(_ point: Point,
                                          width: Int,
                                          height: Int) -> [Point] {
        let minY = max(0, point.y - 1)
        let maxY = min(point.y + 1, height - 1)
        let minX = max(0, point.x - 1)
        let maxX = min(point.x + 1, width - 1)
        return (minY...maxY).flatMap { y in
            (minX...maxX).map { Point(x: $0, y: y) }
        }
        .filter { $0 != point }
    }
}
