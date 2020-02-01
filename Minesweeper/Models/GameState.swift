//
//  GameState.swift
//  Minesweeper
//
//  Created by Michael Skiba on 26/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import Foundation
import Combine

class GameState: ObservableObject {
    enum Status {
        case unstarted
        case active
        case win
        case loss
    }

    @Published var width: Int

    @Published var height: Int

    @Published var mineCount: Int

    @Published var elapsed: Int

    @Published private var minefield: Minefield?
    private var timer: AnyCancellable?
    private var cancellales = Set<AnyCancellable>()

    @Published var status: Status = .active

    var flaggedCount: Int {
        switch status {
        case .win:
            return mineCount
        case .active, .loss, .unstarted:
            return minefield?.flaggedCount ?? 0
        }
    }

    subscript(_ point: Point) -> GridState {
        return minefield?[point] ?? GridState(state: .unmarked, info: .empty)
    }

    func reveal(_ point: Point) {
        if minefield == nil {
            minefield = Minefield(initialPoint: point, width: width, height: height, mineCount: mineCount)
        }
        guard minefield?[point].state == .unmarked else { return }
        minefield?[point].state = .revealed
        revealSurrounding(point: point, alreadyChecked: [])
    }
    func toggleFlag(_ point: Point) {
        if minefield == nil {
            minefield = Minefield(initialPoint: nil, width: width, height: height, mineCount: mineCount)
        }
        switch minefield?[point].state {
        case .flagged:
            minefield?[point].state = .unmarked
        case .unmarked:
            minefield?[point].state = .flagged
        case .none, .probed, .revealed, .unknown:
            break
        }
    }

    func reset() {
        timer = nil
        elapsed = 0
        minefield = nil
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

    init(width: Int, height: Int, mineCount: Int) {
        self.elapsed = 0
        self.width = width
        self.height = height
        self.mineCount = mineCount
        $minefield
            .combineLatest($mineCount)
            .map { minefield, mineCount -> Status in
                guard let field = minefield else { return .unstarted }
                if field.revealed.contains(.mine) {
                    return .loss
                } else if field.unrevealed.count == mineCount {
                    return .win
                } else {
                    return .active
                }
            }
            .assign(to: \.status, on: self)
            .store(in: &cancellales)
        $status
            .map { $0 == .active }
            .removeDuplicates { $0 == $1 }
            .sink { [weak self] in self?.timer = $0 ? self?.prepareTimer() : nil }
            .store(in: &cancellales)
    }

    private func prepareTimer() -> AnyCancellable {
        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.elapsed += 1 }
    }
}
