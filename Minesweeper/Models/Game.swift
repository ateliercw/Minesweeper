//
//  Game.swift
//  Minesweeper
//
//  Created by Michael Skiba on 26/06/2022.
//

import Foundation

struct Game {
    private let width: Int
    private let height: Int
    private let mineCount: Int
    private let startDate = Date()
    private var endDate: Date?
    private (set) var state: State = .active

    private var board: [GridPoint: Space]?
    private var flagged = Set<GridPoint>()
    private var mines = Set<GridPoint>()
    private var revealed = Set<GridPoint>()

    var elapsedTime: TimeInterval {
        (endDate ?? Date()).timeIntervalSince(startDate)
    }

    var remainingMines: Int {
        mineCount - flagged.count
    }

    init(width: Int, height: Int, mineCount: Int) {
        self.width = width
        self.height = height
        self.mineCount = mineCount
    }

    subscript(_ gridPoint: GridPoint) -> SpaceState {
        switch board?[gridPoint] {
        case .none:
            return flagged.contains(gridPoint) ? .flagged : .unrevealed
        case .mine:
            return mineState(gridPoint)
        case .empty(let count):
            return emptyState(gridPoint, count: count)
        }
    }

    mutating func reveal(_ gridPoint: GridPoint) {
        guard !flagged.contains(gridPoint), !revealed.contains(gridPoint) else { return }
        createBoardIfNeeded(initialMove: gridPoint)
        guard board?[gridPoint] != nil else { return }
        revealed.insert(gridPoint)
        if case .empty(let count) = board?[gridPoint], count == 0 {
            for surroundingIndex in gridPoint.surroundingGridPoints {
                reveal(surroundingIndex)
            }
        }
        if mines.isDisjoint(with: revealed) {
            if revealed.count == (width * height) - mineCount {
                endDate = Date()
                state = .win
            }
        } else {
            endDate = Date()
            state = .lose
        }
    }

    mutating func revealSurroundingIfSafe(_ gridPoint: GridPoint) {
        guard revealed.contains(gridPoint),
              case .empty(let mines) = board?[gridPoint]
        else { return }
        let surroundingGridPoints = gridPoint.surroundingGridPoints
        guard surroundingGridPoints.intersection(flagged).count == mines else { return }
        for gridPoint in surroundingGridPoints.subtracting(flagged) {
            reveal(gridPoint)
        }
    }

    mutating func toggleFlag(_ gridPoint: GridPoint) {
        guard !revealed.contains(gridPoint) else { return }
        flagged.formSymmetricDifference([gridPoint])
    }
}

// MARK: - Private functions
private extension Game {
    func mineState(_ gridPoint: GridPoint) -> SpaceState {
        if revealed.contains(gridPoint) {
            return .revealedMine
        } else {
            switch state {
            case .lose, .win:
                if flagged.contains(gridPoint) {
                    return .flaggedMine
                } else {
                    return .unrevealedMine
                }
            case .active:
                if flagged.contains(gridPoint) {
                    return .flagged
                } else {
                    return .unrevealed
                }
            }
        }
    }

    func emptyState(_ gridPoint: GridPoint, count: Int) -> SpaceState {
        if revealed.contains(gridPoint) {
            return .revealed(count)
        } else if flagged.contains(gridPoint) {
            switch state {
            case .win, .lose:
                return .incorrectFlag
            case .active:
                return .flagged
            }
        } else {
            return .unrevealed
        }
    }

    private mutating func createBoardIfNeeded(initialMove: GridPoint) {
        guard board == nil else { return }
        self.board = [GridPoint: Game.Space](width: width, height: height, mineCount: mineCount, initialMove: initialMove)
        mines = board?.mineGridPoints ?? []
    }
}

// MARK: - Space Values
private extension Game {
    enum Space {
        case mine
        case empty(Int)
    }
}

// MARK: - Convenience inits for sets of GridPoints
private extension Set where Element == GridPoint {
    init(width: Range<Int>, height: Range<Int>) {
        self = width.reduce(into: Set<GridPoint>()) { grid, col in
            let column = height.reduce(into: Set<GridPoint>()) { column, row in
                column.insert(GridPoint(x: col, y: row))
            }
            grid.formUnion(column)
        }
    }

    init(width: ClosedRange<Int>, height: ClosedRange<Int>) {
        self = width.reduce(into: Set<GridPoint>()) { grid, col in
            let column = height.reduce(into: Set<GridPoint>()) { column, row in
                column.insert(GridPoint(x: col, y: row))
            }
            grid.formUnion(column)
        }
    }
}

// MARK: - Dictionary helpers
private extension Dictionary where Key == GridPoint, Value == Game.Space {
    init(width: Int, height: Int, mineCount: Int, initialMove: GridPoint) {
        let allGridPoints = Set<GridPoint>(width: 0..<width, height: 0..<height)
        var board = [GridPoint: Game.Space](minimumCapacity: width * height)
        board.setMines(allGridPoints.subtracting([initialMove]).shuffled().prefix(mineCount))
        board.calculateCounts(allGridPoints)
        self = board
    }

    mutating private func setMines(_ mineGridPoints: some Collection<GridPoint>) {
        for index in mineGridPoints {
            self[index] = .mine
        }
    }

    mutating private func calculateCounts(_ gridPoints: some Collection<GridPoint>) {
        for index in gridPoints {
            switch self[index] {
            case .mine: break
            case .empty, .none:
                self[index] = .empty(emptyCount(index))
            }
        }
    }

    private func emptyCount(_ gridPoint: GridPoint) -> Int {
        gridPoint.surroundingGridPoints.filter { index in
            switch self[index] {
            case .empty, .none: return false
            case .mine: return true
            }
        }.count
    }

    var mineGridPoints: Set<GridPoint> {
        let gridPoints = self.filter { _, value in
            switch value {
            case .empty: return false
            case .mine: return true
            }
        }.keys
        return Set(gridPoints)
    }
}

private extension GridPoint {
    var surroundingGridPoints: Set<GridPoint> {
        let minColumn = x - 1
        let maxColumn = x + 1
        let minRow = y - 1
        let maxRow = y + 1
        var surroundingGridPoints = Set<GridPoint>(width: minColumn...maxColumn, height: minRow...maxRow)
        surroundingGridPoints.remove(self)
        return surroundingGridPoints
    }
}
