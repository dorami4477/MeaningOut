//
//  FilterButton.swift
//  MeaningOut
//
//  Created by 박다현 on 6/15/24.
//

import UIKit

class FilterButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)
        
        layer.borderColor = AppColor.gray03.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 17
        clipsToBounds = true
        
        setTitle(title, for: .normal)

        if title == FilterName.sim.rawValue{
            updateButtonAppearance(true, title:title)
        }else{
            updateButtonAppearance(false, title:title)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateButtonAppearance(_ isSelectedToggle:Bool, title:String) {
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        config.title = title
        config.buttonSize = .mini
        
        if isSelectedToggle {
            config.baseBackgroundColor = AppColor.gray01
            config.baseForegroundColor = AppColor.white
        } else {
            config.baseBackgroundColor = AppColor.white
            config.baseForegroundColor = AppColor.gray01
        }
        
        configuration = config
        
    }
}

