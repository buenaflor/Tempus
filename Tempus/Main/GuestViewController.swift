//
//  GuestViewController.swift
//  Tempus
//
//  Created by Giancarlo on 28.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class GuestViewController: BaseViewController {
    
    lazy var createPollButton: TempusButton = {
        let btn = TempusButton(title: "Create Poll", titleColor: .lightGray, backgroundColor: UIColor.Temp.mainDarker, font: .TempRegular)
        btn.addTarget(self, action: #selector(createPollBtnTapped), for: .touchUpInside)
        btn.layer.cornerRadius = 0
        return btn
    }()
    
    lazy var joinRoomButton: TempusButton = {
        let btn = TempusButton(title: "Join Poll", titleColor: .white, backgroundColor: UIColor.Temp.accent, font: .TempRegular)
        btn.addTarget(self, action: #selector(joinRoomButtonTapped), for: .touchUpInside)
        btn.layer.cornerRadius = 0
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let topContainerView = UIView()
        
        view.add(subview: topContainerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.4)
            ]}
        
        topContainerView.add(subview: iconImageView) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor, constant: -25),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.heightAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.7),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.7)
            ]}
        
        let stackView = UIStackView(arrangedSubviews: [
                createPollButton,
                joinRoomButton
            ])
        
        stackView.distribution = .equalSpacing
        
        view.add(subview: createPollButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 24),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 40),
            v.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2.6)
            ]}
        
        view.add(subview: joinRoomButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 24),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -40),
            v.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2.6)
            ]}
    }
    
    @objc func exitButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func createPollBtnTapped() {
        let createPollVC = CreatePollViewController(creator: .guest)
        present(createPollVC.wrapped(), animated: true, completion: nil)
    }
    
    @objc func joinRoomButtonTapped() {
        let codeVC = CodeViewController()
        navigationController?.pushViewController(codeVC, animated: true)
    }
}
