//
//  Jobcan.swift
//  AditAlerm
//
//  Created by Shota Dai on 2020/05/17.
//  Copyright © 2020 Shota Dai. All rights reserved.
//

import Cocoa
import PythonKit

class Jobcan {
    static let shared = Jobcan()
    private init() {}
    
    private let targetUrl = "http://jobcan.jp/login/pc-employee/?client_id=isana"
    private let myPageUrl = "https://ssl.jobcan.jp/employee"
    private let redirectUrl = "https://id.jobcan.jp/users/sign_in?app_key=atd&redirect_to=https://ssl.jobcan.jp/jbcoauth/callback"
    
    private let chromedriverPath = "/usr/local/bin/chromedriver"
    private let aditProfileName = "ForAdit"
    
    private let aditPushButtonId = "adit-button-push"
    private let logInGoogleButtonClass = "google__a"
    
    func adit() {
        do {
            let driver = try prepareWebDriver()

            driver.get(targetUrl)
            print("url: \(driver.current_url)")
            
            switch driver.current_url {
            case PythonObject(stringLiteral: myPageUrl):
                driver.find_element_by_id(aditPushButtonId).click()
            
            // when need to log in Google
            case PythonObject(stringLiteral: redirectUrl):
                driver.find_element_by_class_name(logInGoogleButtonClass).click()

                let aditPushButtons = driver.find_elements_by_id(aditPushButtonId)
                if aditPushButtons.count == 1 {
                    aditPushButtons.first!.click()
                }
                // when not logged in Google
                else {
                    waitForUserLoggingInGoogle(driver: driver)

                    driver.find_element_by_id(aditPushButtonId).click()
                }
            
            default:
                driver.quit()
                
                open()
                return
            }

            // wait for completion of status update
            sleep(5)

            driver.quit()
        } catch {
            print("Selenium not installed")

            open()
        }
    }
    
    func open() {
        let result = NSWorkspace.shared.open(URL(string: targetUrl)!)
        print("opening JOBCAN is successful?: \(result)")
    }
    
    private func prepareWebDriver() throws -> PythonObject {
        let webdriver = try Python.attemptImport("selenium.webdriver")
        
        let options = webdriver.ChromeOptions()
        // create new Chrome profile for this app if not existing
        options.add_argument("--user-data-dir=\(generateProfilePath())")
        
        return webdriver.Chrome(chrome_options: options, executable_path: chromedriverPath)
    }
    
    private func generateProfilePath() -> String {
        return "/Users/\(NSUserName())/Library/Application Support/Google/Chrome/\(aditProfileName)"
    }
    
    private func waitForUserLoggingInGoogle(driver: PythonObject) {
        let wait = Python.import("selenium.webdriver.support.wait")
        let ec = Python.import("selenium.webdriver.support.expected_conditions")

        let pattern = "^(\(NSRegularExpression.escapedPattern(for: myPageUrl))).*"
        wait.WebDriverWait(driver, 60*10).until(ec.url_matches(pattern))
    }
}
