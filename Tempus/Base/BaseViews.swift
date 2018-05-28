//
//  BaseViews.swift
//  Tempus
//
//  Created by Giancarlo on 23.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class Label: UILabel {
    
    init() {
        super.init(frame: .zero)
    }
    
    init(font: UIFont, textAlignment: NSTextAlignment, textColor: UIColor, numberOfLines: Int, breakMode: NSLineBreakMode? = nil) {
        super.init(frame: .zero)
        self.font = font
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.isUserInteractionEnabled = false
        if let breakMode = breakMode { self.lineBreakMode = breakMode }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class InputTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    
    init(placeHolder: String?=nil) {
        super.init(frame: CGRect.zero)
        
        font = UIFont.TempRegular
        returnKeyType = .next
        backgroundColor = .white
        
        attributedPlaceholder = NSAttributedString(string: placeHolder ?? "", attributes: [NSAttributedStringKey.font : UIFont.TempRegular, NSAttributedStringKey.foregroundColor: UIColor.white])
        
        autocorrectionType = .no
        autocapitalizationType = .none
        enablesReturnKeyAutomatically = true
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 4.0
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: 45)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TempusButton: UIButton {
    
    init(title: String, titleColor: UIColor, backgroundColor: UIColor, font: UIFont) {
        super.init(frame: .zero)
        
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.075).isActive = true
        self.layer.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

