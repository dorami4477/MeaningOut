//
//  primaryButton.swift
//  MeaningOut
//
//  Created by 박다현 on 6/13/24.
//

import UIKit

class PrimaryButton: UIButton {

    init(title:String, active:Bool) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(AppColor.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        layer.cornerRadius = 20
        clipsToBounds = true
        
        if active{
            backgroundColor = AppColor.primary
        }else{
            backgroundColor = AppColor.gray03
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
