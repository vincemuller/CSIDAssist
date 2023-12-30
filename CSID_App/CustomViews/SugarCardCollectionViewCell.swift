//
//  SugarCardCollectionViewCell.swift
//  CSID_App
//
//  Created by Vince Muller on 12/30/23.
//

import UIKit

class SugarCardCollectionViewCell: UICollectionViewCell {
    static let reuseID  = "sugarCardCell"

    let cardLabel       = UILabel()
    let sucroseLabel    = UILabel()
    let sucroseIngr     = UITextView()
    let otherLabel      = UILabel()
    let otherIngr       = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        addSubview(cardLabel)
        addSubview(sucroseLabel)
        addSubview(sucroseIngr)
        addSubview(otherLabel)
        addSubview(otherIngr)
        
        self.layer.cornerRadius     = 10
        self.layer.shadowOpacity    = 0.5
        self.layer.shadowOffset     = CGSize(width: 0.0, height: -4.0)
        self.layer.shadowRadius     = 3
        
        cardLabel.font                              = UIFont.systemFont(ofSize: 16, weight: .bold)
        sucroseLabel.font                           = UIFont.systemFont(ofSize: 15, weight: .semibold)
        otherLabel.font                             = UIFont.systemFont(ofSize: 15, weight: .semibold)
        sucroseIngr.font                            = UIFont.systemFont(ofSize: 14, weight: .regular)
        otherIngr.font                              = UIFont.systemFont(ofSize: 14, weight: .regular)
        cardLabel.textColor                         = .white
        sucroseLabel.textColor                      = .white
        otherLabel.textColor                        = .white
        sucroseIngr.textColor                       = .white
        sucroseIngr.backgroundColor                 = .clear
        sucroseIngr.isEditable                      = false
        sucroseIngr.textContainer.lineBreakMode     = .byWordWrapping
        otherIngr.textColor                         = .white
        otherIngr.backgroundColor                   = .clear
        otherIngr.isEditable                        = false
        otherIngr.textContainer.lineBreakMode       = .byWordWrapping
    
        cardLabel.translatesAutoresizingMaskIntoConstraints             = false
        sucroseLabel.translatesAutoresizingMaskIntoConstraints          = false
        sucroseIngr.translatesAutoresizingMaskIntoConstraints           = false
        otherLabel.translatesAutoresizingMaskIntoConstraints            = false
        otherIngr.translatesAutoresizingMaskIntoConstraints             = false
        
        sucroseLabel.text = "Sucrose detected in:"
        otherLabel.text   = "Other sugars detected in:"
        
        NSLayoutConstraint.activate([
            cardLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            cardLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            
            sucroseLabel.topAnchor.constraint(equalTo: cardLabel.bottomAnchor, constant: 10),
            sucroseLabel.leadingAnchor.constraint(equalTo: cardLabel.leadingAnchor, constant: 5),
            sucroseLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            
            sucroseIngr.topAnchor.constraint(equalTo: sucroseLabel.bottomAnchor),
            sucroseIngr.leadingAnchor.constraint(equalTo: sucroseLabel.leadingAnchor, constant: 5),
            sucroseIngr.trailingAnchor.constraint(equalTo: sucroseLabel.trailingAnchor),
            sucroseIngr.heightAnchor.constraint(equalToConstant: 45),
            
            otherLabel.topAnchor.constraint(equalTo: sucroseIngr.bottomAnchor, constant: 5),
            otherLabel.leadingAnchor.constraint(equalTo: sucroseLabel.leadingAnchor),
            otherLabel.trailingAnchor.constraint(equalTo: sucroseLabel.trailingAnchor),
            
            otherIngr.topAnchor.constraint(equalTo: otherLabel.bottomAnchor),
            otherIngr.leadingAnchor.constraint(equalTo: sucroseIngr.leadingAnchor),
            otherIngr.trailingAnchor.constraint(equalTo: sucroseIngr.trailingAnchor),
            otherIngr.heightAnchor.constraint(equalToConstant: 45)
        ])
        
    }
}
