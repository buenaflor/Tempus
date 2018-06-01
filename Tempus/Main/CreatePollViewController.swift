//
//  CreatePollViewController.swift
//  Tempus
//
//  Created by Giancarlo on 27.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import FirebaseAuth

enum Creator {
    case loggedInUser
    case guest
}

enum RoomState {
    case open
    case started
    case closed
}

extension RoomState {
    
    var text: String {
        switch self {
        case .open:
            return "Open"
        case .started:
            return "Started"
        case .closed:
            return "Closed"
        }
    }
}

class CreatePollViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "logo").withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
        return iv
    }()
    
    let infoLabel = Label(font: UIFont.TempRegular, textAlignment: .center, textColor: .white, numberOfLines: 1)
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.Temp.main
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self)
        tv.tableFooterView = UIView()
        return tv
    }()
    
    lazy var addButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "plus_icon"), for: .normal)
        btn.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var createRoomButton: TempusButton = {
        let btn = TempusButton(title: "Create Room", titleColor: .white, backgroundColor: UIColor.Temp.mainDarker, font: UIFont.TempRegular)
        btn.addTarget(self, action: #selector(createRoomButtonTapped), for: .touchUpInside)
        return btn
    }()

    lazy var pollTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "")
        tf.attributedPlaceholder = NSAttributedString.String("Enter a poll question", font: .TempRegular, color: UIColor.lightGray)
        tf.delegate = self
        tf.backgroundColor = .clear
        tf.layer.borderColor = UIColor.clear.cgColor
        tf.tintColor = .white
        return tf
    }()
    
    var questions = [String]()
    var creator: Creator?
    
    init(creator: Creator) {
        super.init(nibName: nil, bundle: nil)
        self.creator = creator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Temp.main
        
        infoLabel.text = "Create your poll questions"
        
        view.add(subview: logoImageView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.1)
            ]}
        
        view.add(subview: infoLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 40)
            ]}
        
        view.add(subview: addButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -40),
            v.heightAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.1),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.1)
            ]}
        
        view.add(subview: pollTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 40),
            v.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -10),
            v.heightAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.1)
            ]}
        
        pollTextField.addSeparatorLine(color: .lightGray)
        
        view.add(subview: tableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: pollTextField.bottomAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 40),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -40),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor, constant: -40)
            ]}
        
        view.add(subview: createRoomButton) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 40),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -40)
            ]}
    }
    
    @objc func createRoomButtonTapped() {
        
        guard let creator = creator else { return }
        
        let uuid = UUID().uuidString
        let code = String(uuid.prefix(5))
        
        if creator == .guest {
            
            // States: Open, Started, Closed
            let room = Room(creator: "Guest", members: [String](), questions: self.questions, code: code, state: RoomState.open.text)
            
            FirebaseManager.shared.addRoom(room: room) { (err) in
                if let err = err {
                    print("error", err)
                }
                else {
                    print("Added Guest Room")
                }
            }
        }
        else {
            guard let currentUser = Auth.auth().currentUser, let displayName = currentUser.displayName else { return }

            let room = Room(creator: displayName, members: [String](), questions: self.questions, code: code, state: RoomState.open.text)
            
            FirebaseManager.shared.addRoom(uid: currentUser.uid, room: room) { (err) in
                if let err = err {
                    print("error", err)
                }
                else {
                    print("Added LoggedInUser Room")
                }
            }
        }
    }
    
    @objc func addButtonTapped() {
        
        guard let pollQuestion = pollTextField.text else { return }
        
        if pollQuestion.isEmpty {
            self.showAlert(title: "Error", message: "An input is required") { }
        }
        else {
            questions.append(pollQuestion)
            pollTextField.text = ""
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, for: indexPath)
        
        cell.textLabel?.text = questions[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
