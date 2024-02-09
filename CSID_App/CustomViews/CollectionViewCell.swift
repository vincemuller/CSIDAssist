//
//  CategoryCollectionViewCell.swift
//  CSID_App
//
//  Created by Vince Muller on 11/2/23.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let reuseID  = "cell"

    let categoryIcon        = UIView()
    let image               = UIImageView()
    
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
        addSubview(categoryIcon)
        categoryIcon.addSubview(image)
        addSubview(descriptionLabel)
        addSubview(separatorLine)
        
        categoryIcon.translatesAutoresizingMaskIntoConstraints          = false
        image.translatesAutoresizingMaskIntoConstraints                 = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints      = false
        
        categoryIcon.layer.cornerRadius     = 25
        
        descriptionLabel.textAlignment      = .left
        descriptionLabel.lineBreakMode      = .byWordWrapping
        descriptionLabel.numberOfLines      = 3
        descriptionLabel.font               = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        NSLayoutConstraint.activate([
            
            categoryIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            categoryIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryIcon.heightAnchor.constraint(equalToConstant: 50),
            categoryIcon.widthAnchor.constraint(equalToConstant: 50),
            
            image.centerXAnchor.constraint(equalTo: categoryIcon.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: categoryIcon.centerYAnchor),
            image.widthAnchor.constraint(equalToConstant: 30),
            image.heightAnchor.constraint(equalToConstant: 30),
            
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
