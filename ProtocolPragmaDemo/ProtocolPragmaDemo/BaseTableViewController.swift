//
//  BaseTableViewController.swift
//  ProtocolPragmaDemo
//
//  Created by qinge on 2017/6/24.
//  Copyright © 2017年 qin. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    var lastId: Int? = nil
    var hasNext = true
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func  loadNext() {
        if isLoading  { return }
        if hasNext {
            isLoading = true
            doLoad(handler: { (result) in
//                self.lastId = //...
//                self.hasNext = //...
            })
        }
    }
    
    
    func doLoad(handler: @escaping (Any?) -> Void) {
        fatalError("You should implement it in subclass!")
    }
}
