//
//  RoomControlSideTableView.swift
//  Tempus
//
//  Created by Giancarlo on 04.06.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

protocol RoomControlSideTableViewDelegate: class {
    func didSelect(_ tableView: UITableView, at indexPath: IndexPath, in view: RoomControlSideTableView)
}

class RoomControlSideTableView: UIView, UITableViewDelegate, UITableViewDataSource, Configurable {
    
    weak var delegate: RoomControlSideTableViewDelegate?
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(MembersCell.self)
        tv.tableFooterView = UIView()
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor.Temp.main
        return tv
    }()
    
    var model: [String]?
    
    var isSelected = false
    
    func configureWithModel(_ users: [String]) {
        model = users
        
        tableView.reloadData()
    }
    
    func setSelection(_ value: Bool) {
        isSelected = value
        tableView.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.Temp.main
        
        fillToSuperview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = model else { return 0 }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MembersCell.self, for: indexPath)
        guard let dataSource = model else { return cell }
        
        let member = dataSource[indexPath.row]
        
        cell.configureWithModel(member)
        cell.constraintViews(isSelected: isSelected)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow()
        
        delegate?.didSelect(tableView, at: indexPath, in: self)
    }
}

class MembersCell: BaseTableViewCell, Configurable {
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let nameLabel: Label = {
        let lbl = Label(font: .TempRegular, textAlignment: .left, textColor: .white, numberOfLines: 1)
        lbl.alpha = 0
        return lbl
    }()
    
    var model: String?
    
    func configureWithModel(_ member: String) {
        self.model = member
        
        nameLabel.text = member
        profileImageView.image = #imageLiteral(resourceName: "profile_pic")
    }
    
    
    // MARK: - Constraints
    
    var imageYAxis: NSLayoutConstraint?
    var imageXAxis: NSLayoutConstraint?
    
    func constraintViews(isSelected: Bool) {
        if isSelected {
            imageYAxis = profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            imageXAxis = profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5)
        }
        else {
            imageYAxis = profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            imageXAxis = profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        }
        
        guard
            let imageYAxis = imageYAxis,
            let imageXAxis = imageXAxis
            else { return }
        
        containerView.add(subview: profileImageView) { (v, p) in [
            imageXAxis,
            imageYAxis,
            v.widthAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.6),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.6)
            ]}
        
        if isSelected {
            containerView.add(subview: nameLabel) { (v, p) in [
                v.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5),
                v.centerYAnchor.constraint(equalTo: p.centerYAnchor)
                ]}
            
            UIView.animate(withDuration: 0.25) {
                self.nameLabel.alpha = 1
            }
        }
        else {
            UIView.animate(withDuration: 0.25) {
                self.nameLabel.alpha = 0
            }
        }
        
        layoutIfNeeded()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        
        containerView.backgroundColor = UIColor.Temp.mainDarker
        
        addView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
