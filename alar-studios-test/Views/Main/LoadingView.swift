//
//  LoadingView.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 24.08.2021.
//

import UIKit

class LoadingView: UIView {
    
    convenience init(width: CGFloat = UIScreen.main.bounds.width, height: CGFloat = 100) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        let indicator = UIActivityIndicatorView(style: .large)
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicator.color = .darkGray
        indicator.startAnimating()
    }
}
