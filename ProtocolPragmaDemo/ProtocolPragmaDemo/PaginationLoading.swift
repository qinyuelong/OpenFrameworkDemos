//
//  PaginationLoading.swift
//  ProtocolPragmaDemo
//
//  Created by qinge on 2017/6/24.
//  Copyright © 2017年 qin. All rights reserved.
//

import Foundation
import APIKit

struct Pagination<T> {
    let items: [T]
    let hasNext: Bool
}

struct ChannelsRequest: Request{

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Pagination<Channel> {
        let c = Channel()
        let p = Pagination(items: [c], hasNext: true)
        return p
    }

    typealias Response = Pagination<Channel>
    let lastId: Int?
    
    var baseURL: URL = URL(string: "")!
    var method: HTTPMethod = HTTPMethod(rawValue: "GET")!
    var path: String = ""
    var parameters: Any? = nil
    
    init(lastId: Int) {
        self.lastId = lastId
    }
}


struct FriendRequest: Request {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Pagination<Friend> {
        let f = Friend()
        let p = Pagination(items: [f], hasNext: true)
        return p
    }
    
    typealias Response = Pagination<Friend>
    var lastId: Int?
    
    var baseURL: URL = URL(string: "")!
    var method: HTTPMethod = HTTPMethod(rawValue: "GET")!
    var path: String = ""
    var parameters: Any? = nil
    
    init() {
        
    }
    
    init(lastId: Int) {
        
    }
}




//MARK: - 使用协议

struct NextPageState<T> {
    private(set) var hasNext: Bool
    private(set) var isLoading: Bool
    private(set) var lastId: T?
    
    init() {
        hasNext = true
        isLoading = false
        lastId = nil
    }
    
    mutating func reset() {
        hasNext = true
        isLoading = false
        lastId = nil
    }
    
    mutating func setIsLoading(_ isLoading: Bool){
        self.isLoading = isLoading
    }
    
    mutating func update(hasNext: Bool, isLoading: Bool, lastId: T?) {
        self.hasNext = hasNext
        self.isLoading = isLoading
        self.lastId = lastId
    }
}




protocol NextPageLoadable: class {
    associatedtype DataType
    associatedtype LastIdType
    
    var data: [DataType] {get set}
    var nextPageState: NextPageState<LastIdType> {get set}
    
    func performLoad(successHandler: @escaping (_ rows: [DataType],
                                      _ haxNext: Bool,
                                      _ lastId: LastIdType?) -> (),
                     failHandler: @escaping () -> ()
    )
}


//MARK: - 添加对其他 reloadableView 的支持

extension NextPageLoadable {
    func loadNext(reloadView view: ReloadableType) {
        guard nextPageState.hasNext else { return }
        if nextPageState.isLoading { return }
        
        self.nextPageState.setIsLoading(true)
        performLoad(successHandler: { (rows, hasNext, lastId) in
            self.data += rows
            self.nextPageState.update(hasNext: hasNext,
                                      isLoading: false,
                                      lastId: lastId)
            view.reloadData()
        }, failHandler: {
            if self.nextPageState.lastId == nil {
                self.data = []
                self.nextPageState.reset()
            }
        })
    }
}


extension NextPageLoadable where Self: UITableViewController {
    
//    func loadNext() {
//        guard nextPageState.hasNext else { return }
//        if nextPageState.isLoading { return }
//        
//        self.nextPageState.setIsLoading(true)
//        performLoad(successHandler: { (rows, hasNext, lastId) in
//            self.data += rows
//            self.nextPageState.update(hasNext: hasNext,
//                                      isLoading: false,
//                                      lastId: lastId)
//            self.tableView.reloadData()
//        }, failHandler: {
//            if self.nextPageState.lastId == nil {
//                self.data = []
//                self.nextPageState.reset()
//            }
//        })
//    }
    
    func loadNext(){
        loadNext(reloadView: tableView)
    }
    
}


extension NextPageLoadable where Self: UICollectionViewController {
    func loadNext() {
        loadNext(reloadView: collectionView!)
    }
}
















