//
//  HomeViewController.swift
//  NEW.TMDB.project
//
//  Created by 이윤지 on 6/25/24.
//

import UIKit
import SnapKit
import Alamofire

struct PopularMovieResponse: Decodable {
    let page: Int
    let results: [PopularMovie]
}

struct PopularMovie: Decodable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let voteAverage: Double
    let posterPath: String?
    let backdropPath: String? // 배경 이미지
    let genreIds: [Int] // 장르 ID 배열
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
    }
}


// 1. url  2.query string  3. http헤더 작성하기 4.request 5.response (response string)
// 
class HomeViewController: UIViewController {

    private var models = [PopularMovie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchMovies()
    }
    
    func fetchMovies(){
        let url = APIUrl.popularMovieUrl + "&page=1"
        
        let header: HTTPHeaders = [
            "api_key": APIKey.TMDBAPIKey, "language": "ko-KR", "page": "1"
        ]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of:PopularMovieResponse.self ) { response in
            switch response.result {
            case .success(let value):
                print(value.results)
            case .failure(let error):
                print(error)
            }
        }
        
        
//        AF.request(url, method: .get, headers: header).responseString { response in
//            switch response.result {
//            case .success(let value):
//                print(value)
//            case .failure(let error):
//                print(error)
//            }
//            print(response)
//        }
        
    }
   

}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        
        return cell
    }
    
    
    
}
