//
//  CodeViewController.swift
//  Tempus
//
//  Created by Giancarlo on 27.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class CodeViewController: BaseViewController {
    
    let codeLabel = Label(font: UIFont.TempSemiBold.withSize(25), textAlignment: .center, textColor: .white, numberOfLines: 1)
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Temp.mainDarker
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
    
    var keyboardShown = false
    var submitButtonSelected = false
    
    var bottomHeightConstraint: NSLayoutConstraint?
    var codeTextFieldYAxisConstraint: NSLayoutConstraint?
    var enterButtonYAxisConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomHeightConstraint = bottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
        enterButtonYAxisConstraint = enterButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
        codeTextFieldYAxisConstraint = codeInputTextField.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
        
        guard let bottomHeightConstraint = bottomHeightConstraint, let codeTextFieldYAxisConstraint = codeTextFieldYAxisConstraint, let enterButtonYAxisConstraint = enterButtonYAxisConstraint else { return }
        
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
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOnTap))
        view.addGestureRecognizer(tapRecognizer)
        
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
    
    @objc func dismissKeyboardOnTap() {
        codeInputTextField.resignFirstResponder()
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
        
        bottomView.add(subview: customActivityIndicator) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.1),
            v.heightAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.1)
            ]}
        
        FirebaseManager.shared.joinRoom(name: "Gino", code: "88408") { (err) in
            if let err = err {
                print(err)
            }
            else {
                FirebaseManager.shared.addRoomListener(code: "88408", completion: { (err, room, votes) in
                    if let err = err {
                        print(err)
                    }
                    else {
                        if let bottomHeightConstraint = self.bottomHeightConstraint {
                            UIView.animate(withDuration: 0.25, animations: {
                                self.customActivityIndicator.stopAnimating()
                                bottomHeightConstraint.constant = -self.bottomView.frame.size.height
                                self.view.layoutIfNeeded()
                            })
                            self.bottomView.removeFromSuperview()
                        }
                    }
                })
            }
        }
    }
}

