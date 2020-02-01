//
//  PlayedState.swift
//  Minesweeper
//
//  Created by Michael Skiba on 26/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import Foundation

enum PlayedState: Hashable {
    case unmarked
    case flagged
    case revealed
    case unknown
    case probed
}
