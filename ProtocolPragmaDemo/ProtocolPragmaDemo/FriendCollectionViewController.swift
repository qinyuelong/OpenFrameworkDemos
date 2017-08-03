//
//  FriendCollectionViewController.swift
//  ProtocolPragmaDemo
//
//  Created by qinge on 2017/6/24.
//  Copyright © 2017年 qin. All rights reserved.
//

import UIKit
import APIKit


private let reuseIdentifier = "Cell"

class FriendCollectionViewController: UICollectionViewController {
    
    var nextPageState = NextPageState<Int>()
    var data: [Friend] = []
    typealias client = Session

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

}

extension FriendCollectionViewController: NextPageLoadable {
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
