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
    
    @State private var selectedDate = Date()
    
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
            DatePicker(selection: $selectedDate, in: Date()...generateFinalClockOutTime()!, displayedComponents: .hourAndMinute) {
                Text("退勤予定時刻")
            }
            Spacer()
                .frame(height: 40)
            HStack {
                Button(action: {
                    Setting.clockOutTime = self.selectedDate
                    
                    self.popover?.close()
                }){
                    Text("閉じる")
                        .font(.system(size: 15))
                }
                Spacer()
                    .frame(width: 40)
                Button(action: {
                    Setting.clockOutTime = self.selectedDate

                    self.popover?.close()
                    
                    Jobcan.shared.adit()
                }){
                    Text("打刻する")
                        .font(.system(size: 15))
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func generateFinalClockOutTime() -> Date? {
        let date = Date()
        let calendar = Calendar.current
        
        return calendar.date(
            from: DateComponents(
                year: calendar.component(.year, from: date),
                month: calendar.component(.month, from: date),
                day: calendar.component(.day, from: date),
                hour: 23,
                minute: 59,
                second: 59
            )
        )
    }
}

struct ClockInView_Previews: PreviewProvider {
    static var previews: some View {
        ClockInView(popover: nil)
    }
}
