//
//  API.swift
//  NEW.TMDB.project
//
//  Created by 이윤지 on 6/29/24.
//

import UIKit
import Alamofire
import Kingfisher

class TMDBAPI {
    
    static let shared = TMDBAPI()
    
    private init() {}
    
    typealias typealiasHandler = ([PopularMovie]?, String?) -> Void
    //T를 만들고 : Decodable 하고 .responseDecodable(of: T.self)으로 바꾸고 -> 그럼에도 문법 오류 -> T는 어떤 타입이 들어올 지 호출시점에서 들어와야하는데 와야하는 공간조차 마련되어 있지 않다 그래서 트렌딩헨들러에서 @escaping (T?, jackError) -> Void) 으로 구성 ->  completionHandler(value, nil)
    func fetchSimilarMovies<T: Decodable>(api: TMDBApiManager  , indexMovieID: Int, completionHandler: @escaping (T?, YunjiError?) -> Void){

        AF.request(api.endpoint, method: api.method, parameters: api.parameter, encoding: URLEncoding(destination: .queryString), headers: api.header).responseDecodable(of:T.self ) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value, nil)
            case .failure(let error):
                completionHandler(nil, YunjiError.noResponse)
            }
        }
        
        
        
//        AF.request(api.endpoint, method: api.method, parameters: api.parameter, encoding: URLEncoding(destination: .queryString), headers: api.header).responseDecodable(of:SimilarMovieResponse.self ) { response in
//            switch response.result {
//            case .success(let value):
//                completionHandler(value.results, nil)
//            case .failure(let error):
//                completionHandler(nil, "잠시후 다시 시도해주세요")
//            }
//        }
    }
    
    
    func fetchRecommendations(api: TMDBApiManager, for indexMovieID: Int, completionHandler: @escaping typealiasHandler) {
        
        AF.request(api.endpoint, method: api.method,parameters: api.parameter, encoding: URLEncoding(destination: .queryString),headers: api.header).responseDecodable(of: RecommendMovieResponse.self ) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value.results, nil)
                
            case .failure(let error):
                completionHandler(nil, "잠시후 다시 시도해주세요")
            }
         
        }
    }
  
    
}
