//
//  ManagementViewController.swift
//  UserNotificationDemo
//
//  Created by snqu-qin on 2017/5/8.
//  Copyright © 2017年 qin. All rights reserved.
//

import UIKit
import UserNotifications

class ManagementViewController: UIViewController {
    
    let title1Content: UNNotificationContent = {
        let content = UNMutableNotificationContent()
        content.title = "1"
        content.body = "Notification 1"
        return content
    }()
    
    let title2Content: UNNotificationContent = {
        let content = UNMutableNotificationContent()
        content.title = "2"
        content.body = "Notification 2"
        return content
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pendingRemovalPressed(_ sender: AnyObject) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let identifier = UserNotificationType.pendingRemoval.rawValue
        let request = UNNotificationRequest(identifier: identifier, content: title1Content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                UIAlertController.showConfirmAlert(message: error.localizedDescription, in: self)
            }else{
                print("Notification request added: \(identifier)")
            }
        }
        delay(2){
            print("Notification request removed: \(identifier)")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        }
    }
    
    @IBAction func pendingUpdatePressed(_ sender: AnyObject) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let identifier = UserNotificationType.pendingUpdate.rawValue
        let request = UNNotificationRequest(identifier: identifier, content: title1Content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                UIAlertController.showConfirmAlert(message: error.localizedDescription, in: self)
            } else {
                print("Notification request added: \(identifier) with title1")
            }
        }
        
        delay(2) { 
            let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let newRequest = UNNotificationRequest(identifier: identifier, content: self.title2Content, trigger: newTrigger)
            UNUserNotificationCenter.current().add(newRequest, withCompletionHandler: { (error) in
                if let error = error {
                    UIAlertController.showConfirmAlert(message: error.localizedDescription, in: self)
                } else {
                    print("Notification request updated: \(identifier) with title2")
                }
            })
        }
    }
    
    @IBAction func deliveredRemovalPressed(_ sender: AnyObject) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let identifier = UserNotificationType.deliveredRemoval.rawValue
        let request = UNNotificationRequest(identifier: identifier, content: title1Content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                UIAlertController.showConfirmAlert(message: error.localizedDescription, in: self)
            }else{
                print("Notification request added: \(identifier)")
            }
        }
        
        delay(4) {
            // Delivered: 已交货的
            print("Notification request removed: \(identifier)")
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
        }
    }
    
    @IBAction func deliveredUpdatePressed(_ sender: AnyObject) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let identifier = UserNotificationType.pendingUpdate.rawValue
        let request = UNNotificationRequest(identifier: identifier, content: title1Content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                UIAlertController.showConfirmAlert(message: error.localizedDescription, in: self)
            } else {
                print("Notification request added: \(identifier) with title1")
            }
        }
        
        delay(4) { 
            let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let newRequest = UNNotificationRequest(identifier: identifier, content: self.title2Content, trigger: newTrigger)
            UNUserNotificationCenter.current().add(newRequest, withCompletionHandler: { (error) in
                if let error = error {
                    UIAlertController.showConfirmAlert(message: error.localizedDescription, in: self)
                } else {
                    print("Notification request updated: \(identifier) with title2")
                }
            })
        }
    }

}
