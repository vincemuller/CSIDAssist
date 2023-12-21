//
//  NewFoodTextField.swift
//  CSID_App
//
//  Created by Vince Muller on 10/28/23.
//

import UIKit

class NewFoodTextField: UITextField {
     var textPadding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTextField() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius  = 10
        
        textColor       = .label
        tintColor       = .label
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        backgroundColor     = .systemGray6
        autocorrectionType  = .no

    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
