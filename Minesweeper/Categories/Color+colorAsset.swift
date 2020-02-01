//
//  Color+ColorAsset.swift
//  Minesweeper
//
//  Created by Michael Skiba on 28/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import SwiftUI

extension Color {
    init(_ colorAsset: ColorAsset) {
        self = Color(colorAsset.color)
    }
}
