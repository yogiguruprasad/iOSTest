//
//  FriendsCollectionViewCell.swift
//  iOSTest
//
//  Created by Diksha on 04/09/21.
//

import UIKit

class FriendsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var friendImageView:UIImageView!
    @IBOutlet weak var friendNameLabel:UILabel!
    @IBOutlet weak var countryLabel:UILabel!
    
    var friend:Friend?{
        didSet {
            updateUI()
        }
    }
    func updateUI() {
        friendNameLabel.text = friend?.name?.fullName
        countryLabel.text = friend?.location?.country
        friendImageView.downloaded(from: friend?.picture?.large ?? "")
    }
    func addShadow() {
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
}
