//
//  Model.swift
//  HW3MovieDB
//
//  Created by Мадияр on 6/28/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SwiftyJSON

class Model {
    
    var film_id: Int!
    var coverImage: String?
    var title: String!
    var description: String!
    var litleNotice: String!
    
    var runtime: Int?
    var genres: String?
    var budget: Int?
    var vote: String?
    
    init(film_id: Int, coverImage: String, title: String, litleNotice: String, description: String) {
        self.coverImage = coverImage
        self.title = title
        self.litleNotice = litleNotice
        self.description = description
        self.film_id = film_id
    }
    
    init(film_id: Int, coverImage: String, title: String, litleNotice: String, description: String, runtime: Int, genres: String, budget: Int, vote: String) {
        self.coverImage = coverImage
        self.title = title
        self.litleNotice = litleNotice
        self.description = description
        self.film_id = film_id
        self.runtime = runtime
        self.genres = genres
        self.budget = budget
        self.vote = vote
    }
    
    init(jsons: JSON) {
        self.film_id = jsons["id"].intValue
        self.title = jsons["title"].stringValue
        self.litleNotice = jsons["release_date"].stringValue
        self.description = jsons["overview"].stringValue
        self.coverImage = jsons["poster_path"].stringValue
    }
    
    init(json: JSON) {
        self.title = json["title"].stringValue
        self.coverImage = json["poster_path"].stringValue
        self.description = json["overview"].stringValue
        self.litleNotice = json["release_date"].stringValue
        self.budget = json["budget"].intValue
        self.runtime = json["runtime"].intValue
        self.vote = json["vote_average"].stringValue
        
        var genresArray: [String] = []
        if let genresData = json["genres"].array {
            for i in genresData {
                genresArray.append(i["name"].stringValue)
            }
        }
        
        self.genres = genresArray.joined(separator:", ")
    }
    
    init() {
    
    }

}

struct Review {
    var author: String
    var content: String
    
    init(json: JSON) {
        self.author = json["author"].stringValue
        self.content = json["content"].stringValue
    }
}
