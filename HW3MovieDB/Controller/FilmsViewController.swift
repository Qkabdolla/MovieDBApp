//
//  FilmsViewController.swift
//  HW3MovieDB
//
//  Created by Мадияр on 6/28/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SnapKit
import AlamofireImage

class FilmsViewController: UIViewController {

    let tableView = UITableView()
    let viewModel = FilmsViewModel()
    let indicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        viewModel.delegate = self
        
        setupNavigationBar()
        setupTableView()
        
        indicatorView.startAnimating()
        
        viewModel.getFilms()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupNavigationBar(){
        
        navigationItem.title = "Films"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.register(FilmsCustomTableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.indicatorStyle = .white
        tableView.showsVerticalScrollIndicator = true
        tableView.isHidden = true
        tableView.backgroundColor = .black
        tableView.separatorColor = .darkGray
        
        view.addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension FilmsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FilmsCustomTableViewCell
        
        
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
            
        } else {
            let item = viewModel.getElement(at: indexPath.row)
            cell.configure(with: item)

        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.film_id = viewModel.data[indexPath.row].film_id
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension FilmsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.getFilms()
        }
    }
}

extension FilmsViewController: FilmsViewModelDelegate {
    func didUpdateData(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            indicatorView.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        // 2
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
}

private extension FilmsViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
