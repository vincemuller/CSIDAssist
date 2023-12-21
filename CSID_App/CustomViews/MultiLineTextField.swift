//
//  MultiLineTextField.swift
//  CSID_App
//
//  Created by Vince Muller on 10/29/23.
//

import UIKit

class MultiLineTextField: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor                             = .systemGray6
        translatesAutoresizingMaskIntoConstraints   = false
        layer.cornerRadius                          = 10
        isEditable                                  = true
        textContainer.lineBreakMode                 = .byWordWrapping
        font                                        = UIFont.preferredFont(forTextStyle: .body)
        textColor                                   = .label
        tintColor                                   = .label
        textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
    }
    
    
}
