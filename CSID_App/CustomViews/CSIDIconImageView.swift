//
//  IconImageView.swift
//  CSID_App
//
//  Created by Vince Muller on 10/10/23.
//

import UIKit

class IconImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(iconName: String) {
        super.init(frame: .zero)
        let config        = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 25))
        let searchIcon    = UIImage(systemName: iconName, withConfiguration: config)
        self.image      = searchIcon
        configure()
    }
    
    func configure() {
        self.tintColor  = UIColor.systemGray
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
