//
//  CustomizeUIViewController.swift
//  UserNotificationDemo
//
//  Created by qinge on 2017/5/9.
//  Copyright © 2017年 qin. All rights reserved.
//

import UIKit
import UserNotifications


class CustomizeUIViewController: UIViewController {

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
        content.title = "Image Notification"
        content.body = "Show me some images!"
        
        let imageNames = ["image", "onevcat"]
        let attachments = imageNames.flatMap { (name) -> UNNotificationAttachment? in
            if let imageURL = Bundle.main.url(forResource: name, withExtension: "jpg") {
                return try? UNNotificationAttachment(identifier: "image-\(name)", url: imageURL, options: nil)
            }
            return nil
        }
        content.attachments = attachments
        content.userInfo = ["items": [["title": "Photo 1", "text": "Cute girl"], ["title": "Photo 2", "text": "Cute cat"]]]
        
        // Set category to use customized UI
        content.categoryIdentifier = UserNotificationCategoryType.customUI.rawValue
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let requestIdentifier = UserNotificationType.customUI.rawValue
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                UIAlertController.showConfirmAlert(message: error.localizedDescription, in: self)
            } else {
                print("Customized UI Notification scheduled: \(requestIdentifier)")
            }
        }
        
    }
}
