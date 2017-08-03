//
//  FriendTableViewController.swift
//  ProtocolPragmaDemo
//
//  Created by qinge on 2017/6/24.
//  Copyright © 2017年 qin. All rights reserved.
//

import UIKit
import APIKit

class FriendTableViewController: UITableViewController {

    var nextPageState = NextPageState<Int>()
    var data: [Friend] = []
    typealias client = Session
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadNext()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == data.count - 1 {
            loadNext() }
    }
}


extension FriendTableViewController: NextPageLoadable {
    func performLoad(successHandler: @escaping ([Friend], Bool, Int?) -> (), failHandler: @escaping () -> ()) {
        client.send(FriendRequest(), callbackQueue: nil) { (result) in
            let f = result.value?.items
            if (f != nil) {
                let b = result.value?.hasNext
                let lastId = result.value?.items.last?.id
                successHandler(f!, b!, lastId)
            }else {
                failHandler()
            }
        }
    }
}
