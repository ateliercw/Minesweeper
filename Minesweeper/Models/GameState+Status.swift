//
//  GameState+Status.swift
//  Minesweeper
//
//  Created by Michael Skiba on 27/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import Foundation

extension GameState {
    enum Status {
        case unstarted
        case active
        case win
        case loss

        var isPlayable: Bool {
            switch self {
            case .unstarted, .active: return true
            case .win, .loss: return false
            }
        }
    }
}
