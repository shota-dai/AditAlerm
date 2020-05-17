//
//  ClockOutView.swift
//  AditAlerm
//
//  Created by Shota Dai on 2020/05/17.
//  Copyright © 2020 Shota Dai. All rights reserved.
//

import SwiftUI
import PythonKit

struct ClockOutView: View {
    
    private let aditProfileName = "ForAdit"
    
    let popover: NSPopover?
    
    var body: some View {
        VStack {
            Text("お疲れ様です！")
                .font(.system(size: 20))
                .bold()
            Spacer()
                .frame(height: 20)
            Text("退勤予定時刻になりました。\n「打刻する」もしくは「閉じる」を押してください。")
            Spacer()
                .frame(height: 40)
            HStack {
                Button(action: {
                    self.popover?.close()
                }){
                    Text("閉じる")
                        .font(.system(size: 15))
                }
                Spacer()
                    .frame(width: 40)
                Button(action: {
                    self.popover?.close()
                    
                    self.adit()
                }){
                    Text("打刻する")
                        .font(.system(size: 15))
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func adit() {
        do {
            let webdriver = try Python.attemptImport("selenium.webdriver")
            
            let options = webdriver.ChromeOptions()
            // create new Chrome profile for this app if not existing
            options.add_argument("--user-data-dir=/Users/\(NSUserName())/Library/Application Support/Google/Chrome/\(aditProfileName)")
            
            let driver = webdriver.Chrome(chrome_options: options, executable_path: "/usr/local/bin/chromedriver")

            driver.get("http://jobcan.jp/login/pc-employee/?client_id=isana")
            print("url: \(driver.current_url)")

            switch driver.current_url {
            case "https://ssl.jobcan.jp/employee" :
                driver.find_element_by_id("adit-button-push").click()
            case "https://id.jobcan.jp/users/sign_in?app_key=atd&redirect_to=https://ssl.jobcan.jp/jbcoauth/callback":
                driver.find_element_by_class_name("google__a").click()

                let aditPushButtons = driver.find_elements_by_id("adit-button-push")
                if aditPushButtons.count == 1 {
                    aditPushButtons.first!.click()
                }
                // when not logged in Google
                else {
                    let wait = Python.import("selenium.webdriver.support.wait")
                    let ec = Python.import("selenium.webdriver.support.expected_conditions")
                    // wait for user logging in Google
                    wait.WebDriverWait(driver, 60*10).until(ec.url_matches("^(https\\:\\/\\/ssl\\.jobcan\\.jp\\/employee).*"))

                    driver.find_element_by_id("adit-button-push").click()
                }
            default:
                openJobcan()
                return
            }

            // wait for completion of status update
            sleep(5)

            driver.quit()
        } catch {
            print("Selenium not installed")

            openJobcan()
        }
    }
    
    private func openJobcan() {
        let result = NSWorkspace.shared.open(URL(string: "http://jobcan.jp/login/pc-employee/?client_id=isana")!)
        print("opening JOBCAN is successful?: \(result)")
    }
}

struct ClockOutView_Previews: PreviewProvider {
    static var previews: some View {
        ClockOutView(popover: nil)
    }
}
