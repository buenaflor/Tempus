//
//  IntroductionViewController.swift
//  Tempus
//
//  Created by Giancarlo on 23.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class IntroductionViewController: BaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var loginButton: TempusButton = {
        let btn = TempusButton(title: "Login", titleColor: .white, backgroundColor: UIColor.Temp.mainDarker, font: .TempRegular)
        btn.addTarget(self, action: #selector(loginPollBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var createPollButton: TempusButton = {
        let btn = TempusButton(title: "Create Poll as Guest", titleColor: .white, backgroundColor: UIColor.Temp.mainDarker, font: .TempRegular)
        btn.addTarget(self, action: #selector(createPollBtnTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var joinRoomButton: TempusButton = {
        let btn = TempusButton(title: "Join Room", titleColor: .white, backgroundColor: UIColor.Temp.mainDarker, font: .TempRegular)
        btn.addTarget(self, action: #selector(joinRoomButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:0.19, green:0.17, blue:0.21, alpha:1.0)
        
        
        view.add(subview: iconImageView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 100),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.7),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.1)
            ]}
        
        view.add(subview: loginButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 24),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 35),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -35)
            ]}
        
        view.add(subview: createPollButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 24),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 35),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -35)
            ]}
        
        view.add(subview: joinRoomButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: createPollButton.bottomAnchor, constant: 24),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 35),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -35)
            ]}
    }
    
    @objc func createPollBtnTapped() {
        let createPollVC = CreatePollViewController(creator: .guest)
        present(createPollVC.wrapped(), animated: true, completion: nil)
    }
    
    @objc func loginPollBtnTapped() {
        let loginVC = LoginViewController()
//        loginVC.configureWithModel("1D04XY")
        present(loginVC.wrapped(), animated: true, completion: nil)
    }
    
    @objc func joinRoomButtonTapped() {
        let joinRoomVC = PollViewController()
        joinRoomVC.configureWithModel("")
        present(joinRoomVC.wrapped(), animated: true, completion: nil)
    }
}
