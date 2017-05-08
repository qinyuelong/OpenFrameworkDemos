//
//  TimeIntervalViewController.swift
//  UserNotificationDemo
//
//  Created by snqu-qin on 2017/5/5.
//  Copyright © 2017年 qin. All rights reserved.
//

import UIKit
import UserNotifications

class TimeIntervalViewController: UIViewController {
    
    var notificationType: UserNotificationType!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeTextField: UITextField!
    
    override func viewDidLoad() {
        title = notificationType.title
        descriptionLabel.text = notificationType.descriptionText
    }
    
    @IBAction func scheduleButtonPressed(_ sender: AnyObject) {
        guard let text = timeTextField.text, let timeInterval = TimeInterval(text) else {
            print("Not valid time interval")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Time Interval Notification"
        content.body = "My first notification"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let requestIdentifier = notificationType.rawValue
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                UIAlertController.showConfirmAlert(message: error.localizedDescription, in: self)
            } else {
                print("Time Interval Notification scheduled: \(requestIdentifier)")
            }
        }
    }
    
}
