//
//  UserDefaultsManager.swift
//  MeaningOut
//
//  Created by 박다현 on 6/14/24.
//

import Foundation


@propertyWrapper
struct UserDefault<T>{
    
    let key:String
    let defaultValue: T
    
    var wrappedValue: T{
        get{UserDefaults.standard.object(forKey: key) as? T ?? self.defaultValue }
        set{UserDefaults.standard.setValue(newValue, forKey: key)}
    }
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

enum UserDefaultsManager{
    
    @UserDefault(key: "profileImage", defaultValue: nil)
    static var profileImage:String?
    
    @UserDefault(key: "nickName", defaultValue: nil)
    static var nickName:String?
    
    @UserDefault(key: "searchTerms", defaultValue: [])
    static var searchTerms:Array<String>
    
    @UserDefault(key: "favorite", defaultValue: [:])
    static var favorite:Dictionary<String, Bool>
    
    
    static var signUpDate:String{
        get{
            return  UserDefaults.standard.string(forKey: "signUpDate") ?? ""
        }
        set{
            let stringFormat = "M/dd/yyyy, HH:mm a"
            let formatter = DateFormatter()
            formatter.dateFormat = stringFormat
            formatter.locale = Locale(identifier: "ko")
            guard let tempDate = formatter.date(from: newValue) else { return }
            formatter.dateFormat = "yyyy. MM. dd 가입"
            
            let newDate = formatter.string(from: tempDate)
            
            
            UserDefaults.standard.setValue(newDate, forKey: "signUpDate")
        }
    }
}

