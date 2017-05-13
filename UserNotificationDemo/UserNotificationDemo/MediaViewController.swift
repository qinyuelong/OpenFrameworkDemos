//
//  MediaViewController.swift
//  UserNotificationDemo
//
//  Created by qinge on 2017/5/9.
//  Copyright © 2017年 qin. All rights reserved.
//

import UIKit
import UserNotifications

class MediaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // 设置附件的通知
    @IBAction func notificationButtonPressed(_ sender: AnyObject) {
        let content = UNMutableNotificationContent()
        content.title = "Image Notification"
        content.body = "Show me an image!"
        if let imageURL = Bundle.main.url(forResource: "image", withExtension: "jpg") {
            let attachment = try? UNNotificationAttachment(identifier: "imageAttachment", url: imageURL, options: nil)
            content.attachments = [attachment!]
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let requestIdentifier = UserNotificationType.media.rawValue
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                UIAlertController.showConfirmAlert(message: error.localizedDescription, in: self)
            } else {
                print("Media Notification scheduled: \(requestIdentifier)")
            }
        }
    }

}
