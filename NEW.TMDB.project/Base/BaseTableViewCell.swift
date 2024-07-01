//
//  BaseTableViewCell.swift
//  SesacNetworkURLSessionGCD24.06.24
//
//  Created by 이윤지 on 6/25/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    
    //서브뷰
    func configureHierarchy() {
    
    }
    
    //스냅킷
    func configureLayout(){
        print("Base", #function)
    }
    
    //백그라운드
    func configureView(){
        print("Base", #function)
        //view.backgroundColor = .lightText
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
}
