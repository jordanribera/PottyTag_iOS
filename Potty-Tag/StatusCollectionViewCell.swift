//
//  StatusCollectionViewCell.swift
//  Potty-Tag
//
//  Created by Admin on 6/18/15.
//  Copyright (c) 2015 Tag Creative Studio. All rights reserved.
//

import UIKit

class StatusCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView:UIImageView!

    var gender : Gender!{
        didSet{
            self.setupData()
        }
    }
    
    func setupData(){
        imageView.image = UIImage(named: gender.description())
    }
    
}


enum Gender{
    case Male,
    Female
    
    func description() -> String {
        switch self {
        case Male:
            return "male_sign"
        case Female:
            return "female_sign"
        }
    }
    
}