//
//  RecommendCollectionViewCell.swift
//  NEW.TMDB.project
//
//  Created by 이윤지 on 6/28/24.
//

import UIKit
import SnapKit

class RecommendCollectionViewCell: UICollectionViewCell {
    let posterImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        posterImageView.backgroundColor = .systemMint
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.clipsToBounds = true // 이미지가 프레임을 넘어가지 않도록 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("에러")
    }
}



import UIKit

class SimilarCollectionViewCell: UICollectionViewCell {
    let posterImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        posterImageView.backgroundColor = .systemMint
        posterImageView.contentMode = .scaleAspectFit 
        posterImageView.clipsToBounds = true // 이미지가 프레임을 넘어가지 않도록 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("에러")
    }
}
