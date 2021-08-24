//
//  SubtitleTableViewCell.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {
    
    static let Identifier = "SubtitleTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ location: Location, completion: @escaping (() -> Void)) {
        textLabel?.text = location.name
        detailTextLabel?.text = location.country
        imageView?.loadImageUsingCache(withUrl: location.url ?? "", completion: completion)
    }
}
