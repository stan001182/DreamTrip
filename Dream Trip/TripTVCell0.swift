//
//  TripTVCell.swift
//  Dream Trip
//
//  Created by Stan on 2021/11/26.
//

import UIKit

class TripTVCell0: UITableViewCell {

    
    @IBOutlet weak var cell0_Img: UIImageView!
    
    @IBOutlet weak var cell0_Label: UILabel!
    
    @IBOutlet weak var cell0_Label0: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .systemBackground
        self.contentView.backgroundColor = .systemBackground
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.shadowOpacity = 0.5
        self.contentView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if (selected) {
            self.contentView.backgroundColor = UIColor.init(red: 1, green: 0.9, blue: 0.8, alpha: 1)
        }else {
            self.contentView.backgroundColor = .systemBackground
        }
    }

}
