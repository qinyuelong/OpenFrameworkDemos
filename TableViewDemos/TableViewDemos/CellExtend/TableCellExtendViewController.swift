//
//  TableCellExtendViewController.swift
//  TableViewDemos
//
//  Created by qinge on 2018/5/28.
//  Copyright © 2018年 qin. All rights reserved.
//

import UIKit

class TableCellExtendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TestTableViewCellDelegate {
    
    var dataArray: [Model] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 25
        
        for i in 0 ... 15 {
            let model = Model()
            model.content = "\(i) Copyright © 2018年 qin. All rights reserved. Created by qinge on 2018/5/24. TestViewController.swift Copyright © 2018年 qin. All rights reserved. Created by qinge on 2018/5/24. TestViewController.swift"
            model.isOpening = false
            dataArray.append(model)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as! TestTableViewCell
        cell.setupModel(dataArray[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return Bundle.main.loadNibNamed("SectionHeader", owner: self, options: nil)?.first as? UIView
    }
    
    
    //MARK: - TestTableViewCellDelegate
    func didClickedShowAllButton(_ cell: TestTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)!
        let model = dataArray[indexPath.row]
        model.isOpening = !model.isOpening!
        tableView.reloadData()
        // 非常重要 少了 layoutSubviews section header 位置会错误
        tableView.layoutSubviews()
    }
    
}



class Model {
    var content: String?
    var isOpening: Bool?
}

