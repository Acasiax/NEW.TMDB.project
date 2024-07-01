//
//  BaseViewcontroller.swift
//  SesacNetworkURLSessionGCD24.06.24
//
//  Created by 이윤지 on 6/25/24.
//

import UIKit


class BaseViewcontroller: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Base", #function)
        view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    
    
    //서브뷰
    func configureHierarchy() {
        print("Base", #function)
        
    }
    
    //스냅킷
    func configureLayout(){
        print("Base", #function)
    }
    
    //백그라운드
    func configureView(){
        print("Base", #function)
        view.backgroundColor = .lightText
    }
    
}
