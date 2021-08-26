//
//  TableviewPlaceholder.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 26.08.2021.
//

import UIKit

class PlaceholderTextView: UIView {
    
    convenience init(textPlaceholder: String, width: CGFloat = UIScreen.main.bounds.width, height: CGFloat = 100) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        let headerHeight = self.parentViewController?.topbarHeight ?? 0
        
        let label = UILabel()
        label.text = textPlaceholder
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.textAlignment = .center
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -headerHeight).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
}
