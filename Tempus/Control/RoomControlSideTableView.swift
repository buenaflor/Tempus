//
//  RoomControlSideTableView.swift
//  Tempus
//
//  Created by Giancarlo on 04.06.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class RoomControlSideTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self)
        tv.tableFooterView = UIView()
        tv.separatorStyle = .none
        return tv
    }()
    
    private var dataSource: Any? {
        didSet {
            guard let dataSource = dataSource as? [String] else { return }
            
        }
    }
    
    init(dataSource: Any) {
        super.init(frame: .zero)
        
        self.dataSource = dataSource
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource as? [String] else { return 0 }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
        guard let dataSource = dataSource as? [String] else { return cell }
        
        cell.textLabel?.text = dataSource[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
