//
//  UserDefaultsManager.swift
//  MeaningOut
//
//  Created by 박다현 on 6/14/24.
//

import Foundation

enum UserDefaultsManager{
    
    static var profileImage:String?{
        get{
          return  UserDefaults.standard.string(forKey: "profileImage")
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "profileImage")
        }
    }
    
    static var nickName:String?{
        get{
          return  UserDefaults.standard.string(forKey: "nickName")
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "nickName")
        }
    }
    
    static var searchTerms:Array<String>{
        get{
            guard let terms = UserDefaults.standard.array(forKey: "searchTerms") as? [String] else { return []}
            return terms
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "searchTerms")
        }
    }
    
    static var favorite:Dictionary<String, Bool>{
        get{
            guard let fav = UserDefaults.standard.dictionary(forKey: "favorite") as? [String : Bool] else { return [:]}
            return fav
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "favorite")
        }
    }
}
