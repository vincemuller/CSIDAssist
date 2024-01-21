//
//  CategoriesCollectionViewCell.swift
//  CSID_App
//
//  Created by Vince Muller on 1/20/24.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    static let reuseID  = "category cell"

    let categoryLabel       = UILabel()
    let categoryIcon        = UIImageView()
    
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
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints         = false
        categoryIcon.translatesAutoresizingMaskIntoConstraints          = false
        
        categoryLabel.textAlignment         = .center
        categoryLabel.lineBreakMode         = .byWordWrapping
        categoryLabel.numberOfLines         = 2
        categoryLabel.font                  = UIFont.systemFont(ofSize: 16, weight: .bold)
        categoryLabel.textColor             = .white
        
        categoryIcon.layer.cornerRadius     = 25
        layer.cornerRadius                  = 10

        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 40),
            
            categoryIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            categoryIcon.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -15),
            categoryIcon.heightAnchor.constraint(equalToConstant: 60),
            categoryIcon.widthAnchor.constraint(equalToConstant: 60),
            
        ])
        
    }
    
}
