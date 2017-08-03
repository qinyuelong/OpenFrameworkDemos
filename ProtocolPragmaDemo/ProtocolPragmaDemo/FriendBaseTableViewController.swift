//
//  FriendBaseTableViewController.swift
//  ProtocolPragmaDemo
//
//  Created by qinge on 2017/6/24.
//  Copyright © 2017年 qin. All rights reserved.
//

import UIKit
import APIKit

class FriendBaseTableViewController: BaseTableViewController {

    private var data: [Friend] = []
    typealias client = Session
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadNext()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func doLoad(handler: @escaping (Any?) -> Void) {
        client.send(FriendRequest(lastId: lastId!)) {
            result in
            handler(result)
            // ...
            self.data = (result.value?.items)!
            self.tableView.reloadData()
        }
    }
}
