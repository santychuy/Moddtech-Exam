//
//  ImageService.swift
//  Moddtech-Exam
//
//  Created by Jesus Santiago Carrasco Campa on 8/22/19.
//  Copyright © 2019 Techson. All rights reserved.
//

import UIKit
import Foundation

class ImageService {
    static let cache = NSCache<NSString, UIImage>()
    
    static func downloadImg(withURL url:URL, completion: @escaping (_ image:UIImage?) -> ()) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, responseURL, error) in
            var downloadedImg:UIImage?
            
            if let data = data{
                downloadedImg = UIImage(data: data)
            }
            
            if downloadedImg != nil{
                cache.setObject(downloadedImg!, forKey: url.absoluteString as NSString)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImg)
            }
        }
        
        dataTask.resume()
        
    }
    
    static func getImg(withURL url:URL, completion: @escaping (_ image:UIImage?) -> ()) {
        if let img = cache.object(forKey: url.absoluteString as NSString){
            completion(img)
        }else{
            downloadImg(withURL: url, completion: completion)
        }
    }
    
}
