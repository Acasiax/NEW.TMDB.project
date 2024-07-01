//
//  BaseView.swift
//  SesacNetworkURLSessionGCD24.06.24
//
//  Created by 이윤지 on 6/25/24.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    //서브뷰
    func configureHierarchy() {     
    }
    
    //스냅킷
    func configureLayout(){
        
    }
    
    //백그라운드
func configureView(){
       
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
}
