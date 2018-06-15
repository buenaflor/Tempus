//
//  LoginViewController.swift
//  Tempus
//
//  Created by Giancarlo on 23.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import Firebase

class BaseFormViewController: BaseViewController, UITextFieldDelegate {
    let topContainerView = UIView()
    let informationLabel = Label(font: .TempRegular, textAlignment: .center, textColor: .white, numberOfLines: 0)
    let titleLabel = Label(font: .TempSemiBold, textAlignment: .center, textColor: .white, numberOfLines: 1)
    
    lazy var emailTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "")
        tf.attributedPlaceholder = NSAttributedString.String("Email", font: .TempRegular, color: UIColor.lightGray)
        tf.delegate = self
        return tf
    }()
    
    lazy var passwordTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "")
        tf.attributedPlaceholder = NSAttributedString.String("Password", font: .TempRegular, color: UIColor.lightGray)
        tf.delegate = self
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var loginButton: TempusButton = {
        let btn = TempusButton(title: "Log In", titleColor: .white, backgroundColor: UIColor.Temp.mainDarker, font: .TempRegular)
        btn.layer.cornerRadius = 0
        return btn
    }()
    
    lazy var registerButton: TempusButton = {
        let btn = TempusButton(title: "Create new account", titleColor: .lightGray, backgroundColor: .clear, font: .TempRegular)
        return btn
    }()
    
    lazy var forgotPasswordButton: TempusButton = {
        let btn = TempusButton(title: "Forgot password?", titleColor: .lightGray, backgroundColor: .clear, font: .TempRegular)
        return btn
    }()
    
    lazy var bottomStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [forgotPasswordButton, registerButton])
        sv.distribution = .equalSpacing
        return sv
    }()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == passwordTextField {
            textField.returnKeyType = .done
        } else {
            textField.returnKeyType = .next
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
            return true
        }
        passwordTextField.becomeFirstResponder()
        return true
    }
    
}

class LoginViewController: BaseFormViewController {
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let passwordSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let lockImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "lock").withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
        return iv
    }()
    
    let emailImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "mail").withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
        return iv
    }()
    
    let guestButton: TempusButton = {
        let btn = TempusButton(title: "", titleColor: .lightGray, backgroundColor: .clear, font: .TempRegular)
        btn.layer.cornerRadius = 0
        return btn
    }()
    
    let animatedBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Temp.mainDarker
        return view
    }()
    
    let successCheckmark: UIImageView = {
        let iv = UIImageView()
        iv.alpha = 0
        return iv
    }()
    
    let bottomProfilePic: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        iv.alpha = 0
        iv.image = #imageLiteral(resourceName: "profilepic")
        return iv
    }()
    
    lazy var sendButton: TempusButton = {
        let btn = TempusButton(title: "Send", titleColor: .white, backgroundColor: UIColor.Temp.accent, font: .TempSemiBold)
        btn.alpha = 0
        btn.addTarget(self, action: #selector(sendButtonTapped(sender:)), for: .touchUpInside)
        btn.layer.cornerRadius = 0
        return btn
    }()
    
    let profilePicLabel: Label = {
        let lbl = Label(font: .TempRegular, textAlignment: .center, textColor: .lightGray, numberOfLines: 1)
        lbl.text = "Choose Profile Picture"
        lbl.alpha = 0
        return lbl
    }()
    
    lazy var nameTextField: InputTextField = {
        let tf = InputTextField(placeHolder: "Name")
        tf.delegate = self
        tf.backgroundColor = .clear
        tf.alpha = 0
        tf.addSeparatorLine(color: .lightGray)
        tf.layer.borderWidth = 0
        return tf
    }()
    
    private var isSignUpForm = false
    
    private var animatedBottomHeight: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Temp.main
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOnTap))
        view.addGestureRecognizer(dismissTap)
        
        let profilePicTap = UITapGestureRecognizer(target: self, action: #selector(profilePicTapped))
        bottomProfilePic.addGestureRecognizer(profilePicTap)
        
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        guestButton.addTarget(self, action: #selector(guestButtonTapped), for: .touchUpInside)
        
        // Styling
        emailTextField.backgroundColor = .clear
        emailTextField.layer.borderColor = UIColor.clear.cgColor
        emailTextField.tintColor = .white
        
        passwordTextField.backgroundColor = .clear
        passwordTextField.layer.borderColor = UIColor.clear.cgColor
        passwordTextField.tintColor = .white
        
        iconImageView.image = #imageLiteral(resourceName: "logo_big")
        
        let emailContainerView = UIView()
        let passwordContainerView = UIView()
        
        let containerPadding: CGFloat = 40
        
        let guestAttributedString = NSMutableAttributedString(string: "Continue as ", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font: UIFont.TempRegular])
        guestAttributedString.append(NSAttributedString(string: "Guest", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font: UIFont.TempRegular]))
        guestButton.setAttributedTitle(guestAttributedString, for: .normal)
        
        // Top Container
        
        view.add(subview: topContainerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
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
        
        
        // Email Field
        
        view.add(subview: emailContainerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: topContainerView.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: containerPadding),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -containerPadding),
            v.heightAnchor.constraint(equalToConstant: 60)
            ]}
        
        emailContainerView.add(subview: emailImageView) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.widthAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.4),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.4)
            ]}
        
        emailContainerView.add(subview: emailTextField) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.8),
            v.leadingAnchor.constraint(equalTo: emailImageView.trailingAnchor, constant: 15),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -10)
            ]}
        
        emailContainerView.add(subview: emailSeparatorView) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 1)
            ]}
        
        
        // Password Field
        
        view.add(subview: passwordContainerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: emailContainerView.bottomAnchor, constant: 5),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: containerPadding),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -containerPadding),
            v.heightAnchor.constraint(equalToConstant: 60)
            ]}
        
        passwordContainerView.add(subview: lockImageView) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.widthAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.4),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.4)
            ]}
        
        passwordContainerView.add(subview: passwordTextField) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.8),
            v.leadingAnchor.constraint(equalTo: lockImageView.trailingAnchor, constant: 15),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -10)
            ]}
        
        passwordContainerView.add(subview: passwordSeparatorView) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 1)
            ]}
        
        
        // Login & Info
        
        view.add(subview: loginButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: containerPadding),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: containerPadding),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -containerPadding),
            v.heightAnchor.constraint(equalToConstant: 55)
            ]}
        
        view.add(subview: bottomStackView) { (v, p) in [
            v.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 17),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: containerPadding),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -containerPadding),
            v.heightAnchor.constraint(equalToConstant: 20)
            ]}
        
        view.add(subview: guestButton) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.5),
            v.heightAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.3)
            ]}
        
        animatedBottomHeight = animatedBottomView.heightAnchor.constraint(equalToConstant: 0)
        
        guard let animatedBottomHeight = animatedBottomHeight else { return }
        
        view.add(subview: animatedBottomView) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            animatedBottomHeight
            ]}
        
        animatedBottomView.add(subview: successCheckmark) { (v, p) in [
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.32),
            v.widthAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.32)
            ]}
        
        animatedBottomView.add(subview: bottomProfilePic) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 30),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.3),
            v.widthAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.3)
            ]}

        animatedBottomView.add(subview: profilePicLabel) { (v, p) in [
            v.centerXAnchor.constraint(equalTo: bottomProfilePic.centerXAnchor),
            v.topAnchor.constraint(equalTo: bottomProfilePic.bottomAnchor, constant: 10)
            ]}

        animatedBottomView.add(subview: sendButton) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -20),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.6)
            ]}

        animatedBottomView.add(subview: nameTextField) { (v, p) in [
            v.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.075),
            v.bottomAnchor.constraint(equalTo: sendButton.topAnchor, constant: -25),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 40),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -40)
            ]}
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Customize Color
        //        textField.layer.borderColor = UIColor.white.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        textField.layer.borderColor = UIColor.gray.cgColor
    }
    
    @objc func dismissKeyboardOnTap() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @objc func sendButtonTapped(sender: UIButton) {
        
        guard
            let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let image = bottomProfilePic.image,
            let token = InstanceID.instanceID().token()
        else { return }
        
        
        let user = User(firebaseInstanceId: token, name: name, photoUrl: "")
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            guard let result = result else {
                self.alert(error: err!)
                return
            }
            FirebaseManager.shared.addUser(user, result.user.uid, completion: { (err) in
                if let err = err {
                    self.alert(error: err)
                    self.animateBottomView(false)
                }
                else {
                    
                }
            })
        }
    }
    
    @objc func guestButtonTapped() {
        let guestVC = GuestViewController()
        navigationController?.pushViewController(guestVC, animated: true)
    }
    
    @objc func registerButtonTapped() {
        if !isSignUpForm {
            loginButton.setTitle("Create new account", for: .normal)
            registerButton.setTitle("Log In", for: .normal)
        }
        else {
            loginButton.setTitle("Log In", for: .normal)
            registerButton.setTitle("Create new account", for: .normal)
        }
        
        isSignUpForm = !isSignUpForm
    }
    
    @objc func forgotPasswordButtonTapped() {
        
    }
    
    @objc func loginButtonTapped() {
        guard let username = emailTextField.text, let password = passwordTextField.text else {
            showAlert(title: "Error", message: "Something went wrong", completion: {})
            return
        }
        
        if username.isEmpty || password.isEmpty {
            if username.isEmpty && password.isEmpty {
                emailTextField.layer.borderColor = UIColor.red.cgColor
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                showAlert(title: "Error", message: "Enter your password and username!", completion: {})
            }
            else {
                if username.isEmpty {
                    emailTextField.layer.borderColor = UIColor.red.cgColor
                    showAlert(title: "Error", message: "Enter your username!", completion: {})
                }
                if password.isEmpty {
                    passwordTextField.layer.borderColor = UIColor.red.cgColor
                    showAlert(title: "Error", message: "Enter your password!", completion: {})
                }
            }
        }
        else {
            if !isSignUpForm {
                Auth.auth().signIn(withEmail: username, password: password) { (user, err) in
                    if let err = err {
                        self.alert(error: err)
                    }
                    else {
                        self.successCheckmark.setImage(#imageLiteral(resourceName: "checkmark"), with: .alwaysTemplate, tintColor: .green)
                        self.animateBottomView(true)

                        DispatchQueue.global(qos: .background).async {
                            sleep(2)
                            DispatchQueue.main.async {
                                self.animateBottomView(false, completion: { (_) in
                                    let homeVC = HomeViewController()
                                    self.present(homeVC.wrapped(), animated: true, completion: nil)
                                })
                                
                            }
                        }
                    }
                }
            }
            else {
                checkEmail(username) { (err, value) in
                    if let err = err {
                        self.alert(error: err)
                    }
                    else {
                        guard let value = value else { return }
                        if !value {
                            self.animateBottomView(true)
                            
                            UIView.animate(withDuration: 0.25, animations: {
                                self.profilePicLabel.alpha = 1
                                self.bottomProfilePic.alpha = 1
                                self.nameTextField.alpha = 1
                                self.sendButton.alpha = 1
                            })
                        }
                        else {
                            self.alert(title: "Error", message: "Email already exists", cancelable: false, handler: nil)
                        }
                    }
                }
//                Auth.auth().createUser(withEmail: username, password: password) { (user, err) in
//                    if let err = err {
//                        self.alert(error: err)
//                    }
//                    else {
//
//                    }
//                }
            }
        }
    }
    
    @objc func profilePicTapped() {
        
    }
    
    // Bool refers to containing email: false -> email can be used
    func checkEmail(_ email: String, completion: @escaping (Error?, Bool?) -> Void) {
        Auth.auth().fetchProviders(forEmail: email) { (emails, err) in
            if let err = err {
                completion(err, nil)
            }
            else {
                if emails == nil {
                    completion(nil, false)
                }
                else {
                    completion(nil, true)
                }
            }
        }
    }
}


// MARK: - Animations

extension LoginViewController {
    
    func finishAnimation() {
        
    }
    
    func animateBottomView(_ value: Bool, completion: ((Bool) -> Void)? = nil) {
        if value {
            if !isSignUpForm {
                animatedBottomHeight?.constant = view.frame.height * 0.15
            }
            else {
                animatedBottomHeight?.constant = view.frame.height * 0.44
            }
        }
        else {
            animatedBottomHeight?.constant = 0
        }
        
        if !isSignUpForm {
            UIView.animate(withDuration: 0.25) {
                self.successCheckmark.alpha = value ? 1 : 0
            }
        }
        else {
            
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.successCheckmark.alpha = value ? 1 : 0
            self.view.layoutIfNeeded()
        }, completion: completion)
    }
}






