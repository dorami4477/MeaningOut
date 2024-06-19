//
//  Shopping.swift
//  MeaningOut
//
//  Created by 박다현 on 6/14/24.
//

import Foundation

struct Shopping:Decodable{
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    var items: [Item]
}

struct Item:Decodable{
    let title: String
    let link: String
    let image: String
    let lprice: String
    let hprice: String
    let mallName: String
    let productId: String
    let productType: String
    let brand: String
    let maker: String
    let category1: String
    let category2: String
    let category3: String
    let category4: String
    
    
    var titleBoldTag:String{
        var newTitle = title.replacingOccurrences(of: "<b>", with: "")
        newTitle = newTitle.replacingOccurrences(of: "</b>", with: "")
        return newTitle
    }
    
    var price:String{
        guard let priceInt = Int(lprice) else { return "0" }
        return priceInt.formatted() + "원"
    }
    
}
