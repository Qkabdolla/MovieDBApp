//
//  ReviewCollectionViewCell.swift
//  HW3MovieDB
//
//  Created by Мадияр on 7/1/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit

class ReviewCollectionViewCell: UICollectionViewCell {
    
    lazy var authorLabel: UILabel = {
        let authorLabel = UILabel()
        
        authorLabel.textColor = .orange
        authorLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        return authorLabel
    }()
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        
        contentLabel.textColor = .white
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.numberOfLines = 10
        
        return contentLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.darkGray.cgColor
        addSubview(authorLabel)
        addSubview(contentLabel)
        
        authorLabel.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(authorLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
