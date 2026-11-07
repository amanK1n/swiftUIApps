//
//  LazyImgView.swift
//  SatApi
//
//  Created by comviva on 07/11/26.
//

import Foundation
import UIKit

class LazyImgView: UIImageView {
    
    let imageCache = NSCache<AnyObject, UIImage>()
    
    func loadImage(imageURL: URL, placeholder: String) {
        self.image = UIImage(systemName: placeholder)
        
        if let image = self.imageCache.object(forKey: imageURL as AnyObject) {
            debugPrint("Loaded from Cache!! ---> \(imageURL)")
            self.image = image
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: imageURL) {
                debugPrint("Downloaded!! Image--->> \(imageURL)")
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.imageCache.setObject(image, forKey: imageURL as AnyObject)
                        self?.image = image
                    }
                }
            }
        }
    }
}
