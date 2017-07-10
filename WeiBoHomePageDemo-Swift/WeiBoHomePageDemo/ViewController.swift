//
//  ViewController.swift
//  WeiBoHomePageDemo
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var canScroll: Bool = true
    @IBOutlet weak var mainTableView: UITableView!
    var mainCell: MainTableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.rowHeight = view.frame.size.height - 64
        mainTableView.tableFooterView = UIView()
        let notificationName = Notification.Name("kLeaveTopNtf")
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.onOtherScrollToTop(notificatiion:)), name: notificationName, object: nil)
        
        let gesture = UIPanGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(gesture)
        gesture.delegate = mainTableView as? UIGestureRecognizerDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if mainCell == nil {
            mainCell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainTableViewCell
        }
        return mainCell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tabOffsetY = mainTableView.rect(forSection: 0).origin.y - 64
        if scrollView.contentOffset.y >= tabOffsetY {
            scrollView.contentOffset = CGPoint(x: 0, y: tabOffsetY)
            if canScroll {
                canScroll = false
                self.mainCell.canScroll = true
            }
        }else{
            if !canScroll {
                scrollView.contentOffset = CGPoint(x: 0, y: tabOffsetY)
            }
        }
    }
    
    func onOtherScrollToTop(notificatiion: NSNotification) {
        canScroll = true
        mainCell.canScroll = false
    }
    
}
