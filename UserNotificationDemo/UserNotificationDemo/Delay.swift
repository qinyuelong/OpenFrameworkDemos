//
//  Delay.swift
//  UserNotificationDemo
//
//  Created by snqu-qin on 2017/5/8.
//  Copyright © 2017年 qin. All rights reserved.
//

import Foundation

func delay(_ timeInterval: TimeInterval, _ block: @escaping ()-> Void) {
    let after = DispatchTime.now() + timeInterval
    DispatchQueue.main.asyncAfter(deadline: after, execute: block)
}
