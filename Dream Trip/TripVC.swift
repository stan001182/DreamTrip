//
//  tripVC0.swift
//  Dream Trip
//
//  Created by Stan on 2021/11/23.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI

class TripVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func editBtn(_ sender: UIBarButtonItem) {
        if tableView.isEditing == false{
            tableView.isEditing = true
            editBtn.title = "取消"
            editBtn.tintColor = .red
        }else{
            tableView.isEditing = false
            editBtn.title = "編輯"
            editBtn.tintColor = .systemBlue
        }
    }
    
    let firebase_storage:Storage = Storage.storage()
    
    var itemResult:[String] = []
    var itemImg:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        let reference_root:StorageReference
        reference_root = firebase_storage.reference()
        reference_root.listAll()
        {
          (result, error)
            in
          if let err = error {
            print(err)
          }
            self.itemResult.removeAll()
            self.itemImg.removeAll()
            for item in result.items {
                let fullPath:String = item.fullPath
                let components:[String] = fullPath.components(separatedBy: ".")
                if(components[1] == "txt"){
                    self.itemResult.append(components[0])
                }
                if components[1] == "jpeg"{
                    self.itemImg.append(components[0])
                }
            }
            self.itemResult.sort(by: >)
            self.itemImg.sort(by: >)
            self.tableView.reloadData()
            print("view即將出現")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return itemResult.count
   }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
       return 1
   }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let select_memory:String = itemResult[indexPath.section]
        let islandRef = firebase_storage.reference().child("\(select_memory).txt")
        
        let select_img:String = itemImg[indexPath.section]
        let reference = firebase_storage.reference().child("\(select_img).jpeg")
        let placeholderImage = UIImage(named: "\(select_img).jpg")
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TripTVCell", for: indexPath) as! TripTVCell
            
            islandRef.getData(maxSize: 1 * 1024 * 1024) {
                (data, error)
                in
                  if let error = error {
                     print(error)
                  } else {
                      let memory:String = String(data: data!, encoding: .utf8)!
                      cell.cell_Label0.text = memory
                  }
            }
             
            cell.cell_Label.text = itemResult[indexPath.section]
            cell.cell_Img.sd_setImage(with: reference, placeholderImage: placeholderImage)
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TripTVCell0", for: indexPath) as! TripTVCell0
            
            islandRef.getData(maxSize: 1 * 1024 * 1024) {
                (data, error)
                in
                  if let error = error {
                     print(error)
                  } else {
                      let memory:String = String(data: data!, encoding: .utf8)!
                      DispatchQueue.main.async {
                      cell.cell0_Label0.text = memory
                      }
                  }
            }
            cell.cell0_Label0.text = ""
            cell.cell0_Label.text = itemResult[indexPath.section]
            cell.cell0_Img.sd_setImage(with: reference, placeholderImage: placeholderImage)
            
            tableView.backgroundColor = .systemBackground
       return cell
        }
   }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            return 300
        }else{
        return 100
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("點選了第：\(indexPath.section) section")
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "TripVCResult") as? TripVCResult {
            
            let reference_root:StorageReference
            reference_root = firebase_storage.reference()
            reference_root.listAll()
            {
              (result, error)
                in
              if let err = error {
                print(err)
              }
                for item in result.items {
                    let fullPath:String = item.fullPath
                    let components:[String] = fullPath.components(separatedBy: ".")
                    if(components[1] == "txt"){
                        self.itemResult.append(components[0])
                    }
                    if components[1] == "jpeg"{
                        self.itemImg.append(components[0])
                    }
                }
                self.itemResult.sort(by: >)
                self.itemImg.sort(by: >)
            }
            
            let select_memory:String = itemResult[indexPath.section]
            let islandRef = firebase_storage.reference().child("\(select_memory).txt")
            
            let select_img:String = itemImg[indexPath.section]
            let reference = firebase_storage.reference().child("\(select_img).jpeg")
            let placeholderImage = UIImage(named: "\(select_img).jpg")
            
                islandRef.getData(maxSize: 1 * 1024 * 1024) {
                    (data, error)
                    in
                      if let error = error {
                         print(error)
                      } else {
                          let memory:String = String(data: data!, encoding: .utf8)!
                          controller.text = memory
                      }
                }
            controller.img.sd_setImage(with: reference, placeholderImage: placeholderImage)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            print(controller.text)
                self.show(controller, sender: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        let select_memory:String = itemResult[indexPath.section]
        let desertRef_memory = firebase_storage.reference().child("\(select_memory).txt")

        let select_img:String = itemImg[indexPath.section]
        let desertRef_img = firebase_storage.reference().child("\(select_img).jpeg")
        
        var err = ""
        
        desertRef_memory.delete { error in
            if error != nil {
             err = "刪除失敗"
            print("刪除失敗")
          } else {
             err = "刪除成功"
            print("刪除成功")
          }
        }

        desertRef_img.delete { error in
            if error != nil {
              err = "刪除失敗"
            print("刪除失敗")
          } else {
              err = "刪除成功"
            print("刪除成功")
          }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.alertView(title: "刪除心得", message: err)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {

        return "刪除心得"
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
            style: UIAlertAction.Style.default) { [self]
                UIAlertAction in
                tableView.isEditing = false
                editBtn.title = "編輯"
                editBtn.tintColor = .systemBlue
                
                let reference_root:StorageReference
                reference_root = firebase_storage.reference()
                reference_root.listAll()
                {
                  (result, error)
                    in
                  if let err = error {
                    print(err)
                  }
                    itemResult.removeAll()
                    itemImg.removeAll()
                    for item in result.items {
                        let fullPath:String = item.fullPath
                        let components:[String] = fullPath.components(separatedBy: ".")
                        if(components[1] == "txt"){
                            itemResult.append(components[0])
                        }
                        if components[1] == "jpeg"{
                            itemImg.append(components[0])
                        }
                    }
                    itemResult.sort(by: >)
                    itemImg.sort(by: >)
                    
                    tableView.reloadData()
                }
            }
        popup_controller.addAction(button)
        self.present(popup_controller, animated: true, completion: nil)
    }
    // MARK: - Keyboard
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
