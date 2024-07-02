//
//  NasaViewController.swift
//  NEW.TMDB.project
//
//  Created by 이윤지 on 7/1/24.
//

import UIKit
import SnapKit

// 컴파일 최적화
final class NasaViewController: BaseViewcontroller {

    private enum Nasa: String, CaseIterable {
        
        static let baseURL = "https://apod.nasa.gov/apod/image/"
        
        case one = "2308/sombrero_spitzer_3000.jpg"
        case two = "2212/NGC1365-CDK24-CDK17.jpg"
        case three = "2307/M64Hubble.jpg"
        case four = "2306/BeyondEarth_Unknown_3000.jpg"
        case five = "2307/NGC6559_Block_1311.jpg"
        case six = "2304/OlympusMons_MarsExpress_6000.jpg"
        case seven = "2305/pia23122c-16.jpg"
        case eight = "2308/SunMonster_Wenz_960.jpg"
        case nine = "2307/AldrinVisor_Apollo11_4096.jpg"
         
        static var photo: URL {
            return URL(string: Nasa.baseURL + Nasa.allCases.randomElement()!.rawValue)!
        }
    }
    
    private let nasaImageView = UIImageView()
    private let progressLabel = UILabel()
    private let requestButton = UIButton()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private var total: Double = 0 // 이미지의 총 크기
    private var buffer: Data? {
        didSet {
            let result = Double(buffer?.count ?? 0) / total
            progressLabel.text = "\(result * 100) / 100"
        }
    }
  //  - 피식코딩 스터디
    //화면 전환을 했거나, 앱을 종료하거나 등 뷰가 사라지는 시점에 네트워크와 관련된 리소스 정리가 필요
    //앱이 전환하면 다운받고 있던 것을 중지할거냐 계속할거냐도 설정해줘야함 (카톡 이미지도 이런식) -> 카톡에서 이미지도 많이 다운받고 있는데, 다른 톡방에 푸쉬 알림이 오면, 다운로드 중인걸 일시정지할지 아니면 계속 다운받을지
    //
    
    private var session: URLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     //   - 피식코딩 스터디
        //화면이 사라진다면 네트워크 통신도 바로 함께 중단 -> 이런 경우는 백그라운드 설정해주기 위해 나중에 타겟에서 캡페벌리티?에 들어가서 따로 별로 설정해줘야 한다.
        //다운로드 중인 리소스도 무시 -> invalidateAndCancel()
        session?.invalidateAndCancel()
        
        //다운로드가 완료될 때까지 기다렸다가, 다운로드가 완료되면 리소스 정리(나중에 데이터 무효화?)
        session?.finishTasksAndInvalidate()
    }
    
    private func callRequest() {
        let request = URLRequest(url: Nasa.photo)
        session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        session?.dataTask(with: request).resume()
    }
    
    @objc private func requestButtonClicked() {
        buffer = Data() //Data 타입의 변수를 정의하고, 동시에 해당 변수에 Data의 기본 생성자를 사용하여 초기값을 할당하는 것
        requestButton.isEnabled = false
        activityIndicator.startAnimating()
        callRequest()
    }
    
    override func configureHierarchy() {
        view.addSubview(nasaImageView)
        view.addSubview(progressLabel)
        view.addSubview(requestButton)
        view.addSubview(activityIndicator)
    }

    override func configureLayout() {
        requestButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        progressLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(requestButton.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        nasaImageView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(progressLabel.snp.bottom).offset(20)
        }
        
        activityIndicator.snp.makeConstraints { make in
                make.center.equalTo(view)
            }
    }
    
    override func configureView() {
        view.backgroundColor = .white
        requestButton.backgroundColor = .blue
        progressLabel.backgroundColor = .lightGray
        progressLabel.text = "0% 완료"
        nasaImageView.backgroundColor = .systemBrown
        requestButton.addTarget(self, action: #selector(requestButtonClicked), for: .touchUpInside)
    }
}

extension NasaViewController: URLSessionDataDelegate {
    
    // 1. 서버에서 최초로 응답 받는 경우에 호출. (ex. 상태코드)
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
        print(#function, response)
        
        if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
            
            //총 데이터의 양 얻기
            let contentLength = response.value(forHTTPHeaderField: "Content-Length")!
            total = Double(contentLength)!
            return .allow
        } else {
            return .cancel
        }
    }
    
    // 2. 서버에서 데이터를 받아올 때마다 반복적으로 호출됨
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print(#function, data)
        buffer?.append(data) //🕵🏻‍♂️추가될때 데이터가 자동연산 되는이유
        progressLabel.text = "\(total) 중 \(buffer)"
    }
    
    // 3. 응답이 완료가 될 때 호출됨.
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        print(#function, error)
        activityIndicator.stopAnimating()
        requestButton.isEnabled = true
        
        if let error = error {
            progressLabel.text = "문제가 발생했습니다."
        } else {
            print("성공") //completionHadler 시점과 동일
            guard let buffer = buffer else {
                print("Buffer nil")
                return
            }
            let image = UIImage(data: buffer)
            nasaImageView.image = image
        }
    }
}

/*
 
 피식코딩 스터디
 
 화면 전환 시 네트워크 통신 처리
 네트워크 통신 중단

 앱의 특정 화면이 사용자에게 더 이상 보이지 않을 때(예: 다른 화면으로 전환되거나, 앱이 백그라운드로 전환될 때), 네트워크 통신을 중단하거나 관리해야 할 필요가 있습니다.
 네트워크 요청을 중단하지 않으면 불필요한 데이터 사용이나 리소스 낭비가 발생할 수 있습니다.
 백그라운드 설정

 백그라운드 설정을 통해 앱이 백그라운드로 전환되었을 때도 특정 작업(예: 네트워크 통신)을 계속 수행할 수 있습니다.
 iOS에서 앱이 백그라운드에서도 네트워크 작업을 계속 수행할 수 있도록 하기 위해서는 Xcode에서 해당 설정을 활성화해야 합니다.
 Xcode에서 백그라운드 설정하기
 타겟 설정

 Xcode에서 프로젝트의 타겟을 선택합니다.
 Capabilities 탭으로 이동합니다.
 Background Modes 활성화

 Background Modes 스위치를 켭니다.
 체크박스 중 Background fetch와 Remote notifications를 선택합니다. 이 설정은 앱이 백그라운드 상태에서도 네트워크 요청을 처리할 수 있도록 합니다.
 
 

 💡면접 질문: URLSession에서 해결한 어려웠던 문제에 대해 설명해 주세요.

 답변:
 최근에 이미지 다운로드 중 네트워크 불안정으로 인한 문제를 해결했습니다. URLSession의 delegate를 활용하여 다운로드 진행률을 표시하고, 중단 시 재개 기능을 구현하여 사용자 경험을 최적화하기 위해,  invalidateAndCancel()과 finishTasksAndInvalidate() 메서드를 사용하여 불필요한 데이터 사용을 방지하려고 했던 경험이 있습니다.
 (추가설명: invalidateAndCancel()으로 현재 진행 중인 모든 네트워크 요청을 즉시 취소하고,
 finishTasksAndInvalidate()을 사용하여 현재 진행 중인 네트워크 요청이 완료될 때까지 기다린 후 세션을 무효화하였습니다)
 
 
 💡면접 질문: 그렇다면 앱이 꺼지거나 화면 이동할 때 작업은 어떻게 하였나요? 그냥 데이터가 중지되게 해둔 건가요?!

 답변:
 면접관님 말씀처럼, 그 부분에 대해 저도 개발자로서 많은 고민을 했습니다. 제 경험에 따르면, 앱이 백그라운드에서도 네트워크 작업을 계속 수행할 수 있도록 설정했습니다. 이를 위해 Xcode의 타겟 설정에서 Background Modes를 활성화했습니다. 이렇게 함으로써 앱이 백그라운드 상태에서도 네트워크 요청을 계속 처리할 수 있게 했습니다. 이와 같은 방식으로 사용자에게 끊김 없는 경험을 제공하고자 노력했습니다.
 */
