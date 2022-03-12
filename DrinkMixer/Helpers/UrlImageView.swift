//
//  UrlImageView.swift
//  DrinkMixer
//
//  Created by Jing Li on 1/22/22.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class UrlImageView: UIImageView {
    var imageUrlString: String?
    
    func loadImageFromUrlString(urlString: String) {
        image = nil
        
        // image in cache
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            image = cachedImage
            return
        }
        
        
        // image not in cache
        imageUrlString = urlString
        
        Networking.loadThumbnailImageFromURLString(urlString: urlString) { loadedImage in
            imageCache.setObject(loadedImage, forKey: NSString(string: urlString))

            DispatchQueue.main.async {
                if self.imageUrlString == urlString {
                    self.image = loadedImage
                }
            }
        }
    }
}

