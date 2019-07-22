//
//  ReviewViewController.swift
//  HW3MovieDB
//
//  Created by Мадияр on 7/1/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
    
    let viewModel = ReviewViewModel()
    var film_id: Int!
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
    
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        collectionView.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        viewModel.delegate = self
        
        setupCollectionView()
        setupNavigationController()
        
        indicatorView.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getReviews(id: film_id)
    }
    
    func setupNavigationController() {
        navigationItem.title = "Reviews"
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        view.addSubview(indicatorView)
  
        collectionView.isHidden = true
        
        indicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}

extension ReviewViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfElements()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ReviewCollectionViewCell
        
        let review = viewModel.getElement(at: indexPath.row)
        cell.authorLabel.text = review.author
        cell.contentLabel.text = review.content
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 180, height: 220)
    }
    
}

extension ReviewViewController: ReviewViewModelDelegate {
    func didUpdateData() {
        indicatorView.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
    }
}
