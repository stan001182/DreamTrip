//
//  LogInVC.swift
//  Dream Trip
//
//  Created by Stan on 2021/12/15.
//

import UIKit
import AVFoundation

class LogInVC: UIViewController {
    
    @IBOutlet weak var bgPic: UIImageView!
    
    @IBOutlet weak var accountLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var otherLog: UILabel!
    
    @IBAction func accountField(_ sender: UITextField) {
    }
    
    @IBAction func passwordField(_ sender: UITextField) {
    }
    
    weak var timerPic:Timer?
    weak var timerMusic:Timer?
    var varToReference: Int = 0
    
    
    let player = AVPlayer()
    let fileUrl = Bundle.main.url(forResource: "Duh Fuse - French Fuse", withExtension: "mp3")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        accountLabel.layer.cornerRadius = 10
        accountLabel.layer.borderWidth = 1
        accountLabel.layer.borderColor = UIColor.white.cgColor
        accountLabel.layer.backgroundColor = UIColor.init(red: 0.620, green: 0.502, blue: 0.953, alpha: 0.8).cgColor
        accountLabel.textColor = .white
        
        passwordLabel.layer.cornerRadius = 10
        passwordLabel.layer.borderWidth = 1
        passwordLabel.layer.borderColor = UIColor.white.cgColor
        passwordLabel.layer.backgroundColor = UIColor.init(red: 0.620, green: 0.502, blue: 0.953, alpha: 0.8).cgColor
        passwordLabel.textColor = .white
        
        otherLog.layer.cornerRadius = 10
        otherLog.layer.borderWidth = 1
        otherLog.layer.borderColor = UIColor.white.cgColor
        otherLog.layer.backgroundColor = UIColor.black.cgColor
        otherLog.textColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        timerPic = Timer.scheduledTimer(
            timeInterval: 3.0,
            target: self,
            selector: #selector(changeBgPic),
            userInfo: nil,
            repeats: true)
        
        timerMusic = Timer.scheduledTimer(
            timeInterval: 115.0,
            target: self,
            selector:  #selector(playMusicRepeat),
            userInfo: nil,
            repeats: true)
        
        let playerItem = AVPlayerItem(url: fileUrl)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.timerPic != nil {
            self.timerPic?.invalidate()
            self.timerPic = nil
            print("timerPic停止")
        }
        if self.timerMusic != nil {
            self.timerMusic?.invalidate()
            self.timerMusic = nil
            print("timerMusic停止")
        }
        
        player.pause()
        print("音樂暫停")
    }
    
    @objc func changeBgPic (){
        
        bgPic.image = UIImage(named: String(Int.random(in: 0...43)))
        print("持續換圖中")
        self.varToReference += 1
        print(varToReference)
    }
    
    @objc func playMusicRepeat(){
        
        let playerItem = AVPlayerItem(url: fileUrl)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
