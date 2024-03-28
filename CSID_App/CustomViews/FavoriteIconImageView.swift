//
//  FavoriteIconImageView.swift
//  CSID_App
//
//  Created by Vince Muller on 3/22/24.
//

import UIKit

class FavoriteIconImageView: UIImageView {

    private var config          = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 22))
    private var addNewSymbol: UIImage?
    let tapGesture              = UITapGestureRecognizer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        translatesAutoresizingMaskIntoConstraints = false
        tintColor                   = .systemGreen
        isUserInteractionEnabled    = true
        
        tapGesture.isEnabled            = true
        tapGesture.numberOfTapsRequired = 1

    }
    
    func updateFavs(favIconEnabled: Bool) {
        switch favIconEnabled {
        case true:
            addNewSymbol        = UIImage(systemName: "star.fill", withConfiguration: config)
            image               = addNewSymbol
        case false:
            addNewSymbol        = UIImage(systemName: "star", withConfiguration: config)
            image               = addNewSymbol
        }

    }
}
