//
//  GridState.swift
//  Minesweeper
//
//  Created by Michael Skiba on 26/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import Foundation

struct GridState: Hashable {
    var state: PlayedState
    let info: MineInfo
}
