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
    @Published var width: Int { didSet { reset() } }
    @Published var height: Int { didSet { reset() } }
    @Published var mineCount: Int { didSet { reset() } }
    @Published var elapsed: Int
    @Published var status: Status = .active
    @Published private var minefield: Minefield?
    @Published var showSettings: Bool = false
    private var timer: AnyCancellable?
    private var cancellales = Set<AnyCancellable>()

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
        guard let gridPoint = minefield?[point], gridPoint.info == .empty  else { return }
        let surrounding = Set(minefield?.pointsSurrounding(point) ?? [])
            .subtracting(alreadyChecked)
        for point in surrounding {
            guard minefield?[point].state != .flagged else { continue }
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
            .map { minefield, mineCount -> GameState.Status in
                minefield?.status(mineCount: mineCount) ?? .unstarted
            }
            .assign(to: \.status, on: self)
            .store(in: &cancellales)
        $status
            .map { $0 == .active }
            .removeDuplicates()
            .map { $0 ? self.prepareTimer() : nil }
            .assign(to: \.timer, on: self)
            .store(in: &cancellales)
    }

    private func prepareTimer() -> AnyCancellable {
        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.elapsed += 1 }
    }
}

private extension Minefield {
    func status(mineCount: Int) -> GameState.Status {
        if revealed.contains(.mine) {
            return .loss
        } else if unrevealed.count == mineCount {
            return .win
        } else {
            return .active
        }
    }
}
