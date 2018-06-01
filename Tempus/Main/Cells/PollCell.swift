//
//  PollCell.swift
//  Tempus
//
//  Created by Giancarlo on 31.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class PollCell: UITableViewCell, Configurable {
    
    var model: String?
    
    func configureWithModel(_ question: String) {
        self.model = question
        
        questionLabel.text = question
    }
    
    func setVote(vote: Int) {
        voteCountLabel.text = "\(vote)"
    }
    
    let questionLabel = Label(font: .TempRegular, textAlignment: .left, textColor: .white, numberOfLines: 1)
    
    let voteCountLabel: Label = {
        let lbl = Label(font: .TempRegular, textAlignment: .center, textColor: .white, numberOfLines: 1)
        lbl.backgroundColor = UIColor.Temp.accent
        lbl.layer.cornerRadius = 2
        return lbl
    }()
    
    let coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = .gray
        coverView.alpha = 0
        return coverView
    }()
    
    let containerView = UIView()
    
    func disableAlpha() {
        self.coverView.alpha = 0
    }
    
    func showAlpha(_ value: Bool) {
        if value {
            UIView.animate(withDuration: 0.25) {
                self.coverView.alpha = 0.35
            }
        }
        else {
            UIView.animate(withDuration: 0.25) {
                self.coverView.alpha = 0
                self.containerView.layer.masksToBounds = true
                self.containerView.layer.shadowColor = UIColor.black.cgColor
                self.containerView.layer.shadowOffset = CGSize(width: -1, height: 1)
                self.containerView.layer.shadowRadius = 1
                
                self.containerView.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
                self.containerView.layer.shouldRasterize = true
                self.containerView.layer.rasterizationScale = UIScreen.main.scale
                
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = .clear
        
        containerView.backgroundColor = UIColor.Temp.mainDarker
        
        add(subview: containerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 1),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 3),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -3),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -1)
            ]}
        
        containerView.add(subview: voteCountLabel) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 10),
            v.widthAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.6),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.6)
            ]}
        
        containerView.add(subview: questionLabel) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: voteCountLabel.trailingAnchor, constant: 20)
            ]}
        
        containerView.fillToSuperview(coverView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
