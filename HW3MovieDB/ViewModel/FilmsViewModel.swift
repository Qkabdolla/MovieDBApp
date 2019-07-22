//
//  FilmsViewModel.swift
//  HW3MovieDB
//
//  Created by Мадияр on 6/28/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

protocol FilmsViewModelDelegate: class {
    func didUpdateData(with newIndexPathsToReload: [IndexPath]?)
}

class FilmsViewModel {
    
    weak var delegate: FilmsViewModelDelegate?
    var data: [Model] = []
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return data.count
    }
    
    func getElement(at row: Int) -> Model {
        return data[row]
    }
    
    func getFilms() {
        getFilmsWithParam(with: currentPage)
    }
    
    private func calculateIndexPathsToReload() -> [IndexPath] {
        let startIndex = data.count - 20
        let endIndex = startIndex + 20
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    func getFilmsWithParam(with page: Int) {
        
        guard !isFetchInProgress else { return }
        
        isFetchInProgress = true
        
        let apiKey = "452b55a66ebeb225142b8a78ad0384bc"
        let url = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&page=\(page)"
        
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    self.updateTableView(json: json)
                case .failure(let value):
                    self.isFetchInProgress = false
                    print(value)
            }
        }
    
    }
    
    func updateTableView(json: JSON) {
        
        self.currentPage += 1
        self.isFetchInProgress = false
        
        if let datas = json["results"].array {
            
            total = json["total_results"].intValue
        
            for item in datas {
                data.append(Model(jsons: item))
            }
            
            if json["page"].intValue > 1 {
                let indexPathsToReload = self.calculateIndexPathsToReload()
                self.delegate?.didUpdateData(with: indexPathsToReload)
            } else {
                self.delegate?.didUpdateData(with: .none)
            }
            
        }
    }
    
    func getImage(path: String) -> UIImageView? {
        
        let myImage = UIImageView()
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/original\(path)") else { return nil }
        
        Alamofire.request(url).responseImage { (response) in
            if let image = response.result.value {
                myImage.image = image
            }
        }
        
        return myImage
        
    }
    
}
