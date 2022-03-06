//
//  ViewController.swift
//  Dream Trip
//
//  Created by Stan on 2021/11/1.
//

import UIKit

class ExploreVC: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var region = [Any]()
    var town = [Any]()
    var name = [Any]()
    var toldescribe = [Any]()
    var add = [Any]()
    var tel = [Any]()
    var pic = [Any]()
    
    var searchArray: [String] = [String]()
    var searching = false
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            tableView.dataSource = self
            searchBar.delegate = self
            
            let uiButton = searchBar.value(forKey: "cancelButton") as! UIButton
            uiButton.setTitle("取消", for: .normal)
            uiButton.isHidden = true
            
            let url = Bundle.main.url(forResource: "trip", withExtension: "json")!

            do{
                let data = try Data(contentsOf: url)
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String:Any]]
                
                for p in jsonObj{
                    region.append(p["Region"]!)
                    town.append(p["Town"]!)
                    name.append(p["Name"]!)
                    toldescribe.append(p["Toldescribe"]!)
                    add.append(p["Add"]!)
                    tel.append(p["Tel"]!)
                    pic.append(p["Picture1"]!)
                }
            }catch{
                print(error.localizedDescription)
            }
        }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
        return region.count
        
//            if searching {
//                return searchArray.count
//            } else {
//                return region.count
//            }
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreTVCell", for: indexPath) as! ExploreTVCell
        
        let queue = DispatchQueue.global()
        queue.async {
            let url = URL(string: self.pic[indexPath.row] as! String)
            let urlFail = URL(string: "https://raw.githubusercontent.com/stan001182/mac.pic/e35f2368e77770278a240ccad12682aab2ac1254/images/lostPic.jpg")
            let data = try? Data(contentsOf: url!)
            let dataFail = try? Data(contentsOf: urlFail!)
            let img = UIImage(data: (data ?? dataFail)!)
            img?.jpegData(compressionQuality: 0.1)
    
            DispatchQueue.main.async {
                    cell.cell_Img.image = img
            }
        }
        cell.cell_Img.image = UIImage(named: "AppIcon_empty_bg")
        cell.cell_Label.text = "縣市：\((region[indexPath.row] as? String)!) 地區：\((town[indexPath.row] as? String)!)"
        cell.cell_Label0.text = name[indexPath.row] as? String
        
        
//            if searching {
//                cell.textLabel?.text = searchArray[indexPath.row]
//            } else {
//                let randomInt = Int.random(in: 0...21)
//                cell.textLabel?.text = "縣市：\((region[indexPath.row] as? String)!) 地區：\((town[indexPath.row] as? String)!)"
//                cell.detailTextLabel?.text = name[indexPath.row] as? String
//                cell.imageView?.image = UIImage(named: String(randomInt))
//            }
//            cell.selectionStyle = .none
        
            return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "ExploreDetailVC") as? ExploreDetailVC {
            
            let url = URL(string: pic[indexPath.row] as! String)
            let urlFail = URL(string: "https://raw.githubusercontent.com/stan001182/mac.pic/e35f2368e77770278a240ccad12682aab2ac1254/images/lostPic.jpg")
            let data = try? Data(contentsOf: url!)
            let dataFail = try? Data(contentsOf: urlFail!)
            let img = UIImage(data: (data ?? dataFail)!)

            img?.jpegData(compressionQuality: 0.1)
            
            controller.regionText = (region[indexPath.row] as? String)!
            controller.townText = (town[indexPath.row] as? String)!
            controller.nameText = (name[indexPath.row] as? String)!
            controller.toldescribeText = (toldescribe[indexPath.row] as? String)!
            controller.addText = (add[indexPath.row] as? String)!
            controller.telText = (tel[indexPath.row] as? String)!
            controller.backgroundPicImg = UIImage(named: (region[indexPath.row] as? String)!)
            controller.viewPicImg = img
            show(controller, sender: self)
        }
    }
    deinit{
        print("deinit")
    }
}

extension ExploreVC: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchArray = citiArray.filter({ (string) -> Bool in
//            return  string.prefix(searchText.count) == searchText
//        })
//        searching = true
//        tableView.reloadData()
//    }
    //MARK: - searchbar
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let uiButton = searchBar.value(forKey: "cancelButton") as! UIButton
        uiButton.isHidden = false
        uiButton.setTitleColor(.red, for: .normal)
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
        searching = false
        tableView.reloadData()
    }
  }
