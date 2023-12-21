//
//  CardCollectionViewCell.swift
//  CSID_App
//
//  Created by Vince Muller on 11/13/23.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    static let reuseID  = "cardCell"

    let cardLabel       = UILabel()
    let cardDescription = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        addSubview(cardLabel)
        addSubview(cardDescription)
        
        self.layer.cornerRadius     = 10
        self.layer.shadowOpacity    = 0.5
        self.layer.shadowOffset     = CGSize(width: 0.0, height: -4.0)
        self.layer.shadowRadius     = 3
        
        cardLabel.font                              = UIFont.systemFont(ofSize: 16, weight: .bold)
        cardDescription.font                        = UIFont.systemFont(ofSize: 12, weight: .regular)
        cardLabel.textColor                         = .white
        cardDescription.textColor                   = .white
        cardDescription.backgroundColor             = .clear
        cardDescription.isEditable                  = false
        cardDescription.textContainer.lineBreakMode = .byWordWrapping
    
        cardLabel.translatesAutoresizingMaskIntoConstraints             = false
        cardDescription.translatesAutoresizingMaskIntoConstraints       = false
        
        NSLayoutConstraint.activate([
            cardLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            cardLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            cardDescription.topAnchor.constraint(equalTo: cardLabel.bottomAnchor, constant: 10),
            cardDescription.leadingAnchor.constraint(equalTo: cardLabel.leadingAnchor),
            cardDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            cardDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
        ])
        
    }
}
