//
//  NewFoodLabel.swift
//  CSID_App
//
//  Created by Vince Muller on 10/28/23.
//

import UIKit

class NewFoodLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(text: String) {
        super.init(frame: .zero)
        
        self.text = text
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }

}
