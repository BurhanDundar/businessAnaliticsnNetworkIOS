//
//  Login.swift
//  Today
//
//  Created by Şerife Türksever on 20.03.2023.
//

import UIKit

class Login: UIViewController {
    var text: UILabel!
    
    private let email = CustomTextField(fieldType: .email)
    private let password = CustomTextField(fieldType: .password)
    
    private let signInBtn = CustomButton(title: "Sign In", hasBackground: true, fontSize: .med)
    private let registerBtn = CustomButton(title: "Create Account" , fontSize: .small)
    private let forgotPassBtn = CustomButton(title: "Forgot Password", fontSize: .small)
    
    private let authHeader = AuthHeaderView(title: "Sign In", subTitle: "Sign in to your account")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        registerBtn.addTarget(self, action: #selector(goToRegisterPage), for: .touchUpInside)
    }
    
    private func setupUI(){
        self.view.backgroundColor = .systemBackground

        self.view.addSubview(authHeader)
        self.view.addSubview(email)
        self.view.addSubview(password)
        self.view.addSubview(signInBtn)
        self.view.addSubview(registerBtn)
        self.view.addSubview(forgotPassBtn)
        
        self.authHeader.translatesAutoresizingMaskIntoConstraints = false
        self.email.translatesAutoresizingMaskIntoConstraints = false
        self.password.translatesAutoresizingMaskIntoConstraints = false
        self.signInBtn.translatesAutoresizingMaskIntoConstraints = false
        self.registerBtn.translatesAutoresizingMaskIntoConstraints = false
        self.forgotPassBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            self.authHeader.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 40),
            self.authHeader.heightAnchor.constraint(equalToConstant: 222),
            self.authHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.authHeader.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            
            self.email.topAnchor.constraint(equalTo: self.authHeader.bottomAnchor, constant: 20),
            self.email.centerXAnchor.constraint(equalTo: self.authHeader.centerXAnchor),
            self.email.heightAnchor.constraint(equalToConstant: 55),
            self.email.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.password.topAnchor.constraint(equalTo: self.email.bottomAnchor, constant: 20),
            self.password.centerXAnchor.constraint(equalTo: self.email.centerXAnchor),
            self.password.heightAnchor.constraint(equalToConstant: 55),
            self.password.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.signInBtn.topAnchor.constraint(equalTo: self.password.bottomAnchor, constant: 20),
            self.signInBtn.centerXAnchor.constraint(equalTo: self.password.centerXAnchor),
            self.signInBtn.heightAnchor.constraint(equalToConstant: 55),
            self.signInBtn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.registerBtn.topAnchor.constraint(equalTo: self.signInBtn.bottomAnchor, constant: 20),
            self.registerBtn.centerXAnchor.constraint(equalTo: self.signInBtn.centerXAnchor),
            //self.registerBtn.heightAnchor.constraint(equalToConstant: 55),
            self.registerBtn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.forgotPassBtn.topAnchor.constraint(equalTo: self.registerBtn.bottomAnchor, constant: 15),
            self.forgotPassBtn.centerXAnchor.constraint(equalTo: self.registerBtn.centerXAnchor),
            //self.forgotPassBtn.heightAnchor.constraint(equalToConstant: 55),
            self.forgotPassBtn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85)
            
        ])
    }
    
    @objc private func goToRegisterPage(){
        navigationController?.pushViewController(Register(), animated: true)
    }
    
}

