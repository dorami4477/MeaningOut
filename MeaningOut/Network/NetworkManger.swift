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
    
    enum ErrorCode:Error{
        case invalidRequest
        case invalidAuth
        case invalidURL
        case overRequest
        case serverError
    }
    
    func callRequest(api:ShoppingAPI, compeltion: @escaping (Result<Shopping, ErrorCode>) -> Void){
        
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
                let statusCode = response.response?.statusCode
                switch statusCode {
                case 400:
                    print("error:요청 변수 확인")
                    compeltion(.failure(.invalidRequest))
                case 401:
                    print("error:인증 실패")
                    compeltion(.failure(.invalidAuth))
                case 404:
                    print("error:API 없음")
                    compeltion(.failure(.invalidURL))
                case 429:
                    print("error:호출 한도 초과 오류")
                    compeltion(.failure(.overRequest))
                case 500:
                    print("error:서버 오류")
                    compeltion(.failure(.serverError))
                default:
                    print("error:그 외 에러")
                    compeltion(.failure(.invalidRequest))
                }
            }
        }
        
    }
}
