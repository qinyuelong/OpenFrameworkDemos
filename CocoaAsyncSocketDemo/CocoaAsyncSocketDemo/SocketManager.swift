//
//  SocketManager.swift
//  CocoaAsyncSocketDemo
//
//  Created by qinge on 2017/4/11.
//  Copyright © 2017年 qin. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class SocketManager: NSObject{
    
    static let sharedInstance = SocketManager()
    lazy var socketManager = GCDAsyncSocket(delegate: sharedInstance, delegateQueue: .main)

    let host = "127.0.0.1"
    let port: UInt16 = 6969
    let tag = 110
    
    private override init(){}
    
    //MARK: - 链接服务器
    func connect() -> Bool {
        do {
            try socketManager.connect(toHost: host,onPort: port)
            return true
        } catch _ {
            return false
        }
    }
    
    func disConnect() {
        socketManager.disconnect()
    }
    
    //MARK: - 发送消息
    func sendMessage(_ message: String) {
        let messageData = message.data(using: .utf8)
        // 第二个参数，请求超时时间
        socketManager.write(messageData!, withTimeout: -1, tag: tag)
    }
    
    
    //MARK: - 监听消息
    fileprivate func pullMessage() {
        // 监听读数据的代理  -1永远监听，不超时，但是只收一次消息，所以每次接受到消息还得调用一次
        socketManager.readData(withTimeout: -1, tag: tag)
    }

}

//MARK: - GCDAsyncSocketDelegate
extension SocketManager: GCDAsyncSocketDelegate{
    //  连接成功调用
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("连接成功,host: \(host),port:\(port)")
        
        pullMessage()
        
        //心跳写在这...
    }
    
    
    //  断开连接的时候调用
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("断开连接,host:\(String(describing: sock.localHost)),port:\(sock.localPort)")
        //断线重连写在这...
    }
    
    //  写成功的回调
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        print("发送成功回调")
    }
    
    //  收到消息的回调
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let message = String(data: data, encoding: .utf8)
        print("收到消息: \(String(describing: message))")
        
        // 由于接受消息设置的是不超时接受方式 每次只能接受一条消息 需要不停调用接受方法 以接受后续消息
        pullMessage()
    }
    
    //MARK: - 设置读取超时时间 超过设置时间自动断开链接 (如果不设置则一直等待读取)
    func socket(_ sock: GCDAsyncSocket, shouldTimeoutReadWithTag tag: Int, elapsed: TimeInterval, bytesDone length: UInt) -> TimeInterval {
        return 10
    }
}


