//
//  AppDelegate.swift
//  Minesweeper
//
//  Created by Michael Skiba on 26/11/2019.
//  Copyright © 2019 Atelier Clockwork. All rights reserved.
//

import Cocoa
import SwiftUI
import Combine

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    private let state = GameState(configuration: .init(width: 9, height: 9, mineCount: 10))

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = MainView(state: state)

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [
                .titled,
                .closable,
                .miniaturizable,
                .resizable,
                .fullSizeContentView
            ],
            backing: .buffered,
            defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        window.backgroundColor = Asset.appBackground.color
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction private
    // swiftlint:disable:next prohibited_interface_builder
    func showPreferences(sender: AnyObject?) {
        state.showSettings.toggle()
    }
}
