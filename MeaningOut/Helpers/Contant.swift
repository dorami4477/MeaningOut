//
//  Contant.swift
//  MeaningOut
//
//  Created by 박다현 on 6/13/24.
//

import UIKit

enum AppColor {
    static let primary = UIColor(red: 0.94, green: 0.54, blue: 0.28, alpha: 1.00)
    static let black = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00)
    static let gray01 = UIColor(red: 0.30, green: 0.30, blue: 0.30, alpha: 1.00)
    static let gray02 = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
    static let gray03 = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.00)
    static let white = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
    static let passGreen = UIColor(red: 0.29, green: 0.77, blue: 0.00, alpha: 1.00)
}

enum NicknameValidation:String{
    case pass = "사용할 수 있는 닉네임이에요."
    case length = "2글자 이상 10글자 미만으로 설정해주세요."
    case specialLetters = "닉네임에 @, #, $, % 는 포함할 수 없어요."
    case integer = "닉네임에 숫자는 포함 할 수 없어요."
    
    var messageColor:UIColor{
        switch self {
        case .pass:
            return AppColor.passGreen
        default:
            return AppColor.primary
        }
    }
}

enum ProfileCell {
    static let spacingWidth:CGFloat = 10
    static let cellColumns:CGFloat = 4
}

enum ShoppingCell {
    static let spacingWidth:CGFloat = 20
    static let cellColumns:CGFloat = 2
}


enum IconName {
    static let bagFill = "bag.fill.badge.minus"
    static let bag = "bag.badge.plus"
}
