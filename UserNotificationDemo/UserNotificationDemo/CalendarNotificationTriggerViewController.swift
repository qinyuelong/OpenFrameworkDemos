//
//  CalendarNotificationTriggerViewController.swift
//  UserNotificationDemo
//
//  Created by qinge on 2017/5/13.
//  Copyright © 2017年 qin. All rights reserved.
//

import UIKit
import UserNotifications

class CalendarNotificationTriggerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func notificationButtonPressed(_ sender: AnyObject) {
        let currentDate = Date()
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: currentDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "日历提醒"
        content.body = "到点了"
        let request = UNNotificationRequest(identifier: "CalendarNotificationTriggerViewController", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                UIAlertController.showConfirmAlert(message: error.localizedDescription, in: self)
            } else {
                print("Customized UI Notification scheduled: CalendarNotificationTriggerViewController")
            }
        }
    }

}
