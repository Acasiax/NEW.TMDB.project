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
    
    func fetchSimilarMovies(indexMovieID: Int, completionHandler: @escaping ([PopularMovie]) -> Void, errorHandler: @escaping (String) -> Void){
        
        let similarMovieurl = APIUrl.similarMoviesUrl(for: indexMovieID)
        
        let header: HTTPHeaders = [
            "api_key": APIKey.TMDBAPIKey, "language": "ko-KR", "page": "1"
        ]
        
        AF.request(similarMovieurl, method: .get, headers: header).responseDecodable(of:SimilarMovieResponse.self ) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value.results)
            case .failure(let error):
                errorHandler(error.localizedDescription)
            }
        }
    }
    
    
   func fetchRecommendations(for indexMovieID: Int, completionHandler: @escaping ([PopularMovie]) -> Void, errorHandler: @escaping (String) -> Void) {
        let recommendMovieurl = APIUrl.recommendationsUrl(for: indexMovieID)
        
        let header: HTTPHeaders = [
            "api_key": APIKey.TMDBAPIKey, "language": "ko-KR", "page": "1"
        ]
        
        AF.request(recommendMovieurl, method: .get, headers: header).responseDecodable(of: RecommendMovieResponse.self ) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value.results)
                
            case .failure(let error):
                errorHandler(error.localizedDescription)
            }
         
        }
    }
    
    
    
    
    
    
}
