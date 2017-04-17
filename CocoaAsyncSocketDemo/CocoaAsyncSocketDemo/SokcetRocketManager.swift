//
//  SokcetRocketManager.swift
//  CocoaAsyncSocketDemo
//
//  Created by snqu-qin on 2017/4/12.
//  Copyright © 2017年 qin. All rights reserved.
//

import Foundation
import SocketRocket

enum DisConnectType: Int {
    case byUser = 1000
    case byServer = 1001
}

class SokcetRocketManager: NSObject{
    
    static let sharedInstance = SokcetRocketManager()
    
    let host = "127.0.0.1"
    let port: UInt16 = 6969
    
//    let host = "192.168.1.200"
//    let port: UInt16 = 9999
    
    let tag = 110
    
    var webSocket: SRWebSocket!
    var heartBeat: Timer!
    var reConnectTime: TimeInterval!
    
    private override init(){
        super.init()
        initSocket()
    }
    
    
    //MARK: - Methods
    
    func connect() {
//        webSocket.open()
        
        //每次正常连接的时候清零重连时间
        reConnectTime = 0
    }
    
    func disConnect() {
        guard let _ = webSocket else {
            return
        }
        webSocket.close()
        webSocket = nil
    }

    func sendMessage(_ message: String) {
        let data = message.data(using: .utf8)
        webSocket.send(data)
    }
    
    func reConnect() {
        disConnect()
        
        // 超过一分钟就不再重连 所以只会重连5次 2^5 = 64
        if reConnectTime > 64 {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + reConnectTime) {
            self.webSocket = nil
            self.initSocket()
        }
        
        if reConnectTime == 0 {
            reConnectTime = 2.0
        }else{
            reConnectTime = reConnectTime * 2.0
        }
    }
    
    
    func pingPong() {
        webSocket.sendPing(nil)
    }
    
}

//MARK: - private methods
fileprivate extension SokcetRocketManager{
    
    // 初始化连接
    func initSocket() {
        // websocket 已经赋值 直接返回
        guard webSocket == nil else {
            return
        }
        
        webSocket = SRWebSocket(url: URL(string: "ws://\(host):\(port)"))
        webSocket.delegate = self
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        webSocket.setDelegateOperationQueue(queue)
        webSocket.open()
    }
    
    // 初始化心跳
    func initHeartBeat() {
        DispatchQueue.main.async {
//            self.destoryHeartBeat() // 不能在这里在一次async 否则线程顺序问题 导致 timer 刚启动就被销毁 回调失效
            if self.heartBeat != nil {
                self.heartBeat.invalidate()
                self.heartBeat = nil
            }
            if #available(iOS 10.0, *) {
                self.heartBeat = Timer.scheduledTimer(withTimeInterval: 3 * 60, repeats: true, block: {
                    [unowned self]
                    (_) in
                  print("发送心跳包")
                    self.sendMessage("heart")
                    
                })
            } else {
                self.heartBeat = Timer(timeInterval: 3 * 60, target: self, selector: #selector(self.sendHeartBeat), userInfo: nil, repeats: true)
                RunLoop.current.add(self.heartBeat, forMode: .commonModes)
                self.heartBeat.fire()
            }
        }
    }
    
    //  取消心跳
    func destoryHeartBeat() {
        DispatchQueue.main.async {
            guard let _ = self.heartBeat else{
                return
            }
            self.heartBeat.invalidate()
            self.heartBeat = nil
        }
    }
    
    // 定时发送心跳包
    @objc func sendHeartBeat() {
        print("发送心跳包")
        sendMessage("heart")
    }
    
}

//MARK: - SRWebSocketDelegate

extension SokcetRocketManager: SRWebSocketDelegate{
    
    //MARK: - 收到服务器返回的消息
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        print("服务器返回收到消息:\(message)")
    }
    
    //MARK: - 连接成功
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        print("链接成功")
        
        pingPong()
        // 连接成功了开始发送心跳
        initHeartBeat()
    }
    
    //MARK: - open失败的时候调用
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        print("链接失败 ... \(error)")
        
        // 失败了就去重连
        reConnect()
    }
    
    //MARK: - 网络连接中断被调用
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print("被关闭链接 code: \(code) reason: \(reason), weClean: \(wasClean)")
        
        // 如果是被用户自己中断的那么直接断开连接，否则开始重连
        if code == DisConnectType.byUser.rawValue {
            disConnect()
        }else{
            reConnect()
        }
        
        //断开连接时销毁心跳
        destoryHeartBeat()
    }
    
    //sendPing的时候，如果网络通的话，则会收到回调，但是必须保证ScoketOpen，否则会crash
    func webSocket(_ webSocket: SRWebSocket!, didReceivePong pongPayload: Data!) {
        print("收到 pong 回调")
    }
    
    // 将收到的消息，是否需要把data转换为NSString，每次收到消息都会被调用，默认YES
    func webSocketShouldConvertTextFrame(toString webSocket: SRWebSocket!) -> Bool {
        return true
    }
    
}

