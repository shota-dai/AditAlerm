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
        Setting.clockOutTime = nil
        
        cancelScheduledProcesses()
    }
    
    func popoverDidClose(_ aNotification: Notification) {
        print("clock popover closed")
        
        if let isClockOutPopoverClosedExplicitly = Setting.isClockOutPopoverClosedExplicitly {
            if isClockOutPopoverClosedExplicitly {
                clockOutPopoverDidClose()
            }
            
            Setting.isClockOutPopoverClosedExplicitly = nil
        } else {
            clockInPopoverDidClose()
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
    
    private func setupClockInPopover() {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 340, height: 280)
        popover.behavior = .transient
        popover.delegate = self
        self.clockInPopover = popover
    }
    
    private func setupClockOutPopover() {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 360, height: 280)
        popover.behavior = .transient
        popover.delegate = self
        self.clockOutPopover = popover
    }

    private func setupChangeClockOutTimePopover() {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 180)
        popover.behavior = .transient
        popover.delegate = self
        self.changeClockOutTimePopover = popover
    }
    
    private func showClockInPopover(view: NSView) {
        let contentView = ClockInView(popover: self.clockInPopover)
        self.clockInPopover.contentViewController = NSHostingController(rootView: contentView)
        
        self.clockInPopover.show(relativeTo: view.bounds, of: view, preferredEdge: NSRectEdge.minY)
    }

    @objc private func showClockOutPopover() {
        guard let view = self.statusBarItem.button else {
            return
        }
     
        Setting.isClockOutPopoverClosedExplicitly = false
        
        let contentView = ClockOutView(popover: self.clockOutPopover)
        self.clockOutPopover.contentViewController = NSHostingController(rootView: contentView)
        
        self.clockOutPopover.show(relativeTo: view.bounds, of: view, preferredEdge: NSRectEdge.minY)
    }

    private func showChangeClockOutTimePopover(view: NSView) {
        let contentView = ChangeClockOutTimeView(popover: self.changeClockOutTimePopover)
        self.changeClockOutTimePopover.contentViewController = NSHostingController(rootView: contentView)
        
        self.changeClockOutTimePopover.show(relativeTo: view.bounds, of: view, preferredEdge: NSRectEdge.minY)
    }
    
    private func clockInPopoverDidClose() {
        guard let clockOutTime = Setting.clockOutTime else {
            return
        }
        print("clockOutTime: \(clockOutTime)")

        cancelScheduledProcesses()

        scheduleClockOutNotification(clockOutTime)

        workItem = DispatchQueue.main.cancelableAsyncAfter(deadline: .now() + clockOutTime.timeIntervalSinceNow) {
            Setting.clockOutTime = nil

            if let button = self.statusBarItem.button {
                button.image = NSImage(named: "ClockOutStatusBarIcon")
                button.action = #selector(self.showClockOutPopover)
            }
            self.statusBarItem.menu = nil
            
            self.showClockOutPopover()
        }
    }
    
    private func clockOutPopoverDidClose() {
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "StatusBarIcon")
            button.action = nil
        }
        
        self.statusBarItem.menu = createMenu()
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
    
    private func dateFormat(date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        return f.string(from: date)
    }
    
    @objc private func applicationWillSleep() {
        print("sleep... - \(Date())")
    }

    @objc private func applicationDidWake() {
        print("wake up! - \(Date())")
        
        if !self.clockInPopover.isShown && dateFormat(date: lastWakeTime) != dateFormat(date: Date()) {
            guard let button = self.statusBarItem.button else {
                return
            }
            
            if Setting.clockOutTime == nil {
                showClockInPopover(view: button)
            }
            // execute process after 3 seconds when waking up from sleep
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.showClockInPopover(view: button)
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
            showChangeClockOutTimePopover(view: button)
        }
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(self)
    }
}

