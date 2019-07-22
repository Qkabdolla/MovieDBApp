//
//  DetailViewModel.swift
//  HW3MovieDB
//
//  Created by Мадияр on 6/29/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol DetailViewModelDelegate: class {
    func didUpdateData()
    func loadVideo()
}

class DetailViewModel {
    
    weak var delegate: DetailViewModelDelegate?
    var film: Model!
    var video: String!
    
    func getFilm(id: Int) {
        
        let apiKey = "452b55a66ebeb225142b8a78ad0384bc"
        let url = "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)&language=en-US"
        
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.parsing(json: json)
            case .failure(let value):
                print(value)
            }
        }

    }
    
    func parsing(json: JSON) {
        film = Model(json: json)
        delegate?.didUpdateData()
    }
    
    func getVideo(id: Int) {
        let apiKey = "452b55a66ebeb225142b8a78ad0384bc"
        let url = "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=\(apiKey)&language=en-US"
        
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let videos = json["results"].array {
                    guard !videos.isEmpty else { return }
                    let item = videos[0]
                    self.video = item["key"].stringValue
                    self.delegate?.loadVideo()
                }
            case .failure(let value):
                print(value)
            }
        }
    }

}
