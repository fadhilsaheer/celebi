//
//  WindowManager.swift
//  Celebi
//
//  Created by Fadhil Saheer on 17/11/25.
//


import SwiftUI
import AppKit

class WindowManager {
    static func createBreakWindow(with view: some View) -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 250),
            styleMask: [.titled, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        window.level = .floating
        window.center()
        window.titlebarAppearsTransparent = true
        window.contentView = NSHostingView(rootView: view)
        
        return window
    }
}
