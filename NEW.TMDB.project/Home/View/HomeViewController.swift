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
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)")
    }
    
}


// 1. url  2.query string  3. http헤더 작성하기 4.request 5.response (response string)
// 
class HomeViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var popularMoviemodels = [PopularMovie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        fetchPopularMovies()
    }
    
    func setupCollectionView() {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: view.frame.size.width / 1 - 30, height: view.frame.size.width / 1 )
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 5

            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.id)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = .white

            view.addSubview(collectionView)
            collectionView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

    
    
    func fetchPopularMovies(){
        let popularMovieurl = APIUrl.popularMovieUrl + "&page=1"
        
        let header: HTTPHeaders = [
            "api_key": APIKey.TMDBAPIKey, "language": "ko-KR", "page": "1"
        ]
        
        AF.request(popularMovieurl, method: .get, headers: header).responseDecodable(of:PopularMovieResponse.self ) { response in
            switch response.result {
            case .success(let value):
                self.popularMoviemodels = value.results
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        
        
//        AF.request(popularMovieurl, method: .get, headers: header).responseString { response in
//            switch response.result {
//            case .success(let value):
//                print(value)
//            case .failure(let error):
//                print(error)
//            }
//            print(response)
//        }
//        
    }
   

}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularMoviemodels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
        let model = popularMoviemodels[indexPath.row]
        cell.configure(with: model)
        cell.backgroundColor = .yellow
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = popularMoviemodels[indexPath.row]
        let model = popularMoviemodels[indexPath.row]
        let detailVC = DetailViewController(model: selectedMovie)
       // let detailVC = DetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
