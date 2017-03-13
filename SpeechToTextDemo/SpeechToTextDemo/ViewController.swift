//
//  ViewController.swift
//  SpeechToTextDemo
//
//  Created by snqu-qin on 17/3/13.
//  Copyright © 2017年 snqu. All rights reserved.
// http://swift.gg/2016/09/30/siri-speech-framework/

import UIKit
import Speech

@available(iOS 10.0, *)
class ViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        microphoneButton.isEnabled = false
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isButtonEnabled = false
            switch authStatus{
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
            case .notDetermined:
                isButtonEnabled  = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func microphoneTapped(_ sender: UIButton) {
    }
    
    
    //MARK: - SFSpeechRecognizerDelegate
    
    
}

