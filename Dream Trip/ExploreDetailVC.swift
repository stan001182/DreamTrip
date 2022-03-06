//
//  ExploreDetailVC.swift
//  Dream Trip
//
//  Created by Stan on 2021/12/8.
//

import UIKit
import MapKit
import AVFoundation

class ExploreDetailVC: UIViewController, AVSpeechSynthesizerDelegate {

    @IBOutlet weak var backgroungPic: UIImageView!
    
    @IBOutlet weak var viewPic: UIImageView!
    
    @IBOutlet weak var region: UILabel!
    
    @IBOutlet weak var town: UILabel!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var toldescribe: UITextView!
    
    @IBOutlet weak var add: UILabel!
    
    @IBOutlet weak var tel: UILabel!
    
    @IBOutlet weak var soundNavi: UIButton!
    
    var backgroundPicImg:UIImage?
    var viewPicImg:UIImage?
    var regionText = ""
    var townText = ""
    var nameText = ""
    var toldescribeText = ""
    var addText = ""
    var telText = ""
    
    let speechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
    var speechUtterance:AVSpeechUtterance = AVSpeechUtterance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechSynthesizer.delegate = self
        
        backgroungPic.image = backgroundPicImg
        viewPic.image = viewPicImg
        region.text = regionText
        town.text = townText
        name.text = nameText
        toldescribe.text = toldescribeText
        add.text = addText
        tel.text = telText
        
        toldescribe.isEditable = false
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        soundNavi.setTitle("語音導覽", for: .normal)
        speechSynthesizer.stopSpeaking(at: .immediate)
        print("畫面消失")
    }
    
    @IBAction func navi(_ sender: UIButton) {
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(add.text!) {
            placemarks, error in
            //沒有錯誤時，表示地址可以順利編碼成經緯度資訊
            if error == nil
            {
                //可以取得經緯度資訊時
                if placemarks != nil
                {
                    //Step1.
                    //(第一層)取得地址對應的經緯度資訊的位置標示
                    let toPlaceMark = placemarks!.first!
                    //(第二層)將經緯度資訊的位置標示轉換成導航地圖上目的地的大頭針
                    let toPin = MKPlacemark(placemark: toPlaceMark)
                    //(第三層)產生導航地圖上導航終點的大頭針
                    let destMapItem = MKMapItem(placemark: toPin)
                    //Step2.設定導航為開車模式
                    let naviOption = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                    //Step3.使用(第三層)來開啟導航地圖
                    destMapItem.openInMaps(launchOptions: naviOption)
                    
                }
            }
            else
            {
                self.alertView(title: "地址錯誤", message: "找不到此地點！請google!")
                print("地址解碼錯誤：\(error!.localizedDescription)")
            }
        }
    }
    
    @IBAction func callBtn(_ sender: UIButton) {
        if let phoneNumber = tel.text
        {
            let url = URL(string: "telprompt://\(phoneNumber)")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func soundNavi(_ sender: UIButton) {
        
        speechUtterance = AVSpeechUtterance(string: "景點：\(name.text!)，位於\(region.text!)\(town.text!)，\(toldescribe.text!)" )
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "zh_TW")
        
        if !speechSynthesizer.isSpeaking {
        soundNavi.setTitle("停止播放", for: .normal)
        speechSynthesizer.speak(speechUtterance)
        sender.configuration?.background.backgroundColor = .red
        sender.setTitleColor(.black, for: .normal)
            print("播放中")
        }
        else if speechSynthesizer.isSpeaking {
        soundNavi.setTitle("語音導覽", for: .normal)
        speechSynthesizer.stopSpeaking(at: .immediate)
        sender.configuration?.background.backgroundColor = UIColor.init(red: 0.901, green: 0.970, blue: 1.000, alpha: 1)
        sender.setTitleColor(UIColor.init(red: 0.469, green: 0.484, blue: 0.829, alpha: 1), for: .normal)
            print("停止")
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        soundNavi.setTitle("語音導覽", for: .normal)
            print("播放結束")
    }
    
    func alertView(title:String, message:String){
        var popup_controller:UIAlertController
        popup_controller = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let button:UIAlertAction = UIAlertAction(
            title: "確定",
            style: UIAlertAction.Style.default,
            handler:nil
        )
        popup_controller.addAction(button)
        self.present(popup_controller, animated: true, completion: nil)
    }
}
