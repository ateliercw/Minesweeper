//
//  Image+imageAsset.swift
//  Minesweeper
//
//  Created by Michael Skiba on 30/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import SwiftUI

private class ImageBundleClass {}
extension Image {
    init(_ imageAsset: ImageAsset) {
        self = Image.init(imageAsset.name,
                          bundle: Bundle(for: ImageBundleClass.self))
    }
}
