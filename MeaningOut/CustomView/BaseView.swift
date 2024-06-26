//
//  BaseView.swift
//  MeaningOut
//
//  Created by 박다현 on 6/26/24.
//

import UIKit

class BaseView:UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    func configureHierarchy(){}
    func configureLayout(){}
    func configureView(){}
    

    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
