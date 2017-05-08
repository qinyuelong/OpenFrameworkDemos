//
//  ActionableViewController.swift
//  UserNotificationDemo
//
//  Created by qinge on 2017/5/8.
//  Copyright © 2017年 qin. All rights reserved.
//

import UIKit
import UserNotifications

class ActionableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func notificationButtonPressed(_ sender: AnyObject) {
        let content = UNMutableNotificationContent()
        content.body = "Please say something."
        content.categoryIdentifier = UserNotificationCategoryType.saySomething.rawValue
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: UserNotificationType.actionable.rawValue, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

}
