//
//  RoomControlViewController.swift
//  Tempus
//
//  Created by Giancarlo on 01.06.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class RoomControlViewController: BaseViewController {
    
    let titleLabel = Label(font: .TempTitle, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let dateLabel = Label(font: .TempRegular, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let nameLabel = Label(font: .TempRegular, textAlignment: .left, textColor: .white, numberOfLines: 1)
    
    var questions = [String]()
    var votes = [Int]()
    
    var code: String?
    var roomState: RoomState?
    
    var bottomHeightConstraint: NSLayoutConstraint?
    
    
    // MARK: - Views
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Temp.mainDarker
        view.alpha = 1
        return view
    }()
    
    lazy var startButton: TempusButton = {
        let btn = TempusButton(title: "Start Poll", titleColor: .white, backgroundColor: UIColor.Temp.accent, font: .TempRegular)
        btn.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        btn.layer.cornerRadius = 0
        return btn
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(PollCell.self)
        tv.register(ResultCell.self)
        tv.tableFooterView = UIView()
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor.Temp.main
        tv.bounces = true
        return tv
    }()

    init(title: String, name: String, date: String, code: String) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title
        self.nameLabel.text = "Created by \(name)"
        self.dateLabel.text = date
        
        self.loadListener(code: code)
        
        // Save code in case creator wants to leave
        self.code = code
    }
    
    func loadListener(code: String) {
        FirebaseManager.shared.addRoomListener(code: code) { (err, room, votes) in
            guard let room = room, let votes = votes else {
                print(err!)
                return
            }
            
            self.questions = room.questions
            self.votes = votes.data
            
            switch room.state {
            case RoomState.open.text:
                self.roomState = .open
                print("it is open")
                
            case RoomState.started.text:
                self.roomState = .started
                
                self.startButton.setTitle("End Poll", for: .normal)
                print("it is started")
                
            case RoomState.closed.text:
                self.roomState = .closed
                
                print("it is closed")
            default:
                break;
            }
            
            self.tableView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backarrow").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(onBackTapped))
        backButton.tintColor = .white
        
        navigationItem.leftBarButtonItem = backButton
        
        bottomHeightConstraint = bottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
        
        guard let bottomHeightConstraint = bottomHeightConstraint else { return }
        
        view.add(subview: titleLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25)
            ]}
        
        view.add(subview: nameLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25)
            ]}
        
        view.add(subview: dateLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            v.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10)
            ]}
        
        view.add(subview: bottomView) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            bottomHeightConstraint
            ]}
        
        bottomView.add(subview: startButton) { (v, p) in [
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.7)
            ]}

        view.add(subview: tableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 5),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -5),
            v.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -10)
            ]}
    }
    
    @objc func onBackTapped() {
        self.alert(title: "Warning", message: "Leaving the room will close it immediately. Proceed?", cancelable: true) { (_) in
            // Close room
            
            guard let code = self.code else { return }
            
            FirebaseManager.shared.removeRoom(code: code, completion: { (err) in
                if let err = err {
                    print(err)
                }
                else {
                    print("Deleted Room: \(code)")
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    @objc func startButtonTapped() {
        guard let code = code, let roomState = roomState else { return }
        
        switch roomState {
        case .open:
            FirebaseManager.shared.updateState(state: RoomState.started.text, code: code) { (err) in
                if let err = err {
                    self.alert(error: err)
                }
            }
        case .started:
            FirebaseManager.shared.updateState(state: RoomState.closed.text, code: code) { (err) in
                if let err = err {
                    self.alert(error: err)
                }
            }
        default:
            break;
        }
    }
}

extension RoomControlViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(PollCell.self, for: indexPath)
        let question = questions[indexPath.row]
        let vote = votes[indexPath.row]
        
        cell.configureWithModel(question)
        cell.setVote(vote: vote)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
