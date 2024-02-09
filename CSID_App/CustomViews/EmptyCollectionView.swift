//
//  EmptyCollectionView.swift
//  CSID_App
//
//  Created by Vince Muller on 2/9/24.
//

import UIKit

class EmptyCollectionView: UIView {
    let emptyMessageLabel = CALabel(size: 20, weight: .medium, numOfLines: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String) {
        super.init(frame: .zero)
        emptyMessageLabel.text = text
        
        configure()
    }
    
    func configure() {
        addSubview(emptyMessageLabel)
        
        emptyMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyMessageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emptyMessageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
            emptyMessageLabel.heightAnchor.constraint(equalToConstant: 30),
            emptyMessageLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
        
    }
}
