//
//  TMDBApiManager.swift
//  NEW.TMDB.project
//
//  Created by 이윤지 on 6/29/24.
//

import Foundation
import Alamofire

enum TMDBApiManager {
    
    case popularMovie
    case simiarMovie(movieId: Int)
    case recommendMovie(movieId: Int)
    
    var baseURL: String {
        return "https://api.themoviedb.org/3/"
    }
    
    var endpoint: URL {
        switch self {
        case .popularMovie:
            return URL(string: baseURL + "movie/popular?api_key=\(APIKey.TMDBAPIKey)")!
        case .simiarMovie(let movieId):
            return URL(string: baseURL + "movie/\(movieId)/similar?api_key=\(APIKey.TMDBAPIKey)")!
        case .recommendMovie(let movieId):
            return URL(string: baseURL + "movie/\(movieId)/recommendations?api_key=\(APIKey.TMDBAPIKey)")!
        }
        
    }
    
    var header: HTTPHeaders {
        return ["api_key": APIKey.TMDBAPIKey]
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameter: Parameters {
        switch self {
            
        case .popularMovie:
            return ["language": "ko-KR", "page": "1"]
        case .simiarMovie(movieId: let movieId):
            return ["language": "ko-KR", "page": "1"]
        case .recommendMovie(movieId: let movieId):
            return ["language": "ko-KR", "page": "1"]
        }
    }
    
}
