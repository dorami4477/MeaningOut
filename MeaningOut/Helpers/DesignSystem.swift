//
//  Contant.swift
//  MeaningOut
//
//  Created by 박다현 on 6/13/24.
//

import UIKit

enum AppColor {
    static let primary = UIColor(red: 0.51, green: 0.25, blue: 1.00, alpha: 1.00)
    static let black = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00)
    static let gray01 = UIColor(red: 0.30, green: 0.30, blue: 0.30, alpha: 1.00)
    static let gray02 = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00)
    static let gray03 = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1.00)
    static let white = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
    static let passGreen = UIColor(red: 0.29, green: 0.77, blue: 0.00, alpha: 1.00)
    static let bubble:[UIColor] = [UIColor(red: 0.38, green: 0.00, blue: 0.67, alpha: 1.00), UIColor(red: 0.51, green: 0.25, blue: 1.00, alpha: 1.00), UIColor(red: 0.70, green: 0.29, blue: 0.84, alpha: 1.00), UIColor(red: 0.91, green: 0.37, blue: 0.51, alpha: 1.00), UIColor(red: 0.95, green: 0.65, blue: 0.19, alpha: 1.00)]
}

enum AppFont{
    static let size13 = UIFont.systemFont(ofSize: 13)
    static let size13Bold = UIFont.boldSystemFont(ofSize: 13)
    static let size14 = UIFont.systemFont(ofSize: 14)
    static let size14Bold = UIFont.boldSystemFont(ofSize: 14)
    static let size15 = UIFont.systemFont(ofSize: 15)
    static let size15Bold = UIFont.boldSystemFont(ofSize: 15)
    static let size16 = UIFont.systemFont(ofSize: 16)
    static let size16Bold = UIFont.boldSystemFont(ofSize: 16)
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
    static let bagFill = "like_selected"
    static let bag = "like_unselected"
    static let search = "magnifyingglass"
    static let person = "person"
}


enum FilterName:String {
    case sim = "정확도"
    case date = "날짜순"
    case dsc = "가격높은순"
    case asc = "가격낮은순"
}
