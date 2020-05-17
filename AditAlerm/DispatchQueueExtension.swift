//
//  DispatchQueueExtension.swift
//  AditAlerm
//
//  Created by Shota Dai on 2020/05/17.
//  Copyright © 2020 Shota Dai. All rights reserved.
//

import Foundation

extension DispatchQueue {
    func cancelableAsyncAfter(deadline: DispatchTime, execute: @escaping () -> Void) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: execute)
        asyncAfter(deadline: deadline, execute: item)
        return item
    }
}
