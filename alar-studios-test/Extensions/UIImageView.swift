//
//  UIImageView.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 24.08.2021.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCache(withUrl urlString : String, completion: @escaping (() -> Void)) {
        let url = URL(string: urlString)
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            guard error == nil, let imageData = data, let image = UIImage(data: imageData) else {
                print("Could not load image for \(String(describing: url?.absoluteString)) because: \(String(describing: error?.localizedDescription))")
                return
            }
            
            imageCache.setObject(image, forKey: urlString as NSString)
            
            DispatchQueue.main.async {
                self.image = image
                completion()
            }
            
        })
        .resume()
    }
}
