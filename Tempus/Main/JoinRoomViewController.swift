//
//  JoinRoomViewController.swift
//  Tempus
//
//  Created by Giancarlo on 27.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class JoinRoomViewController: BaseViewController, UITextFieldDelegate {

    let infoLabel = Label(font: .TempRegular, textAlignment: .left, textColor: .white, numberOfLines: 1)
    let joinButton: TempusButton = {
        let btn = TempusButton(title: "Join", titleColor: .white, backgroundColor: UIColor.Temp.mainDarker, font: .TempRegular)
        btn.layer.cornerRadius = 0
        btn.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var roomTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "Room Code")
        tf.backgroundColor = UIColor.Temp.mainDarker
        tf.delegate = self
        tf.tintColor = .white
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.text = "Join a room"
        
        view.add(subview: iconImageView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 30),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.1)
            ]}
        
        view.add(subview: infoLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 30),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 40)
            ]}
        
        view.add(subview: joinButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -40),
            v.heightAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.12),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.17)
            ]}
        
        view.add(subview: roomTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 40),
            v.trailingAnchor.constraint(equalTo: joinButton.leadingAnchor),
            v.heightAnchor.constraint(equalTo: joinButton.heightAnchor)
            ]}
    }
    
    @objc func joinButtonTapped() {
        FirebaseManager.shared.joinRoom(name: "Testname", code: "7380D") { (err) in
            if let err = err {
                print(err)
            }
            else {
                print("joined herst")
            }
        }
    }
}
