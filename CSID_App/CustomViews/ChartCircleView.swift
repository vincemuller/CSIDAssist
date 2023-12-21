//
//  ChartCircleView.swift
//  CSID_App
//
//  Created by Vince Muller on 11/21/23.
//

import UIKit

class ChartCircleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(borderColor: CGColor, backgroundColor: UIColor) {
        super.init(frame: .zero)
        self.layer.borderColor  = borderColor
        self.backgroundColor    = backgroundColor
        self.layer.borderWidth  = 5
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}
