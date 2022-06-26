//
//  SettingsService.swift
//  Minesweeper
//
//  Created by Michael Skiba on 23/06/2022.
//

import SwiftUI

class SettingsService: ObservableObject {
    @AppStorage("width") var width: Int = 9
    @AppStorage("height") var height: Int = 9
    @AppStorage("mineCount") var mineCount: Int = 10
}
