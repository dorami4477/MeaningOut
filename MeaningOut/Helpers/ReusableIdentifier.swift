//
//  ReusableIdentifier.swift
//  MeaningOut
//
//  Created by 박다현 on 6/13/24.
//

import UIKit

protocol ReuseIdentifierProtocol:AnyObject{
    static var identifier:String { get }
}


extension UIView:ReuseIdentifierProtocol{
    static var identifier:String{
        return String(describing: self)
    }
}
