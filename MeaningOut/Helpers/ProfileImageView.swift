//
//  ProfileImageView.swift
//  MeaningOut
//
//  Created by 박다현 on 6/13/24.
//

import UIKit

class ProfileImageView:UIImageView{
    init(_ imageName:String, active:Bool){
        super.init(frame: .zero)
        if active{
            layer.borderColor = AppColor.primary.cgColor
            layer.borderWidth = 3
        }else{
            layer.borderColor = AppColor.gray01.cgColor
            layer.borderWidth = 1
        }
        image = UIImage(named: imageName)
        contentMode = .scaleAspectFit
        layer.cornerRadius = 50
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
