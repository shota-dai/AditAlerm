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
class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate, NSUserNotificationCenterDelegate {

    var statusBarItem: NSStatusItem!
    var clockInPopover: NSPopover!
    var clockOutPopover: NSPopover!
    var changeClockOutTimePopover: NSPopover!
    
    var lastWakeTime = Date(timeIntervalSinceNow: -60*60*24)
    
    var notification: NSUserNotification?
    var workItem: DispatchWorkItem?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupNotificationCenter()
        
        setupStatusBar()
        
        setupClockInPopover()
        setupClockOutPopover()
        setupChangeClockOutTimePopover()
        
        applicationDidWake()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        cancelScheduledProcesses()
    }
    
    func popoverDidClose(_ aNotification: Notification) {
        print("clock in popover closed")
        
        guard let clockOutTime = Setting.shared.getClockOutTime() else {
            return
        }
        print("clockOutTime: \(clockOutTime)")

        cancelScheduledProcesses()

        scheduleClockOutNotification(clockOutTime)

        workItem = DispatchQueue.main.cancelableAsyncAfter(deadline: .now() + clockOutTime.timeIntervalSinceNow) {
            if let button = self.statusBarItem.button {
                self.clockOutPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    private func setupNotificationCenter() {
        let notificationCenter = NSWorkspace.shared.notificationCenter
        notificationCenter.addObserver(self, selector: #selector(applicationWillSleep), name: NSWorkspace.willSleepNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(applicationDidWake), name: NSWorkspace.didWakeNotification, object: nil)
    }
    
    private func setupStatusBar() {
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "StatusBarIcon")
            
            self.statusBarItem.menu = createMenu()
        }
    }
    
    private func setupClockInPopover() {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 340, height: 240)
        popover.behavior = .transient
        popover.delegate = self
        self.clockInPopover = popover
        
        let contentView = ClockInView(popover: popover)
        self.clockInPopover.contentViewController = NSHostingController(rootView: contentView)
    }
    
    private func setupClockOutPopover() {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 340, height: 200)
        popover.behavior = .transient
        self.clockOutPopover = popover
        
        let contentView = ClockOutView(popover: popover)
        self.clockOutPopover.contentViewController = NSHostingController(rootView: contentView)
    }
    
    private func setupChangeClockOutTimePopover() {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 180)
        popover.behavior = .transient
        popover.delegate = self
        self.changeClockOutTimePopover = popover
        
        let contentView = ChangeClockOutTimeView(popover: popover)
        self.changeClockOutTimePopover.contentViewController = NSHostingController(rootView: contentView)
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
    
    private func scheduleClockOutNotification(_ clockOutTime: Date) {
        let notification = NSUserNotification()
        notification.title = "退勤予定時刻の10分前です！"
        notification.informativeText = "時刻に変更がある場合はアプリメニューから変更できます。"
        notification.deliveryDate = Calendar.current.date(byAdding: .minute, value: -10, to: clockOutTime)
        self.notification = notification
        
        NSUserNotificationCenter.default.delegate = self
        NSUserNotificationCenter.default.scheduleNotification(notification)
    }
    
    private func cancelScheduledProcesses() {
        if let n = notification {
            NSUserNotificationCenter.default.removeScheduledNotification(n)
        }
        notification = nil
        
        if let item = workItem {
            item.cancel()
        }
        workItem = nil
    }
    
    @objc private func applicationWillSleep() {
        print("sleep... - \(Date())")
    }

    @objc private func applicationDidWake() {
        print("wake up! - \(Date())")
        
        if dateFormat(date: lastWakeTime) != dateFormat(date: Date()) {
            if let button = self.statusBarItem.button {
                if !self.clockInPopover.isShown {
                    self.clockInPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                }
            }
        }
        
        lastWakeTime = Date()
    }
    
    @objc private func oepnJobcan() {
        Jobcan.shared.open()
    }
    
    @objc private func changeClockOutTime() {
        if let button = self.statusBarItem.button {            
            self.changeClockOutTimePopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(self)
    }
}

