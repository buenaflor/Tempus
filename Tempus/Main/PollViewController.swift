//
//  PollViewController.swift
//  Tempus
//
//  Created by Giancarlo on 27.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class PollViewController: BaseViewController, Configurable, UITableViewDelegate, UITableViewDataSource {
    
    var model: String?
    
    func configureWithModel(_ code: String) {
        self.model = code
        
        FirebaseManager.shared.addRoomListener(code: "7380D") { (err, room, votes) in
            if let err = err {
                print("error:", err)
            }
            else {
                guard let room = room, let votes = votes else { return }
                self.creatorLabel.text = "Room Creator: \(room.creator)"
                
                self.votes = votes.data
                self.questions = room.questions
                
                switch room.state {
                case RoomState.open.text:
                    self.stateLabel.text = "Poll has not started yet"
                    self.resultsLabel.text = "Waiting for poll to start"
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.resultsLabel.alpha = 1
                        self.submitVoteButton.alpha = 0
                    })
                case RoomState.closed.text:
                    self.stateLabel.text = "Poll is closed"
                    self.resultsLabel.text = "Poll is closed"
                    
                    let resultsVC = ResultsViewController()
                    self.navigationController?.pushViewController(resultsVC, animated: true)
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.resultsLabel.alpha = 1
                        self.submitVoteButton.alpha = 0
                    })
                case RoomState.started.text:
                    self.stateLabel.text = "You are now able to vote"
                    
                    UIView.animate(withDuration: 0.25, animations: {
                        self.submitVoteButton.alpha = 1
                        self.resultsLabel.alpha = 0
                    })
                    
                default:
                    break;
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    var selectedIndex = 0
    
    var questions = [String]()
    var votes = [Int]()
    
    let creatorLabel = Label(font: .TempRegular, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let stateLabel = Label(font: .TempRegular, textAlignment: .left, textColor: .white, numberOfLines: 1)
    
    let resultsLabel: Label = {
        let lbl = Label(font: .TempRegular, textAlignment: .center, textColor: .white, numberOfLines: 1)
        lbl.alpha = 0
        return lbl
    }()
    
    lazy var submitVoteButton: TempusButton = {
        let btn = TempusButton(title: "Submit", titleColor: .white, backgroundColor: UIColor.Temp.mainDarker, font: .TempRegular)
        btn.addTarget(self, action: #selector(submitVoteTapped), for: .touchUpInside)
        btn.alpha = 0
        return btn
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(PollCell.self)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.add(subview: creatorLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 40)
            ]}
        
        view.add(subview: stateLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: creatorLabel.bottomAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 40)
            ]}
        
        view.add(subview: submitVoteButton) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 40),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -40)
            ]}
        
        view.add(subview: resultsLabel) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor)
            ]}
        
        view.add(subview: tableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.bottomAnchor.constraint(equalTo: submitVoteButton.topAnchor, constant: -20)
            ]}
    }
    
    @objc func submitVoteTapped() {

        updateVote(index: selectedIndex, votes: votes) { (err) in
            if let err = err {
                print(err)
            }
            else {
                self.tableView.isUserInteractionEnabled = false
                
                self.stateLabel.text = "You have chosen: \(self.questions[self.selectedIndex])"
                self.resultsLabel.text = "Waiting for results..."
                
                UIView.animate(withDuration: 0.25) {
                    self.submitVoteButton.alpha = 0
                    self.resultsLabel.alpha = 1
                }
                
                for index in 0 ... self.questions.count {
                    guard let indexCell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? PollCell else { return }
                    indexCell.showAlpha(false)
                }
            }
        }
    }
    
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
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow()
        
        selectedIndex = indexPath.row
        
        for index in 0 ... questions.count {
            if index != indexPath.row {
                guard let indexCell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? PollCell else { return }
                indexCell.showAlpha(true)
            } else {
                guard let indexCell = tableView.cellForRow(at: indexPath) as? PollCell else { return }
                indexCell.showAlpha(false)
            }
        }
    }
    
    func updateVote(index: Int, votes: [Int], completion: @escaping (Error?) -> Void ) {
        var newArray = [Int]()
        
        for i in 0 ... votes.count - 1 {
            if i == index {
                newArray.append(votes[i] + 1)
            }
            else {
                newArray.append(votes[i])
            }
        }
        
        FirebaseManager.shared.updateVote(votes: newArray, code: "") { (err) in
            if let err = err {
                completion(err)
            }
            else {
                completion(nil)
            }
        }
    }
}
