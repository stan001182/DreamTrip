//
//  TripVC0.swift
//  Dream Trip
//
//  Created by Stan on 2021/11/23.
//

import UIKit
import PhotosUI
import FirebaseStorage


class addVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    @IBOutlet weak var diaryText: UITextView!
    
    @IBOutlet weak var imgPic: UIImageView!
    
    @IBAction func takePic(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera)
        else
        {
            print("無法使用相機")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func albumPic(_ sender: UIButton) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = PHPickerFilter.images
        configuration.preferredAssetRepresentationMode = .current
        configuration.selection = .ordered
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func storage(_ sender: UIButton) {
        guard diaryText.text != "" else{
            alertView(title: "尚未輸入心情文字", message: "無法儲存")
            return
        }
        let firebase_storage:Storage
        firebase_storage = Storage.storage()
        let reference_root:StorageReference
        reference_root = firebase_storage.reference()
        
        let date_time:Date = Date()
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "日期:yyyyMMdd 時間:HH:mm:ss"
        let ddd:String = formatter.string(from: date_time)
        
        
        let data:Data? = diaryText.text.data(using: .utf8)
        upload_tofirebase_storage(reference_root: reference_root, data: data!, file_name:  ddd + ".txt" )
        
        let data2:Data = (self.imgPic.image?.jpegData(compressionQuality: 0.5))!
        upload_tofirebase_storage(reference_root: reference_root, data: data2, file_name: ddd + ".jpeg")
        
    }
    
    @IBAction func reset(_ sender: UIButton) {
        diaryText.text = ""
        imgPic.image =  UIImage(named: "select_pic")
        alertView(title: "有新的靈感嗎？", message: "已重置！可重新填寫～")
        diaryText.reloadInputViews()
        imgPic.reloadInputViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        diaryText.layer.borderColor = UIColor.black.cgColor
        diaryText.layer.borderWidth = 1
        
        imgPic.layer.borderColor = UIColor.black.cgColor
        imgPic.layer.borderWidth = 1
        
        hideKeyboardWhenTappedAround()
        
        diaryText.delegate = self
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        print("info:\(info)")
        
        let image = info[.originalImage] as! UIImage
        imgPic.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - PHPickerViewControllerDelegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult])
    {
        print("挑選到的照片：\(results)")
        
        if let itemProvider = results.first?.itemProvider
        {
            if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier)
            {
                itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) {
                    data, error
                    in
                    guard let photoData = data
                    else
                    {
                        return
                    }
                    DispatchQueue.main.async {
                        self.imgPic.image = UIImage(data: photoData)
                        picker.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func upload_tofirebase_storage(reference_root:StorageReference ,data:Data, file_name:String){
        let reference_i_save:StorageReference = reference_root.child(file_name)
        reference_i_save.putData(data, metadata: nil){
            (info,error)
            in
            if let err = error{
                print("Upload process ERROR!!")
                print(err)
            }else{
                print("uploading process is OK")
                if let meta = info{
                    print(meta)
                    self.alertView1(title: "已儲存您的旅遊心情", message: "成功上傳")
                }else{
                    print("server not load!!")
                }
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
    
    func alertView1(title:String, message:String){
        var popup_controller:UIAlertController
        popup_controller = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let button:UIAlertAction = UIAlertAction(
            title: "確定",
            style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.diaryText.text = ""
                self.imgPic.image =  UIImage(named: "select_pic")
                self.diaryText.reloadInputViews()
                self.imgPic.reloadInputViews()
            }
        popup_controller.addAction(button)
        self.present(popup_controller, animated: true, completion: nil)
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

extension addVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
