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
    var popover: NSPopover!
    
    var lastWakeTime = Date()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupNotificationCenter()
        
        setupStatusBar()
        
        setupPopover()
    }
    
    private func setupNotificationCenter() {
        let notificationCenter = NSWorkspace.shared.notificationCenter
        notificationCenter.addObserver(self, selector: #selector(applicationWillSleep), name: NSWorkspace.willSleepNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(applicationDidWake), name: NSWorkspace.didWakeNotification, object: nil)
    }
    
    private func setupStatusBar() {
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "Icon")
            
            self.statusBarItem.menu = createMenu()
        }
    }
    
    private func setupPopover() {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 340, height: 240)
        popover.behavior = .transient
        self.popover = popover
        
        let contentView = ClockInView(popover: popover)
        popover.contentViewController = NSHostingController(rootView: contentView)
    }
    
    private func createMenu() -> NSMenu {
        let menu = NSMenu()
        
        let oepnJobcanMenuItem = NSMenuItem()
        oepnJobcanMenuItem.title = "ジョブカンを開く"
        oepnJobcanMenuItem.action = #selector(oepnJobcan)
        
        let changeClockOutTimeMenuItem = NSMenuItem()
        changeClockOutTimeMenuItem.title = "退勤時刻変更"
        changeClockOutTimeMenuItem.action = #selector(changeClockOutTime)
        
        let quitMenuItem = NSMenuItem()
        quitMenuItem.title = "終了"
        quitMenuItem.action = #selector(quitApp)
        
        menu.addItem(oepnJobcanMenuItem)
        menu.addItem(changeClockOutTimeMenuItem)
        menu.addItem(quitMenuItem)
        return menu
    }
    
    private func dateFormat(date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        return f.string(from: date)
    }
    
    @objc private func applicationWillSleep() {
        print("sleep...")
    }

    @objc private func applicationDidWake() {
        print("wake up!")
        
        if dateFormat(date: lastWakeTime) != dateFormat(date: Date()) {
            if let button = self.statusBarItem.button {
                if !self.popover.isShown {
                    self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                }
            }
        }
        
        lastWakeTime = Date()
    }
    
    @objc private func oepnJobcan() {
        // TODO: open Jobcan
    }
    
    @objc private func changeClockOutTime() {
        // TODO: change clock out time
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(self)
    }
}

