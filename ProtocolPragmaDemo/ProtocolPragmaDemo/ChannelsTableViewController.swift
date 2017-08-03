//
//  ChannelsTableViewController.swift
//  ProtocolPragmaDemo
//
//  Created by qinge on 2017/6/24.
//  Copyright © 2017年 qin. All rights reserved.
//

import UIKit
import APIKit

class ChannelsTableViewController: UITableViewController {
    
    typealias client = Session
    private var lastId: Int? = nil
    private var hasNext = true
    
    private var data: [Channel] = []
    private var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func load() {
        if isLoading {return}
        if hasNext {
            self.isLoading = true
            client.send(ChannelsRequest(lastId: lastId!), callbackQueue: nil, handler: { (result) in
                self.lastId = result.value?.items.last!.id
                self.hasNext = (result.value?.items.last!.hasNext)!
                self.data = (result.value?.items)!
                self.tableView.reloadData()
                self.isLoading = false
            })
        }
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
            load()
        }
    }

}
