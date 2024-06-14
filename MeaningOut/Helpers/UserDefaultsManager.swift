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
}
