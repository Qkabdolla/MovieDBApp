//
//  DetailViewController.swift
//  HW3MovieDB
//
//  Created by Мадияр on 6/29/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import AlamofireImage

class DetailViewController: UIViewController {
    
    let cashData = FilmsViewModel()
    let viewModel = DetailViewModel()
    var coverImageView: UIImageView!
    var film_id: Int!
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var webView: UIWebView = {
        let view = UIWebView()
        
        return view
    }()
    
    lazy var coverImage: UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    var titleLabel: UILabel = {
        let view = UILabel()
        
        return view
    }()
    
    lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        
        return view
    }()
    
    lazy var releaseDateLabel: UILabel = {
        let view = UILabel()

        
        return view
    }()
    
    lazy var budjetLabel: UILabel = {
        let view = UILabel()

        
        return view
    }()
    
    lazy var genresLabel: UILabel = {
        let view = UILabel()

        
        return view
    }()
    
    lazy var runtimeLabel: UILabel = {
        let view = UILabel()

        
        return view
    }()
    
    lazy var voteLabel: UILabel = {
        let view = UILabel()
        
        return view
    }()
    
    lazy var reviewButton: UIButton = {
        let view = UIButton()
        
        view.backgroundColor = .black
        view.layer.cornerRadius = 10
        view.setTitle("Reviews", for: .normal)
        view.setTitleColor(.orange, for: .normal)
        view.addTarget(self, action: #selector(DetailViewController.reviewButtonPressed(_:)), for: .touchUpInside)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        webView.delegate = self
        
        setupView()
        setupNavigationController()
        SVProgressHUD.show()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reviewButton.isEnabled = false
        viewModel.getFilm(id: film_id)
        viewModel.getVideo(id: film_id)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    func setupNavigationController() {
    
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupView() {
        let heightImage: CGFloat = 200
        let widthImage: CGFloat = 130
        
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        addSubviews([coverImage, titleLabel, descriptionLabel, releaseDateLabel, budjetLabel, genresLabel, runtimeLabel, voteLabel, reviewButton, webView])
        
        coverImage.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(20)
            make.height.equalTo(heightImage)
            make.width.equalTo(widthImage)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(coverImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(coverImage.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.lessThanOrEqualTo(webView.snp.top).offset(-20)
        }
        
        releaseDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(coverImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        budjetLabel.snp.makeConstraints { (make) in
            make.top.equalTo(releaseDateLabel.snp.bottom)
            make.leading.equalTo(coverImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        genresLabel.snp.makeConstraints { (make) in
            make.top.equalTo(budjetLabel.snp.bottom)
            make.leading.equalTo(coverImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        runtimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(genresLabel.snp.bottom)
            make.leading.equalTo(coverImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        voteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(runtimeLabel.snp.bottom)
            make.leading.equalTo(coverImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        reviewButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(50)
        }
        
        webView.snp.makeConstraints { (make) in
            make.bottom.equalTo(reviewButton.snp.top).offset(-10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(240)
        }
        
    }
    
    func addSubviews(_ view: [UIView]) {
        for i in view {
            contentView.addSubview(i)
        }
    }
    
    @objc func reviewButtonPressed(_ sender: UIButton!) {
        let vc = ReviewViewController()
        vc.film_id = film_id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadVideo(videoCode: String) {
        let url = URL(string: "https://www.youtube.com/embed/\(videoCode)")
        webView.loadRequest(URLRequest(url: url!))
        
    }

}

extension DetailViewController: DetailViewModelDelegate {
    func didUpdateData() {
        let film = viewModel.film
        navigationItem.title = film?.title
        
        
        titleLabel.text = film?.title
        descriptionLabel.text = film?.description
        releaseDateLabel.text = film?.litleNotice
        budjetLabel.text = film?.budget?.description
        genresLabel.text = film?.genres
        runtimeLabel.text = film?.runtime?.description
        voteLabel.text = film?.vote
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/original\(film?.coverImage ?? "")") else { return }
        print(url)
        coverImage.af_setImage(withURL: url)
    }
    
    func loadVideo() {
        loadVideo(videoCode: viewModel.video)
    }
}

extension DetailViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        reviewButton.isEnabled = true
        SVProgressHUD.dismiss()
    }
}
