//
//  FilmsCustomTableViewCell.swift
//  HW3MovieDB
//
//  Created by Мадияр on 6/28/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit
import AlamofireImage

class FilmsCustomTableViewCell: UITableViewCell {
    
    let heightImage: CGFloat = 200
    let widthImage: CGFloat = 130
    
    lazy var coverImage: CustomImageView = {
        let coverImage = CustomImageView()
        
        
        return coverImage
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.textColor = .orange
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        return titleLabel
    }()
    
    lazy var litleNoticeLabel: UILabel = {
        let litleNoticeLabel = UILabel()
        
        litleNoticeLabel.textColor = .white
        litleNoticeLabel.font = UIFont.systemFont(ofSize: 16)
        
        return litleNoticeLabel
    }()
    
    lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        
        descriptionLabel.numberOfLines = 6
        descriptionLabel.textColor = .gray
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        
        return descriptionLabel
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        configure(with: .none)
    }
    
    func configure(with film: Model?) {
        if let film = film {
            titleLabel.text = film.title
            litleNoticeLabel.text = film.litleNotice
            descriptionLabel.text = film.description
            titleLabel.alpha = 1
            litleNoticeLabel.alpha = 1
            descriptionLabel.alpha = 1
            
            indicatorView.stopAnimating()
            
            guard let url = film.coverImage else { return }
//            
//            ImageService.loadImage(url) { [ weak self ] (image) in
//                guard let cover = image else { return }
//                self?.coverImage.image = cover
//            }
            
            
//            getImage(path: film.coverImage ?? "")
            
//            coverImage.loadImageUsingUrlString(film.coverImage ?? "")
            
        } else {
            titleLabel.alpha = 0
            litleNoticeLabel.alpha = 0
            descriptionLabel.alpha = 0
            indicatorView.startAnimating()

        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews([coverImage, titleLabel, litleNoticeLabel, descriptionLabel, indicatorView])
        self.backgroundColor = .black
        indicatorView.hidesWhenStopped = true
        
        indicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        coverImage.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(heightImage)
            make.width.equalTo(widthImage)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.leading.equalTo(coverImage.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(litleNoticeLabel.snp.top).offset(-10)
        }
        
        litleNoticeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(coverImage.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-10)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(coverImage.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
    }
    
    func getImage(path: String) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/original\(path)") else { return }
        coverImage.image = nil
        
        coverImage.af_setImage(withURL: url)

        
    }
    
    func addSubviews(_ view: [UIView]) {
        for i in view {
            addSubview(i)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(_ path: String) {
        
        let urlString = "https://image.tmdb.org/t/p/original\(path)"
        
        imageUrlString = urlString
        
        guard let url = URL(string: urlString) else { return }
        
        image = nil
        
        if let imageFormCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFormCache
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil,
                let imageToCache = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
 
                imageCache.setObject(imageToCache, forKey: urlString as NSString)
            }
            
        }
        
        task.resume()
    }
}
