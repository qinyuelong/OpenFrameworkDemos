//
//  MainTableViewCell.swift
//  WeiBoHomePageDemo
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    var canScroll: Bool = false

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var dynamicTableView: UITableView!
    @IBOutlet weak var needTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dynamicTableView.dataSource = self
        dynamicTableView.delegate = self
        dynamicTableView.rowHeight = 130
        
        needTableView.dataSource = self
        needTableView.delegate = self
        needTableView.rowHeight = 80
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension MainTableViewCell: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView ==  dynamicTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "dynamicCell", for: indexPath)
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "needCell", for: indexPath)
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !canScroll {
            scrollView.setContentOffset(.zero, animated: false)
        }
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            let notificationName = Notification.Name("kLeaveTopNtf")
            NotificationCenter.default.post(name: notificationName, object: 1)
            canScroll = false
            scrollView.contentOffset = .zero
        }
    }
}
