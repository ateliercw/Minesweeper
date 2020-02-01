//
//  MineInfo.swift
//  Minesweeper
//
//  Created by Michael Skiba on 26/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import Foundation

enum MineInfo: Hashable {
    case mine
    case empty
    case count(Int)
}
