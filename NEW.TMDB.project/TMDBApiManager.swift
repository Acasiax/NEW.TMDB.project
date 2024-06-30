//
//  TMDBApiManager.swift
//  NEW.TMDB.project
//
//  Created by 이윤지 on 6/29/24.
//

import Foundation
import Alamofire

enum YunjiError: Int, Error {
    case invalidURL = 1001
    case noResponse = 1002
    case decodingFailed = 1003
    case networkError = 1004
    case unknownError = 1005

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .noResponse:
            return "서버로부터 응답이 없습니다."
        case .decodingFailed:
            return "응답을 디코딩하는 데 실패했습니다."
        case .networkError:
            return "네트워크 오류가 발생했습니다."
        case .unknownError:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}


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

