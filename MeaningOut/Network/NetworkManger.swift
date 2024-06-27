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
    
    
    func callRequest(api:ShoppingAPI, compeltion: @escaping (Result<Shopping, Error>) -> Void){

        AF.request(api.endPoint,
                   method: api.method,
                   parameters: api.parameter,
                   encoding: URLEncoding(destination: .queryString),
                   headers: api.header)
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

