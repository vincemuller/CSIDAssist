//
//  CategoryCollectionViewCell.swift
//  CSID_App
//
//  Created by Vince Muller on 11/2/23.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let reuseID  = "cell"

    let categoryLabel       = UILabel()
    let categoryIcon        = UIImageView()
    let descriptionLabel    = UILabel()
    let separatorLine       = SeparatorLine()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        addSubview(categoryLabel)
        addSubview(categoryIcon)
        addSubview(descriptionLabel)
        addSubview(separatorLine)
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints         = false
        categoryIcon.translatesAutoresizingMaskIntoConstraints          = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints      = false
        
        categoryLabel.textAlignment         = .left
        categoryLabel.lineBreakMode         = .byWordWrapping
        categoryLabel.numberOfLines         = 2
        categoryLabel.font                  = UIFont.systemFont(ofSize: 14, weight: .bold)
        categoryLabel.textColor             = .white
        
        categoryIcon.layer.cornerRadius     = 25
        
        descriptionLabel.textAlignment      = .left
        descriptionLabel.lineBreakMode      = .byWordWrapping
        descriptionLabel.numberOfLines      = 3
        descriptionLabel.font               = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 30),
            
            categoryIcon.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryIcon.heightAnchor.constraint(equalToConstant: 50),
            categoryIcon.widthAnchor.constraint(equalToConstant: 50),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: categoryIcon.trailingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: categoryIcon.centerYAnchor),
            
            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5),
            separatorLine.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
    }
    
}
