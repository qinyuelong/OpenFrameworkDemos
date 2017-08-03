//
//  ReloadableType.swift
//  ProtocolPragmaDemo
//
//  Created by qinge on 2017/6/24.
//  Copyright © 2017年 qin. All rights reserved.
//

import Foundation
import UIKit

protocol ReloadableType {
    func reloadData()
}

extension UITableView: ReloadableType {}
extension UICollectionView: ReloadableType {}
