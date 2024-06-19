//
//  ToastMessage.swift
//  MeaningOut
//
//  Created by 박다현 on 6/19/24.
//

import UIKit


class ToastMessage:UILabel{
    
    init(_ viewController:UIViewController, message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)){
        super.init(frame: CGRect(x: viewController.view.frame.size.width/2 - 100, y: viewController.view.frame.size.height - 200, width: 200, height: 65))
        
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        textColor = UIColor.white
        self.font = font
        textAlignment = .center;
        text = message
        alpha = 1.0
        numberOfLines = 0
        layer.cornerRadius = 10;
        clipsToBounds  =  true
        viewController.view.addSubview(self)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: {(isCompleted) in
            self.removeFromSuperview()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


