//
//  ProfileImageView.swift
//  MeaningOut
//
//  Created by 박다현 on 6/13/24.
//

import UIKit

class ProfileImageView:UIImageView{
    
    init() {
        super.init(frame: .zero)
        layer.borderColor = AppColor.primary.cgColor
        layer.borderWidth = 3
        contentMode = .scaleAspectFit
        layer.cornerRadius = 50
        clipsToBounds = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
