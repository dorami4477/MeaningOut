//
//  FilterButton.swift
//  MeaningOut
//
//  Created by 박다현 on 6/15/24.
//

import UIKit

class FilterButton:UIButton{
    init(title:String){
        super.init(frame: .zero)
        layer.borderColor = AppColor.gray03.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 15
        clipsToBounds = true
        setTitle(title, for: .normal)
        setTitleColor(AppColor.gray01, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14)
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


