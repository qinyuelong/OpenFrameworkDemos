//
//  NotificationHandler.swift
//  UserNotificationDemo
//
//  Created by qinge on 2017/5/6.
//  Copyright © 2017年 qin. All rights reserved.
//

import UIKit
import UserNotifications

enum UserNotificationType: String {
    case timeInterval
    case timeIntervalForeground
    case pendingRemoval
    case pendingUpdate
    case deliveredRemoval
    case deliveredUpdate
    case actionable
    case mutableContent
    case media
    case customUI
}

enum UserNotificationCategoryType: String {
    case saySomething
    case customUI
}

enum SaySomethingCategoryAction: String {
    case input
    case goodbye
    case none
}

enum CustomizeUICategoryAction: String {
    case `switch`
    case open
    case dismiss
}

extension UserNotificationType {
    
    var descriptionText: String{
        switch self {
        case .timeInterval: return "You need to switch to background to see the notification."
        case .timeIntervalForeground: return "The notification will show in-app. See NotificationHandler for more."
        default: return rawValue
        }
    }
    
    var title: String{
        switch self {
        case .timeInterval: return "Time"
        case .timeIntervalForeground: return "Foreground"
        default: return rawValue
        }
    }
}

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
    
    // 如果代理不实现这个方法 应用在前台时候不会有通知显示
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        guard let notificationType = UserNotificationType(rawValue: notification.request.identifier) else {
            completionHandler([])
            return
        }
        
        let options: UNNotificationPresentationOptions
        switch notificationType {
        case .timeIntervalForeground:
            options = [.alert, .sound]
        case .pendingRemoval:
            options = [.alert, .sound]
        case .pendingUpdate:
            options = [.alert, .sound]
        case .deliveredRemoval:
            options = [.alert, .sound]
        case .deliveredUpdate:
            options = [.alert, .sound]
        case .actionable:
            options = [.alert, .sound]
        case .media:
            options = [.alert, .sound]
        default:
            options = []
        }
        completionHandler(options)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let category = UserNotificationCategoryType(rawValue: response.notification.request.content.categoryIdentifier) {
            switch category {
            case .saySomething:
                handleSaySomthing(response: response)
            case .customUI:
                handleCustomUI(response: response)
            }
        }
        completionHandler()
    }
    
    
    private func handleSaySomthing(response: UNNotificationResponse) {
        let text: String
        if let actionType = SaySomethingCategoryAction(rawValue: response.actionIdentifier) {
            switch actionType {
            case .input:
                text = (response as! UNTextInputNotificationResponse).userText
            case .goodbye: text = "Goodbye"
            case .none: text = ""
            }
        }else{
            // Only tap or clear. (You will not receive this callback when user clear your notification unless       you set .customDismissAction as the option of category)
            text = ""
        }
        if !text.isEmpty {
            UIAlertController.showConfirmAlertFromTopViewController(message: "You just said \(text)")
        }
    }
        
        
    private func handleCustomUI(response: UNNotificationResponse) {
        print(response.actionIdentifier)
    }
}





