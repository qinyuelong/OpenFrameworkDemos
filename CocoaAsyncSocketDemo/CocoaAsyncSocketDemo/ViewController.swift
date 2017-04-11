//
//  ViewController.swift
//  CocoaAsyncSocketDemo
//
//  Created by qinge on 2017/4/11.
//  Copyright © 2017年 qin. All rights reserved.
//  http://www.jianshu.com/p/2dbb360886a8

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func sendMessageAction(_ sender: UIButton) {
        let message = textField.text
        guard message != nil else {
            return
        }
        
        SocketManager.sharedInstance.sendMessage(message!)
    }
    
    @IBAction func connectToServer(_ sender: UIButton){
        let b = SocketManager.sharedInstance.connect()
        if b {
            print("链接成功")
        }else{
            print("链接失败")
        }
    }
    
    
    
    @IBAction func disConnectAction(_ sender: UIButton) {
        SocketManager.sharedInstance.disConnect()
    }

}



extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

