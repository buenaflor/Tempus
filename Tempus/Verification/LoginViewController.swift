//
//  LoginViewController.swift
//  Tempus
//
//  Created by Giancarlo on 23.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import FirebaseAuth

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
        let btn = TempusButton(title: "Log In", titleColor: .white, backgroundColor: UIColor.Temp.mainDarkComplementary, font: .TempRegular)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Temp.main
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOnTap))
        view.addGestureRecognizer(dismissTap)
        
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
        
        loginButton.layer.cornerRadius = 0
        loginButton.backgroundColor = UIColor.Temp.mainDarker
        
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
    
    @objc func guestButtonTapped() {
        let guestVC = GuestViewController()
        navigationController?.pushViewController(guestVC, animated: true)
    }
    
    @objc func registerButtonTapped() {
//        let registerVC = RegisterViewController()
//        present(registerVC.wrapped(), animated: true, completion: nil)
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
            Auth.auth().signIn(withEmail: username, password: password) { (user, error) in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription, completion: {})
                }
                else {
                    
                }
            }
        }
    }
}

