//
//  CSIDLabel.swift
//  CSID_App
//
//  Created by Vince Muller on 11/13/23.
//

import UIKit

class CALabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(size: CGFloat, weight: UIFont.Weight, numOfLines: Int) {
        super.init(frame: .zero)
        font                        = UIFont.systemFont(ofSize: size, weight: weight)
        numberOfLines               = numOfLines
        adjustsFontSizeToFitWidth   = true
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints   = false
        textColor                                   = .label
    }
    
    
}
