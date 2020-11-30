//
//  Timely.swift
//  AditAlerm
//
//  Created by Shota Dai on 2020/11/29.
//  Copyright © 2020 Shota Dai. All rights reserved.
//

import Cocoa

class Timely {
    static let shared = Timely()
    private init() {}
    
    private let targetUrl = "https://app.timelyapp.com/917393"
    
    func open() {
        let result = NSWorkspace.shared.open(URL(string: targetUrl)!)
        print("opening Timely is successful?: \(result)")
    }
}
