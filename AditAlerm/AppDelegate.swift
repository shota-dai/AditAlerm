//
//  AppDelegate.swift
//  AditAlerm
//
//  Created by Shota Dai on 2020/05/16.
//  Copyright © 2020 Shota Dai. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "Icon")
            
            self.statusBarItem.menu = createMenu()
        }
    }
    
    private func createMenu() -> NSMenu {
        let menu = NSMenu()
        
        let aditMenuItem = NSMenuItem()
        aditMenuItem.title = "打刻"
        aditMenuItem.action = #selector(adit)
        
        let changeClockOutTimeMenuItem = NSMenuItem()
        changeClockOutTimeMenuItem.title = "退勤時刻変更"
        changeClockOutTimeMenuItem.action = #selector(changeClockOutTime)
        
        let quitMenuItem = NSMenuItem()
        quitMenuItem.title = "終了"
        quitMenuItem.action = #selector(quitApp)
        
        menu.addItem(aditMenuItem)
        menu.addItem(changeClockOutTimeMenuItem)
        menu.addItem(quitMenuItem)
        return menu
    }
    
    @objc private func adit() {
        // TODO: adit automatically by using Sellenium
    }
    
    @objc private func changeClockOutTime() {
        // TODO: change clock out time
    }
    
    @objc private func quitApp() {
        // TODO: quit this app
    }
}

