//
//  MapViewController1.swift
//  Dream Trip
//
//  Created by Stan on 2021/11/9.
//

import UIKit
import MapKit //偏視覺
import CoreLocation  //偏資料
import SafariServices

class MapVC1: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    let lm = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        let uiButton = searchBar.value(forKey: "cancelButton") as! UIButton
        uiButton.setTitle("取消", for: .normal)
        uiButton.isHidden = true
        
        lm.delegate = self
        lm.requestAlwaysAuthorization()
        lm.startUpdatingLocation()
        print("開始定位使用者位置")
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
                        if let location = locations.first{
                            print("經度：\(location.coordinate.longitude)")
                            print("緯度：\(location.coordinate.latitude)")
                            print("高度：\(location.altitude)")
        
                lm.stopUpdatingLocation()
                print("停止定位使用者位置")
                }
            }
    }
    
    @IBAction func navi(_ sender: UIButton) {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(searchBar.text!) {
            placemarks, error in
            
            if error == nil
            {
                if placemarks != nil
                {
                    let toPlaceMark = placemarks!.first!
                    let toPin = MKPlacemark(placemark: toPlaceMark)
                    let destMapItem = MKMapItem(placemark: toPin)
                    let naviOption = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                    destMapItem.openInMaps(launchOptions: naviOption)
                }
            }
            else
            {
                self.alertView(title: "地址格式錯誤", message: "請重新輸入！")
                print("地址解碼錯誤：\(error!.localizedDescription)")
            }
        }
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

extension MapVC1: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchArray = citiArray.filter({ (string) -> Bool in
//            return  string.prefix(searchText.count) == searchText
//        })
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let uiButton = searchBar.value(forKey: "cancelButton") as! UIButton
        uiButton.isHidden = false
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let uiButton = searchBar.value(forKey: "cancelButton") as! UIButton
        uiButton.isHidden = true
        searchBar.resignFirstResponder()
        }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let uiButton = searchBar.value(forKey: "cancelButton") as! UIButton
        uiButton.isHidden = true
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
  }

