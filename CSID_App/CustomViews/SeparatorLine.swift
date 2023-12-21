//
//  SeparatorLine.swift
//  CSID_App
//
//  Created by Vince Muller on 11/20/23.
//

import UIKit

class SeparatorLine: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .label
        
    }
}
