//
//  Game+SpaceState.swift
//  Minesweeper
//
//  Created by Michael Skiba on 30/06/2022.
//

import Foundation

extension Game {
    enum SpaceState: Hashable {
        case unrevealed
        case revealed(Int)
        case flagged
        case revealedMine
        case flaggedMine
        case incorrectFlag
        case unrevealedMine
    }
}
