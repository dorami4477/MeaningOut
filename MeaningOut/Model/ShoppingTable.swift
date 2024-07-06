//
//  ShoppingTable.swift
//  MeaningOut
//
//  Created by 박다현 on 7/6/24.
//

import Foundation
import RealmSwift

class ShoppingTable: Object {
    @Persisted(primaryKey: true) var productId: String
    @Persisted var title: String
    @Persisted var link: String
    @Persisted var image: String
    @Persisted var lprice: String
    @Persisted var hprice: String
    @Persisted var mallName: String
    @Persisted var productType: String
    @Persisted var brand: String
    @Persisted var maker: String
    @Persisted var category1: String
    @Persisted var category2: String
    @Persisted var category3: String
    @Persisted var category4: String
    
    convenience init(productId: String, title: String, link: String, image: String, lprice: String, hprice: String, mallName: String, productType: String, brand: String, maker: String, category1: String, category2: String, category3: String, category4: String) {
        self.init()
        self.productId = productId
        self.title = title
        self.link = link
        self.image = image
        self.lprice = lprice
        self.hprice = hprice
        self.mallName = mallName
        self.productType = productType
        self.brand = brand
        self.maker = maker
        self.category1 = category1
        self.category2 = category2
        self.category3 = category3
        self.category4 = category4
    }
}
