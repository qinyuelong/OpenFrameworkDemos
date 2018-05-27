//
//  TestTableViewCell.swift
//  Test
//
//  Created by qinge on 2018/5/24.
//  Copyright © 2018年 qin. All rights reserved.
//

import UIKit

protocol TestTableViewCellDelegate{
    func didClickedShowAllButton(_ cell: TestTableViewCell)
}

class TestTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var showAllButton: UIButton!
    var delegate: TestTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupModel(_ model: Model) {
        contentLabel.text = model.content
        if model.isOpening! {
            contentLabel.numberOfLines = 0
            showAllButton.setTitle("收起", for: .normal)
        }else{
            contentLabel.numberOfLines = 2
            showAllButton.setTitle("展开", for: .normal)
        }
    }

    @IBAction func showAllButtonDidClicked(_ sender: Any) {
        if (delegate != nil) {
            delegate?.didClickedShowAllButton(self)
        }
        
    }
}
