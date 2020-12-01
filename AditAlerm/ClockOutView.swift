//
//  ClockOutView.swift
//  AditAlerm
//
//  Created by Shota Dai on 2020/05/17.
//  Copyright © 2020 Shota Dai. All rights reserved.
//

import SwiftUI

struct ClockOutView: View {
    
    let popover: NSPopover?
    
    @State private var workingFromHome = true
    @State private var needToOpenTimeTracking = true
    
    var body: some View {
        VStack {
            Text("お疲れ様です！")
                .font(.system(size: 20))
                .bold()
            Spacer()
                .frame(height: 20)
            Text("退勤予定時刻になりました。\n「打刻する」もしくは「閉じる」を押してください。")
            Spacer()
                .frame(height: 20)
            Toggle(isOn: $workingFromHome) {
                Text("在宅勤務")
                    .font(.system(size: 14))
            }
            Toggle(isOn: $needToOpenTimeTracking) {
                Text("閉じるボタン押下後or打刻完了後にTimelyを開く")
                    .font(.system(size: 14))
            }
            Spacer()
                .frame(height: 40)
            HStack {
                Button(action: {
                    self.closePopover(needToAdit: false)
                }){
                    Text("閉じる")
                        .font(.system(size: 15))
                }
                Spacer()
                    .frame(width: 40)
                Button(action: {
                    self.closePopover(needToAdit: true)
                }){
                    Text("打刻する")
                        .font(.system(size: 15))
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func closePopover(needToAdit: Bool) {
        self.popover?.close()
        
        if needToAdit {
            Jobcan.shared.adit(type: AditType.clockOut, workingFromHome: self.workingFromHome)
        }
        
        if self.needToOpenTimeTracking {
            Timely.shared.open()
        }
    }
}

struct ClockOutView_Previews: PreviewProvider {
    static var previews: some View {
        ClockOutView(popover: nil)
    }
}
