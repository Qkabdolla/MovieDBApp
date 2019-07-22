//
//  ImageService.swift
//  HW3MovieDB
//
//  Created by Мадияр on 7/21/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ImageService {
    
    var cache = NSCache<NSString, UIImage>()
    
    static func loadImage( _ path: String, completion: @escaping (UIImage?) -> () ) {
        
        let urlString = "https://image.tmdb.org/t/p/original\(path)"
        
        guard let url = URL(string: urlString) else { return }
        
        Alamofire.request(url).responseImage { (response) in
            
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let value):
                print(value.localizedDescription)
            }
            
        }
        
    }
}
