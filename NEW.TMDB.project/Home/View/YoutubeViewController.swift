//
//  YoutubeViewController.swift
//  NEW.TMDB.project
//
//  Created by 이윤지 on 7/3/24.
//

import UIKit
import WebKit
import Alamofire

class YoutubeViewController: UIViewController, WKNavigationDelegate {
    
    var videoKey: String?
    var movieId: Int?
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        if let movieId = movieId {
            fetchVideoKey(movieId: movieId)
        }
    }
    
    private func setupWebView() {
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        self.view.addSubview(webView)
    }
    
    private func fetchVideoKey(movieId: Int) {
        fetchSimilarMovies(api: .video(movieId: movieId)) { (response: VideoResponse?, error) in
            if let error = error {
                print("비디오 데이터를 가져오는데 오류: \(error)")
                return
            }
            if let response = response,
               let firstVideo = response.results.first {
                self.videoKey = firstVideo.key
                self.loadYoutubeVideo()
            }
        }
    }
    
    func fetchSimilarMovies<T: Decodable>(api: TMDBApiManager, completionHandler: @escaping (T?, YunjiError?) -> Void) {
        AF.request(api.endpoint, method: api.method, parameters: api.parameter, encoding: URLEncoding(destination: .queryString), headers: api.header).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value, nil)
            case .failure:
                completionHandler(nil, YunjiError.networkError)
            }
        }
    }
    
    func loadYoutubeVideo() {
        guard let key = videoKey else { return }
        let urlString = "https://www.youtube.com/watch?v=\(key)"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
