//
//  NetworkManger.swift
//  MeaningOut
//
//  Created by 박다현 on 6/21/24.
//

import Foundation
import Alamofire



class NetworkManger{
    
    static let shared = NetworkManger()
    private init(){}

    func callRequest(searchTerm:String, sort:String, startNum:Int, compeltion: @escaping (Result<Shopping, Error>) -> Void){
        
        let url = "\(APIInfo.url)query=\(searchTerm)&sort=\(sort)&display=30&start=\(startNum)"
        
        let header:HTTPHeaders = ["X-Naver-Client-Id": APIInfo.clientId, "X-Naver-Client-Secret": APIInfo.clientSecret]
                
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Shopping.self){ response in
            switch response.result{
            case .success(let value):
                compeltion(.success(value))
                
            case .failure(let error):
                print(error)
                compeltion(.failure(error))
            }
        }
    }
}


