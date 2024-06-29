//
//  DetailViewController.swift
//  NEW.TMDB.project
//
//  Created by 이윤지 on 6/28/24.
//

struct SimilarMovieResponse: Decodable {
        let page: Int
        let results: [PopularMovie]
        let total_pages: Int
    
}

struct RecommendMovieResponse: Decodable {
        let page: Int
        let results: [PopularMovie]
        let total_pages: Int
    
}

import UIKit
import Alamofire
import Kingfisher

class DetailViewController: UIViewController {
    
    private var popularMovieModel: PopularMovie?  // 선택한 영화 정보를 저장할 프로퍼티
    private var similarMoviemodels = [PopularMovie]()
    private var recommendMoviemodels = [PopularMovie]()
    // PopularMovie 모델을 받아 초기화하는 생성자
    convenience init(model: PopularMovie) {
        self.init()
        self.popularMovieModel = model
    }
    
    //view.delegate = self,view.dataSource = self는 먼저 인스턴스가 만들어진 후에 self가 가능해서 클로저에 넣으면 안됨 -> 그래서 lazy var 사용
    lazy var tableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.rowHeight = 200
        view.register(HomeSimilarTableViewCell.self, forCellReuseIdentifier: HomeSimilarTableViewCell.identifier)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if let selectedMovieID = popularMovieModel?.id {
            fetchSimilarMovies(indexMovieID: selectedMovieID)
            fetchRecommendations(for: selectedMovieID)
        }
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    //서브뷰
    func configureHierarchy() {
        view.addSubview(tableView)
        
    }
    
    //스냅킷
    func configureLayout(){
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //백그라운드
    
    func configureView(){
        view.backgroundColor = .gray
    }

    
}


extension DetailViewController {
    
    func fetchSimilarMovies(indexMovieID: Int){
        let similarMovieurl = APIUrl.similarMoviesUrl(for: indexMovieID)
        
        let header: HTTPHeaders = [
            "api_key": APIKey.TMDBAPIKey, "language": "ko-KR", "page": "1"
        ]
        
                AF.request(similarMovieurl, method: .get, headers: header).responseDecodable(of:SimilarMovieResponse.self ) { response in
                    switch response.result {
                    case .success(let value):
                        self.similarMoviemodels = value.results
                        print("'⚠️'")
                        print(value.results)
                        self.tableView.reloadData()
                       // self.collectionView.reloadData()
                    case .failure(let error):
                        print(error)
                    }
                }

    }
    
    private func fetchRecommendations(for indexMovieID: Int) {
        let recommendMovieurl = APIUrl.recommendationsUrl(for: indexMovieID)
        
        let header: HTTPHeaders = [
            "api_key": APIKey.TMDBAPIKey, "language": "ko-KR", "page": "1"
        ]
        
        AF.request(recommendMovieurl, method: .get, headers: header).responseDecodable(of: RecommendMovieResponse.self ) { response in
            switch response.result {
            case .success(let value):
                self.recommendMoviemodels = value.results
              //  print(value.results)
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeSimilarTableViewCell.identifier, for: indexPath) as! HomeSimilarTableViewCell
        
        
        if let popularMovieTitle = popularMovieModel?.title {
            cell.titleLabel.text = "\(popularMovieTitle)와 비슷한 영화"
        }
        cell.similarMoviemodels = similarMoviemodels
        cell.collectionView.dataSource = self
        cell.collectionView.delegate = self
        cell.collectionView.tag = indexPath.row  // 컬렉션 뷰의 태그를 설정하여 나중에 구분할 수 있도록 함
       // cell.collectionView.tag = 1
        cell.collectionView.register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
        cell.collectionView.reloadData()
        
        
        
        
        
        
        return cell
    }

    
    
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarMoviemodels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as! RecommendCollectionViewCell
        if let posterPath = similarMoviemodels[indexPath.row].posterPath {
            let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            cell.posterImageView.kf.setImage(with: imageUrl)
        }
        return cell
    }
}
