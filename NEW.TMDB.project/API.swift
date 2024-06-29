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
    
    func fetchSimilarMovies(api: TMDBApiManager  , indexMovieID: Int, completionHandler: @escaping typealiasHandler){
     
       // let similarMovieurl = APIUrl.similarMoviesUrl(for: indexMovieID)
        
      
        
       // let header: HTTPHeaders = [
       //     "api_key": APIKey.TMDBAPIKey, "language": "ko-KR", "page": "1"
      //  ]
        
        
        
        AF.request(api.endpoint, method: api.method, parameters: api.parameter, encoding: URLEncoding(destination: .queryString), headers: api.header).responseDecodable(of:SimilarMovieResponse.self ) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value.results, nil)
            case .failure(let error):
                completionHandler(nil, "잠시후 다시 시도해주세요")
            }
        }
    }
    
    
    func fetchRecommendations(api: TMDBApiManager, for indexMovieID: Int, completionHandler: @escaping ([PopularMovie]?, String?) -> Void) {
      //  let recommendMovieurl = APIUrl.recommendationsUrl(for: indexMovieID)
        
//        let header: HTTPHeaders = [
//            "api_key": APIKey.TMDBAPIKey, "language": "ko-KR", "page": "1"
//        ]
        
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
