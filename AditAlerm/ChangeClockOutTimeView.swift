//
//  ChangeClockOutTimeView.swift
//  AditAlerm
//
//  Created by Shota Dai on 2020/05/17.
//  Copyright © 2020 Shota Dai. All rights reserved.
//

import SwiftUI

struct ChangeClockOutTimeView: View {
    let popover: NSPopover?
    
    @State private var selectedDate = Setting.shared.getClockOutTime() ?? Date()
    
    var body: some View {
        VStack {
            Text("退勤予定時刻を設定してください。")
                .font(.system(size: 15))
            Spacer()
                .frame(height: 20)
            DatePicker(selection: $selectedDate, in: Date()...generateFinalClockOutTime()!, displayedComponents: .hourAndMinute) {
                Text("退勤予定時刻")
            }
            Spacer()
                .frame(height: 40)
            HStack {
                Button(action: {                    
                    self.popover?.close()
                }){
                    Text("キャンセル")
                        .font(.system(size: 15))
                }
                Spacer()
                    .frame(width: 40)
                Button(action: {
                    Setting.shared.saveClockOutTime(self.selectedDate)

                    self.popover?.close()
                }){
                    Text("設定")
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

struct ChangeClockOutTimeView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeClockOutTimeView(popover: nil)
    }
}
