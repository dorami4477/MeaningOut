//
//  ShoppingRepository.swift
//  MeaningOut
//
//  Created by 박다현 on 7/6/24.
//

import Foundation
import RealmSwift

class ShoppingRepository{
    let realm = try! Realm()
    //print(realm.configuration.fileURL)
    
    func createData(data:ShoppingTable){
        
        try! realm.write {
            realm.add(data)
        }
    }

    func deleteData(data:ShoppingTable){
        let data = realm.object(ofType: ShoppingTable.self, forPrimaryKey: data.productId)!
        try! realm.write {
            realm.delete(data)
        }
    }
    
    //read one
    func fetchSingleItem(_ id:String) -> ShoppingTable?{
        let specificItem = realm.object(ofType: ShoppingTable.self, forPrimaryKey: id)
        return specificItem
    }
    
    //read all
    func fetchAllItem() -> [ShoppingTable]{
        let value = realm.objects(ShoppingTable.self)
        return Array(value)
    }
    
}
