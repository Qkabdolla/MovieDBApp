//
//  ReviewViewModel.swift
//  HW3MovieDB
//
//  Created by Мадияр on 7/1/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol ReviewViewModelDelegate: class {
    func didUpdateData()
}

class ReviewViewModel {
    
    weak var delegate: ReviewViewModelDelegate?
    var reviews: [Review] = []
    
    func getReviews(id: Int) {
        
        let apiKey = "452b55a66ebeb225142b8a78ad0384bc"
        let url = "https://api.themoviedb.org/3/movie/\(id)/reviews?api_key=\(apiKey)&language=en-US&page=1"
        
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let array = json["results"].array {
                    self.reviews = array.map { Review(json: $0) }
                    self.delegate?.didUpdateData()
                }
            case .failure(let value):
                print(value)
            }
        }
    }
    
    func numberOfElements() -> Int {
        return reviews.count
    }
    
    func getElement(at row: Int) -> Review {
        return reviews[row]
    }
    
}
