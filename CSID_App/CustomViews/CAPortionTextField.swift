//
//  NewFoodTextField.swift
//  CSID_App
//
//  Created by Vince Muller on 10/28/23.
//

import UIKit

class CAPortionTextField: UITextField {
     var textPadding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

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
        layer.borderWidth   = 2
        layer.borderColor   = UIColor.systemGray5.cgColor
        
        textColor       = .label
        tintColor       = .label
        textAlignment   = .center
        adjustsFontSizeToFitWidth = false
        font            = UIFont.systemFont(ofSize: 14)
        autocorrectionType  = .no
        keyboardType        = .numberPad

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
