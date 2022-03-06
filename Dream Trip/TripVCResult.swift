//
//  TripVCResult.swift
//  Dream Trip
//
//  Created by Stan on 2021/12/5.
//

import UIKit

class TripVCResult: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var resultImg: UIImageView!
    
    @IBOutlet weak var resultText: UITextView!
    
    var img:UIImageView = UIImageView()
    var text:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override  func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resultText.text = text
        resultText.isEditable = false
        resultImg.image = img.image
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollView.contentSize.height = self.resultText.contentSize.height + self.resultImg.frame.height
        }
    }
}
