//
//  ResultCell.swift
//  Tempus
//
//  Created by Giancarlo on 31.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {
    
    let horizontalView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Temp.accent
        return view
    }()
    
    let containerView = UIView()
    
    let questionLabel = Label(font: .TempSemiBold, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let countLabel = Label(font: .TempSemiBold, textAlignment: .left, textColor: .white, numberOfLines: 1)
    
    var model: Int?
    
    func configureWithModel(_ count: Int, maxCount: Int) {
        self.model = count
        
        let tempCount = Float(count)
        let tempMaxCount = Float(maxCount)
        let percentage = tempCount / tempMaxCount
        
        countLabel.text = "\(count)"

        horizontalViewWidthConstraint = horizontalView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: CGFloat(percentage))
        
        addViews()
    }
    
    func setQuestion(_ question: String) {
        
        questionLabel.text = question
    }
    
    func setWinner() {
        
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.Temp.accent.cgColor
    }
    
    var horizontalViewWidthConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        containerView.backgroundColor = UIColor.Temp.mainDarker
        
    }
    
    func addViews() {

        add(subview: containerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 1),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 3),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -3),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -1)
            ]}
        
        containerView.add(subview: questionLabel) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor, constant: -10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 10)
            ]}
        
        guard let horizontalViewWidthConstraint = horizontalViewWidthConstraint else { return }
        
        containerView.add(subview: horizontalView) { (v, p) in [
            v.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 10),
            v.heightAnchor.constraint(equalToConstant: 10),
            horizontalViewWidthConstraint
            ]}
        
        containerView.add(subview: countLabel) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: horizontalView.topAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -10)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

