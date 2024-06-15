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
    
    static var signUpDate:String{
        get{
            return  UserDefaults.standard.string(forKey: "signUpDate") ?? ""
        }
        set{
            let stringFormat = "M/dd/yyyy, HH:mm a"
            let formatter = DateFormatter()
            formatter.dateFormat = stringFormat
            formatter.locale = Locale(identifier: "ko")
            guard let tempDate = formatter.date(from: newValue) else { return}
            formatter.dateFormat = "yyyy. MM. dd 가입"
            
            let newDate = formatter.string(from: tempDate)
            
            
            UserDefaults.standard.setValue(newDate, forKey: "signUpDate")
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
