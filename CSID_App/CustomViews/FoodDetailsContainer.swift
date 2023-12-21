//
//  FoodDetailsContainer.swift
//  CSID_App
//
//  Created by Vince Muller on 11/13/23.
//

import UIKit

class FoodDetailsContainer: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor     = .systemGray5
        layer.cornerRadius  = 10
    }
}
