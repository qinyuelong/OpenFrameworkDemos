//
//  WebSocketViewController.swift
//  CocoaAsyncSocketDemo
//
//  Created by snqu-qin on 2017/4/12.
//  Copyright © 2017年 qin. All rights reserved.
//

import UIKit

class WebSocketViewController: UIViewController {

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
        
        SokcetRocketManager.sharedInstance.sendMessage(message!)
    }
    
    @IBAction func connectToServer(_ sender: UIButton){
        SokcetRocketManager.sharedInstance.connect()
    }
    
    
    
    @IBAction func disConnectAction(_ sender: UIButton) {
        SokcetRocketManager.sharedInstance.disConnect()
    }
    
}



extension WebSocketViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

