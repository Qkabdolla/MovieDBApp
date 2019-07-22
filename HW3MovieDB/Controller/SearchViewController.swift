//
//  SearchViewController.swift
//  HW3MovieDB
//
//  Created by Мадияр on 6/28/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        view.backgroundColor = .white
    }
    
    func setupNavigationBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search"
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.orange]
    }

}
