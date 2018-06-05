//
//  CodeViewController.swift
//  Tempus
//
//  Created by Giancarlo on 27.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class CodeViewController: BaseViewController {
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Temp.mainDarker
        view.alpha = 1
        return view
    }()
    
    let codeInputTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "Code")
        tf.backgroundColor = .clear
        tf.layer.cornerRadius = 0
        return tf
    }()
    
    lazy var enterButton: TempusButton = {
        let btn = TempusButton(title: "Enter", titleColor: .white, backgroundColor: UIColor.Temp.accent, font: .TempRegular)
        btn.addTarget(self, action: #selector(enterButtonTapped), for: .touchUpInside)
        btn.layer.cornerRadius = 0
        return btn
    }()
    
    lazy var submitButton: TempusButton = {
        let btn = TempusButton(title: "Submit Pick", titleColor: .white, backgroundColor: UIColor.Temp.accent, font: .TempRegular)
        btn.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
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
        tv.alpha = 0
        tv.bounces = true
        return tv
    }()
    
    let enterRoomStepImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "enterroom_step_icon")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var bottomSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            pickLabel,
            submitButton
            ])
        sv.axis = .vertical
        sv.alpha = 0
        sv.distribution = .equalSpacing
        return sv
    }()
    
    let waitingLabel: Label = {
        let lbl = Label(font: UIFont.TempRegular, textAlignment: .center, textColor: .white, numberOfLines: 1)
        lbl.alpha = 0
        return lbl
    }()
    
    let stepLabel = Label(font: .TempRegular, textAlignment: .center, textColor: .white, numberOfLines: 1)
    let stateLabel = Label(font: .TempTitle, textAlignment: .center, textColor: .white, numberOfLines: 1)
    let titleLabel = Label(font: .TempTitle, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let dateLabel = Label(font: .TempRegular, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let pickLabel = Label(font: .TempTitle, textAlignment: .center, textColor: .white, numberOfLines: 1)
    let codeLabel = Label(font: UIFont.TempSemiBold.withSize(25), textAlignment: .center, textColor: .white, numberOfLines: 1)
    
    var voteSum = 0
    var selectedIndex = 0

    var keyboardShown = false
    var submitButtonSelected = false
    var pickedButtonSelected = false
    var showResults = false
    
    var questions = [String]()
    var votes = [Int]()

    var code: String?
    
    var bottomHeightConstraint: NSLayoutConstraint?
    var codeTextFieldYAxisConstraint: NSLayoutConstraint?
    var enterButtonYAxisConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomHeightConstraint = bottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
        enterButtonYAxisConstraint = enterButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
        codeTextFieldYAxisConstraint = codeInputTextField.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
        
        guard let bottomHeightConstraint = bottomHeightConstraint, let codeTextFieldYAxisConstraint = codeTextFieldYAxisConstraint, let enterButtonYAxisConstraint = enterButtonYAxisConstraint else { return }
        
        let topContainerView = UIView()
        
        view.add(subview: topContainerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.4)
            ]}
        
        topContainerView.add(subview: self.iconImageView) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor, constant: -25),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.heightAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.7),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.7)
            ]}
        
        stepLabel.text = "Enter room code to continue"
        
        view.add(subview: enterRoomStepImageView) { (v, p) in [
            v.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 40),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -40),
            v.heightAnchor.constraint(equalTo: topContainerView.heightAnchor, multiplier: 0.2)
            ]}
        
        view.add(subview: stepLabel) { (v, p) in [
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.topAnchor.constraint(equalTo: enterRoomStepImageView.bottomAnchor, constant: 10)
            ]}
        
        view.add(subview: bottomView) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            bottomHeightConstraint
            ]}
        
        bottomView.add(subview: enterButton) { (v, p) in [
            enterButtonYAxisConstraint,
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -50),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.3)
            ]}
        
        bottomView.add(subview: codeInputTextField) { (v, p) in [
            codeTextFieldYAxisConstraint,
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 50),
            v.trailingAnchor.constraint(equalTo: enterButton.leadingAnchor),
            v.heightAnchor.constraint(equalTo: enterButton.heightAnchor)
            ]}
        
        bottomView.add(subview: stateLabel, createConstraints: { (v, p) in [
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor)
            ]})
        
        bottomView.add(subview: bottomSV) { (v, p) in [
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.75),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.75)
            ]}
        
        view.add(subview: titleLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25)
            ]}
        
        view.add(subview: dateLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25)
            ]}
        
        view.add(subview: tableView, createConstraints: { (v, p) in [
            v.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 5),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -5),
            v.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant: -10)
            ]})
        
        titleLabel.alpha = 0
        dateLabel.alpha = 0
        stateLabel.alpha = 0
        pickLabel.alpha = 0
        
        pickLabel.text = "Choose Your Answer"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if let bottomHeightConstraint = bottomHeightConstraint, let enterButtonYAxisConstraint = enterButtonYAxisConstraint, let codeTextFieldYAxisConstraint = codeTextFieldYAxisConstraint {
                bottomHeightConstraint.constant = bottomHeightConstraint.constant + keyboardSize.height
                codeTextFieldYAxisConstraint.constant = -keyboardSize.height / 2
                enterButtonYAxisConstraint.constant = -keyboardSize.height / 2
                view.layoutIfNeeded()
                
                keyboardShown = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if let bottomHeightConstraint = bottomHeightConstraint, let enterButtonYAxisConstraint = enterButtonYAxisConstraint, let codeTextFieldYAxisConstraint = codeTextFieldYAxisConstraint {
                if !submitButtonSelected {
                    bottomHeightConstraint.constant = bottomHeightConstraint.constant - keyboardSize.height
                    codeTextFieldYAxisConstraint.constant = 0
                    enterButtonYAxisConstraint.constant = 0
                    view.layoutIfNeeded()
                    
                    keyboardShown = false
                }
            }
        }
    }
    
    func winnerIndex() -> Int {
        let closest = votes.enumerated().min( by: { abs($0.1 - voteSum) < abs($1.1 - voteSum) } )!
        return closest.offset
    }
    
    @objc func dismissKeyboardOnTap() {
        codeInputTextField.resignFirstResponder()
    }
    
    @objc func submitButtonTapped() {
        // Set to true to avoid updating bottom view on listener
        self.pickedButtonSelected = true
        
        guard let code = code else { return }
        
        updateVote(index: selectedIndex, votes: votes, code: code) { (err) in
            if let err = err {
                print(err)
            }
            else {
    
                self.tableView.isUserInteractionEnabled = false
                
                self.waitingLabel.text = "Waiting for results..."
                
                let sv = UIStackView(arrangedSubviews: [
                    self.customActivityIndicator,
                    self.waitingLabel
                    ])
                sv.axis = .vertical
                sv.alpha = 0
                sv.distribution = .fillEqually
                
                self.bottomView.add(subview: sv) { (v, p) in [
                    v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
                    v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
                    v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.75),
                    v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.75)
                    ]}
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.bottomSV.alpha = 0
                    
                    self.waitingLabel.alpha = 1
                    sv.alpha = 1
                })
                
                self.customActivityIndicator.startAnimating()
                
                for index in 0 ... self.questions.count {
                    guard let indexCell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? PollCell else { return }
                    indexCell.showAlpha(false)
                }
            }
        }
    }
    
    func updateVote(index: Int, votes: [Int], code: String, completion: @escaping (Error?) -> Void ) {
        var newArray = [Int]()
        
        for i in 0 ... votes.count - 1 {
            if i == index {
                newArray.append(votes[i] + 1)
            }
            else {
                newArray.append(votes[i])
            }
        }
        
        FirebaseManager.shared.updateVote(votes: newArray, code: code) { (err) in
            if let err = err {
                completion(err)
            }
            else {
                completion(nil)
            }
        }
    }
    
    @objc func enterButtonTapped() {
        submitButtonSelected = true
        
        if keyboardShown {
            codeInputTextField.resignFirstResponder()
        }
        else {
            if let bottomHeightConstraint = bottomHeightConstraint {
                UIView.animate(withDuration: 0.25) {
                    bottomHeightConstraint.constant = bottomHeightConstraint.constant + 150
                    self.view.layoutIfNeeded()
                }
            }
        }
        
        UIView.animate(withDuration: 0.25) {
            self.enterButton.alpha = 0
            self.codeInputTextField.alpha = 0
        }
        
        if !view.subviews.contains(customActivityIndicator) {
            bottomView.add(subview: customActivityIndicator) { (v, p) in [
                v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
                v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
                v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.1),
                v.heightAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.1)
                ]}
        }

        guard let codeText = codeInputTextField.text else { return }
        
        code = codeText
        
        FirebaseManager.shared.joinRoom(name: "Gino", code: codeText) { (err) in
            if let err = err {
                print(err)
            }
            else {
                FirebaseManager.shared.addRoomListener(code: codeText, completion: { (err, room, votes) in
                    if let err = err {
                        print(err)
                    }
                    else {
                        
                        if let bottomHeightConstraint = self.bottomHeightConstraint, let room = room, let votes = votes {
                            UIView.animate(withDuration: 0.25, animations: {
                                
                                self.voteSum = votes.data.reduce(0) { $0 + $1 }
                                
                                if self.bottomView.subviews.contains(self.customActivityIndicator) && !self.pickedButtonSelected {
                                    self.customActivityIndicator.stopAnimating()
                                    self.customActivityIndicator.removeFromSuperview()
                                    bottomHeightConstraint.constant = 0
                                    self.view.layoutIfNeeded()
                                }
                                
                                switch room.state {
                                case RoomState.open.text:
                                    
                                    guard !self.pickedButtonSelected else {
                                        self.questions = room.questions
                                        self.votes = votes.data
                                        self.tableView.reloadData()
                                        return
                                    }
                                    
                                    if self.view.subviews.contains(self.tableView) {
                                        UIView.animate(withDuration: 0.25, animations: {
                                            self.tableView.alpha = 0
                                        })
                                    }
                                    
                                    if self.iconImageView.alpha == 0 {
                                        UIView.animate(withDuration: 0.25, animations: {
                                            self.iconImageView.alpha = 1
                                        })
                                    }
                                    
                                    
                                    if !self.view.subviews.contains(self.customActivityIndicator) {
                                        
                                        self.view.add(subview: self.customActivityIndicator) { (v, p) in [
                                            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
                                            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
                                            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.1),
                                            v.heightAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.1)
                                            ]}
                                        
                                        self.customActivityIndicator.startAnimating()
                                    }
                                    
                                    if !self.view.subviews.contains(self.waitingLabel) {
                                        self.view.add(subview: self.waitingLabel, createConstraints: { (v, p) in [
                                            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
                                            v.topAnchor.constraint(equalTo: self.customActivityIndicator.bottomAnchor, constant: 10)
                                            ]})
                                    }
                                    
                                    UIView.animate(withDuration: 0.25, animations: {
                                        
                                        // Dissappear
                                        self.enterRoomStepImageView.alpha = 0
                                        self.stepLabel.alpha = 0
                                        
                                        // Appear
                                        self.stateLabel.alpha = 1
                                        self.waitingLabel.alpha = 1
                                    })
                                    
                                    
                                    self.waitingLabel.text = "Waiting for poll to start..."
                                    self.stateLabel.text = "Poll has not started yet"
                                    
                                case RoomState.closed.text:
                           
                                    UIView.animate(withDuration: 0.25, animations: {
                                        self.waitingLabel.alpha = 0
                                    })
                                    
                                    self.showResults = true
                                    self.customActivityIndicator.stopAnimating()
                                    self.tableView.reloadData()
                                    
                                case RoomState.started.text:
                                    
                                    guard !self.pickedButtonSelected else {
                                        self.questions = room.questions
                                        self.votes = votes.data
                                        self.tableView.reloadData()
                                        return
                                    }
                                    
                                    self.customActivityIndicator.removeFromSuperview()
                                    
                                    self.questions = room.questions
                                    self.votes = votes.data
                                    
                                    UIView.animate(withDuration: 0.25, animations: {
                                        // BUTTON ALPHA
                                        self.waitingLabel.alpha = 0
                                        self.enterRoomStepImageView.alpha = 0
                                        self.iconImageView.alpha = 0
                                        self.stateLabel.alpha = 0
                                        self.stepLabel.alpha = 0
                                        
                                        self.tableView.alpha = 1
                                        self.titleLabel.alpha = 1
                                        self.dateLabel.alpha = 1
                                        self.pickLabel.alpha = 1
                                        self.bottomSV.alpha = 1
                                    })
                                    
                                    // test data
                                    self.titleLabel.text = room.title
                                    self.dateLabel.text = "by \(room.creator) . 30 May 2018"
                                    
                                    UIView.animate(withDuration: 0.25, animations: {
                                        self.tableView.alpha = 1
                                    })
                                    
                                    self.tableView.reloadData()

                                default:
                                    break;
                                }
                            })
                        }
                    }
                })
            }
        }
    }
}

extension CodeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let question = questions[indexPath.row]
        let vote = votes[indexPath.row]
        
        if showResults {
            let cell = tableView.dequeueReusableCell(ResultCell.self, for: indexPath)
            
            if indexPath.row == winnerIndex() {
                cell.setWinner()
            }
            
            cell.configureWithModel(vote, maxCount: voteSum)
            cell.setQuestion(question)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(PollCell.self, for: indexPath)
            
            cell.configureWithModel(question)
            cell.setVote(vote: vote)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow()
        
        if !showResults {
            let question = questions[indexPath.row]
            pickLabel.text = "Your pick: \(question)"
            
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
    }
}
