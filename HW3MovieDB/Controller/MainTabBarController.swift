//
//  MainTabBarViewController.swift
//  HW3MovieDB
//
//  Created by Мадияр on 6/28/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        tabBar.barTintColor = .black
        
    }
    
    func setupTabBar() {
        
        let filmsController = createNavController(vc: FilmsViewController(), selected: UIImage(named: "films_active")!, unselected: UIImage(named: "films_unactive")!)
        let searchController = createNavController(vc: SearchViewController(), selected: UIImage(named: "search_active")!, unselected: UIImage(named: "search_unactive")!)
        
        viewControllers = [filmsController, searchController]
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        }
    }
}

extension MainTabBarController {
    func createNavController(vc: UIViewController, selected: UIImage, unselected: UIImage) -> UINavigationController {
        let viewController = vc
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselected
        navController.tabBarItem.selectedImage = selected
        
        return navController
    }
}
