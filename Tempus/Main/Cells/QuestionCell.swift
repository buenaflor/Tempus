//
//  QuestionCell.swift
//  Tempus
//
//  Created by Giancarlo on 01.06.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class QuestionCell: BaseTableViewCell, Configurable {
    
    var model: String?
    
    let questionLabel = Label(font: .TempRegular, textAlignment: .left, textColor: .white, numberOfLines: 1)
    
    func configureWithModel(_ question: String) {
        self.model = question
        
        questionLabel.text = question
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        containerView.backgroundColor = UIColor.Temp.mainDarker
        
        addView()
        
        containerView.add(subview: questionLabel) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 10)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
