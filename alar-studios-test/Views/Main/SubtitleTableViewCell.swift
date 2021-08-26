//
//  SubtitleTableViewCell.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {
    
    static let Identifier = "SubtitleTableViewCell"
    
    private lazy var title: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var subtitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightGray
        lbl.font = UIFont.systemFont(ofSize: 12)
        return lbl
    }()
    private lazy var cityImageView: CachebleImageView = CachebleImageView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        addSubview(cityImageView)
        cityImageView.translatesAutoresizingMaskIntoConstraints = false
        cityImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        cityImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        cityImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        cityImageView.widthAnchor.constraint(equalTo: cityImageView.heightAnchor, constant: 0).isActive = true
        

        let stackView = UIStackView(arrangedSubviews: [title, subtitle])
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        stackView.axis = .vertical
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        stackView.leftAnchor.constraint(equalTo: cityImageView.rightAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ location: Location, completion: @escaping (() -> Void)) {
        title.text = location.name
        subtitle.text = location.country
        cityImageView.loadImageUsingCache(withUrl: location.url ?? "")
    }
}
