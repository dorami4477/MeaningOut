//
//  ShoppingAPI.swift
//  MeaningOut
//
//  Created by 박다현 on 6/27/24.
//

import Foundation
import Alamofire

enum ShoppingAPI{
    case sim(searchTerm:String, start:Int)
    case date(searchTerm:String, start:Int)
    case dsc(searchTerm:String, start:Int)
    case asc(searchTerm:String, start:Int)
    
    var baseURL:String{
        return "https://openapi.naver.com/v1/"
    }
    
    var endPoint:URL{
        return URL(string: baseURL + "search/shop.json")!
    }
    
    var header:HTTPHeaders{
        return ["X-Naver-Client-Id": APIInfo.clientId, "X-Naver-Client-Secret": APIInfo.clientSecret]
    }
    
    var method:HTTPMethod{
        return .get
    }
    
    
    var parameter:Parameters{
        switch self {
        case .sim(let searchTerm, let start):
            return ["query":searchTerm, "sort":"sim", "startNum":start, "display":"30"]
        case .date(let searchTerm, let start):
            return ["query":searchTerm, "sort":"date", "startNum":start, "display":"30"]
        case .dsc(let searchTerm, let start):
            return ["query":searchTerm, "sort":"dsc", "startNum":start, "display":"30"]
        case .asc(let searchTerm, let start):
            return ["query":searchTerm, "sort":"asc", "startNum":start, "display":"30"]
        }
    }
    
    var fitlerNum:Int{
        switch self {
        case .sim:
            return 0
        case .date:
            return 1
        case .dsc:
            return 2
        case .asc:
            return 3
        }
    }
    
    
}

