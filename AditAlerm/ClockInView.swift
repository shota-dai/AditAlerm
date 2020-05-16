//
//  ClockInView.swift
//  AditAlerm
//
//  Created by Shota Dai on 2020/05/16.
//  Copyright © 2020 Shota Dai. All rights reserved.
//

import SwiftUI

struct ClockInView: View {
    
    let popover: NSPopover?
    
    // define clock out time as Now+9h
    @State private var selectedDate = Date(timeIntervalSinceNow: 60*60*9)
    
    var body: some View {
        VStack {
            Text("おはようございます！")
                .font(.system(size: 20))
                .bold()
            Spacer()
                .frame(height: 20)
            Text("退勤予定時刻を設定後、\n「打刻する」もしくは「閉じる」を押してください。")
            Spacer()
                .frame(height: 20)
            DatePicker(selection: $selectedDate, in: Date()..., displayedComponents: .hourAndMinute) {
                Text("退勤予定時刻")
            }
            Spacer()
                .frame(height: 40)
            HStack {
                Button(action: {
                    self.saveClockOutTime()
                    
                    self.popover?.close()
                }){
                    Text("閉じる")
                        .font(.system(size: 15))
                }
                Spacer()
                    .frame(width: 40)
                Button(action: {
                    self.saveClockOutTime()
                    
                    // TODO: adit automatically
                }){
                    Text("打刻する")
                        .font(.system(size: 15))
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func saveClockOutTime() {
        let ud = UserDefaults.standard
        ud.set(self.selectedDate, forKey: "ClockOutTime")
    }
}

struct ClockInView_Previews: PreviewProvider {
    static var previews: some View {
        ClockInView(popover: nil)
    }
}
