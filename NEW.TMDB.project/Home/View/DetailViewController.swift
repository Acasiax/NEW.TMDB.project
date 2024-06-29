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
        view.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if let selectedMovieID = popularMovieModel?.id {
        
            fetchMovieData(indexMovieID: selectedMovieID)
            
        }
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func fetchMovieData(indexMovieID: Int){
        let group = DispatchGroup()
        
        group.enter() //비동기 작업의 시작
        fetchSimilarMovies(indexMovieID: indexMovieID) {
            group.leave()
        }
        
        group.enter()
        fetchRecommendations(for: indexMovieID) {
            group.leave()
        }
        
        // 모든 작업이 완료되면 알림
        group.notify(queue: .main) {
            // 모든 API 호출이 완료된 후 테이블 뷰 새로고침.
            self.tableView.reloadData()
        }
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
    
    func fetchSimilarMovies(indexMovieID: Int, completion: @escaping () -> Void){
        let similarMovieurl = APIUrl.similarMoviesUrl(for: indexMovieID)
        
        let header: HTTPHeaders = [
            "api_key": APIKey.TMDBAPIKey, "language": "ko-KR", "page": "1"
        ]
        
        AF.request(similarMovieurl, method: .get, headers: header).responseDecodable(of:SimilarMovieResponse.self ) { response in
            switch response.result {
            case .success(let value):
                self.similarMoviemodels = value.results
                print("'⚠️'")
                print("비슷한 영화 정보 가져오기 성공:", value.results)
                self.tableView.reloadData()
                // self.collectionView.reloadData()
            case .failure(let error):
                print("비슷한 영화 정보 가져오기 실패:", error)
            }
            completion() // 완료 핸들러를 호출하여 DispatchGroup에서 빠져나옵니다.
        }
        
    }
    
    private func fetchRecommendations(for indexMovieID: Int, completion: @escaping () -> Void) {
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
            completion()
        }
    }
}

// 테이블뷰 데이터 소스 및 델리게이트 관련 extension
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 // 두 개의 행을 반환 (추천 영화와 비슷한 영화)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as! HomeTableViewCell
        
        if indexPath.row == 0 {
            // 첫 번째 행일 때, 추천 영화 데이터 표시
            if let popularMovieTitle = popularMovieModel?.title {
                cell.titleLabel.text = "🍿 \(popularMovieTitle)을 좋아한다면 이 영화를 추천"
            }
            cell.collectionView.tag = 0
            cell.collectionView.dataSource = self  // 데이터 소스 설정
            cell.collectionView.delegate = self    // 델리게이트 설정
            cell.collectionView.register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
            cell.collectionView.reloadData()
        } else if indexPath.row == 1 {
            // 두 번째 행일 때, 비슷한 영화 데이터 표시
            if let popularMovieTitle = popularMovieModel?.title {
                cell.titleLabel.text = "🎥 \(popularMovieTitle)과 비슷한 영화입니다"
            }
            cell.collectionView.tag = 1
            cell.collectionView.dataSource = self  // 데이터 소스 설정
            cell.collectionView.delegate = self    // 델리게이트 설정
            cell.collectionView.register(SimilarCollectionViewCell.self, forCellWithReuseIdentifier: SimilarCollectionViewCell.identifier)
            cell.collectionView.reloadData()
        }
        
        return cell
    }
}


// 컬렉션뷰 데이터 소스 및 델리게이트 관련 extension
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            // 추천 영화 컬렉션 뷰일 때
            return recommendMoviemodels.count
        } else if collectionView.tag == 1 {
            // 비슷한 영화 컬렉션 뷰일 때
            return similarMoviemodels.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            // 추천 영화 컬렉션 뷰 셀 설정
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as! RecommendCollectionViewCell
            if let posterPath = recommendMoviemodels[indexPath.item].posterPath {
                let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
                cell.posterImageView.kf.setImage(with: imageUrl)
            }
            return cell
        } else if collectionView.tag == 1 {
            // 비슷한 영화 컬렉션 뷰 셀 설정
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarCollectionViewCell.identifier, for: indexPath) as! SimilarCollectionViewCell
            if let posterPath = similarMoviemodels[indexPath.item].posterPath {
                let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
                cell.posterImageView.kf.setImage(with: imageUrl)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}
