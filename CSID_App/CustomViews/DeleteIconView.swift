//
//  DeleteIconView.swift
//  CSID_App
//
//  Created by Vince Muller on 3/12/24.
//

import UIKit

class DeleteIconView: UIImageView {
    
    var config                  = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 22))
    var addNewSymbol: UIImage?
    let tapGesture              = UITapGestureRecognizer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {

        addNewSymbol = UIImage(systemName: "trash", withConfiguration: config)
        image        = addNewSymbol
        tintColor    = .systemRed
        
        tapGesture.isEnabled            = true
        tapGesture.numberOfTapsRequired = 1

        translatesAutoresizingMaskIntoConstraints = false
        
        isUserInteractionEnabled    = true
        addGestureRecognizer(tapGesture)
        
    }
}
