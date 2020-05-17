//
//  Setting.swift
//  AditAlerm
//
//  Created by Shota Dai on 2020/05/17.
//  Copyright © 2020 Shota Dai. All rights reserved.
//

import Foundation

class Setting {
    static let shared = Setting()
    private init() {}
    
    private let keyClockOutTime = "ClockOutTime"

    func getClockOutTime() -> Date? {
        let ud = UserDefaults.standard
        return ud.object(forKey: keyClockOutTime) as? Date
    }
    
    func saveClockOutTime(date: Date) {
        let ud = UserDefaults.standard
        ud.set(date, forKey: keyClockOutTime)
    }
}
