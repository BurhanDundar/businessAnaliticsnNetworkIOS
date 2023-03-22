//
//  Register.swift
//  Today
//
//  Created by Şerife Türksever on 22.03.2023.
//

import UIKit

class Register: UIViewController{
    
    private let authHeader = AuthHeaderView(title: "Sign Up", subTitle: "Create an account")
    
    private let username = CustomTextField(fieldType: .username)
    private let email = CustomTextField(fieldType: .email)
    private let password = CustomTextField(fieldType: .password)
    
    private let registerBtn = CustomButton(title: "Sign Up", hasBackground: true, fontSize: .med)
    private let signInBtn = CustomButton(title: "Already have an account? Sign In", fontSize: .small)
    
    private let termsTextView: UITextView = {
        let attributedString = NSMutableAttributedString(string: "By creating an account, you agree to our Terms & Conditions and you acknowledge that you have read our Privacy Policy.")
        
        attributedString.addAttribute(.link, value: "terms://termsAndConditions", range: (attributedString.string as NSString).range(of: "Terms & Conditions"))

        attributedString.addAttribute(.link, value: "privacy://privacyPolicy", range: (attributedString.string as NSString).range(of:"Privacy Policy"))
        
        let textView = UITextView()
        
        textView.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
        textView.backgroundColor = .clear
        textView.attributedText = attributedString
        textView.textColor = .label
        textView.isSelectable = true
        textView.isEditable = false
        textView.delaysContentTouches = false
        textView.isScrollEnabled = false
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.termsTextView.delegate = self
        
        self.signInBtn.addTarget(self, action: #selector(goToSignInPage), for: .touchUpInside)
        
    }
    
    private func setupUI(){
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(authHeader)
        self.view.addSubview(username)
        self.view.addSubview(email)
        self.view.addSubview(password)
        self.view.addSubview(registerBtn)
        self.view.addSubview(termsTextView)
        self.view.addSubview(signInBtn)

        self.authHeader.translatesAutoresizingMaskIntoConstraints = false
        self.username.translatesAutoresizingMaskIntoConstraints = false
        self.email.translatesAutoresizingMaskIntoConstraints = false
        self.password.translatesAutoresizingMaskIntoConstraints = false
        self.registerBtn.translatesAutoresizingMaskIntoConstraints = false
        self.termsTextView.translatesAutoresizingMaskIntoConstraints = false
        self.signInBtn.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.authHeader.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 40),
            self.authHeader.heightAnchor.constraint(equalToConstant: 222),
            self.authHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.authHeader.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.username.topAnchor.constraint(equalTo: self.authHeader.bottomAnchor, constant: 20),
            self.username.centerXAnchor.constraint(equalTo: self.authHeader.centerXAnchor),
            self.username.heightAnchor.constraint(equalToConstant: 55),
            self.username.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
       
            self.email.topAnchor.constraint(equalTo: self.username.bottomAnchor, constant: 20),
            self.email.centerXAnchor.constraint(equalTo: self.username.centerXAnchor),
            self.email.heightAnchor.constraint(equalToConstant: 55),
            self.email.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
       
            self.password.topAnchor.constraint(equalTo: self.email.bottomAnchor, constant: 20),
            self.password.centerXAnchor.constraint(equalTo: self.email.centerXAnchor),
            self.password.heightAnchor.constraint(equalToConstant: 55),
            self.password.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
       
            self.registerBtn.topAnchor.constraint(equalTo: self.password.bottomAnchor, constant: 20),
            self.registerBtn.centerXAnchor.constraint(equalTo: self.password.centerXAnchor),
            self.registerBtn.heightAnchor.constraint(equalToConstant: 55),
            self.registerBtn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
       
            self.termsTextView.topAnchor.constraint(equalTo: self.registerBtn.bottomAnchor, constant: 6),
            self.termsTextView.centerXAnchor.constraint(equalTo: self.registerBtn.centerXAnchor),
            self.termsTextView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.signInBtn.topAnchor.constraint(equalTo: self.termsTextView.bottomAnchor, constant: 20),
            self.signInBtn.centerXAnchor.constraint(equalTo: self.termsTextView.centerXAnchor),
            //self.registerBtn.heightAnchor.constraint(equalToConstant: 55),
            self.signInBtn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
       
        
        ])
    }
    
    @objc private func goToSignInPage(){
        navigationController?.popViewController(animated: true)
    }
}

extension Register: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL.scheme == "terms" {
            self.showWebViewerController(with: "https://policies.google.com/terms?hl=en")
        } else if URL.scheme == "privacy" {
            self.showWebViewerController(with: "https://policies.google.com/privacy?hl=en")
        }
        
        return true
    }
    
    private func showWebViewerController(with urlString: String) {
        let vc = WebViewerController(with: urlString)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.delegate = nil
        textView.selectedTextRange = nil
        textView.delegate = self
    }
}

