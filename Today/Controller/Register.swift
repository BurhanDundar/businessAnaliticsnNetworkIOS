//
//  Register.swift
//  Today
//
//  Created by Şerife Türksever on 22.03.2023.
//

// başına self alamayanları global tanımlayıp selfli mi yapsak bu bir gözden geçirelecek

import UIKit

struct RegisterResponseModel: Codable {
    var status: String
    var msg: String
}

class Register: UIViewController{
    private let scrollView = UIScrollView(frame: UIScreen.main.bounds)
    private let authHeader = AuthHeaderView(title: "Sign Up", subTitle: "Create an account")
    
    private let name = CustomTextField(fieldType: .name)
    private let surname = CustomTextField(fieldType: .surname)
    private let username = CustomTextField(fieldType: .username)
    private let email = CustomTextField(fieldType: .email)
    private let password = CustomTextField(fieldType: .password)
    private let repassword = CustomTextField(fieldType: .repassword)
    
    private let registerBtn = CustomButton(title: "Sign Up", hasBackground: true, fontSize: .med)
    private let signInBtn = CustomButton(title: "Already have an account? Sign In", fontSize: .small)
    
    private var registerResponse: RegisterResponseModel = RegisterResponseModel(status: "", msg: "")
    
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
        self.registerBtn.addTarget(self, action: #selector(registerRequest), for: .touchUpInside)
        
    }
    
    private func setupUI(){
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        self.view.backgroundColor = .systemBackground
        
        stackView.addArrangedSubview(authHeader)
        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(surname)
        stackView.addArrangedSubview(username)
        stackView.addArrangedSubview(email)
        stackView.addArrangedSubview(password)
        stackView.addArrangedSubview(repassword)
        stackView.addArrangedSubview(registerBtn)
        stackView.addArrangedSubview(termsTextView)
        stackView.addArrangedSubview(signInBtn)

        self.authHeader.translatesAutoresizingMaskIntoConstraints = false
        self.name.translatesAutoresizingMaskIntoConstraints = false
        self.surname.translatesAutoresizingMaskIntoConstraints = false
        self.username.translatesAutoresizingMaskIntoConstraints = false
        self.email.translatesAutoresizingMaskIntoConstraints = false
        self.password.translatesAutoresizingMaskIntoConstraints = false
        self.repassword.translatesAutoresizingMaskIntoConstraints = false
        self.registerBtn.translatesAutoresizingMaskIntoConstraints = false
        self.termsTextView.translatesAutoresizingMaskIntoConstraints = false
        self.signInBtn.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            //self.authHeader.topAnchor.constraint(equalTo: stackView.layoutMarginsGuide.topAnchor, constant: 40),
            self.authHeader.heightAnchor.constraint(equalToConstant: 222),
            self.authHeader.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            self.authHeader.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            
            //self.name.topAnchor.constraint(equalTo: self.authHeader.bottomAnchor, constant: 20),
            self.name.centerXAnchor.constraint(equalTo: self.authHeader.centerXAnchor),
            self.name.heightAnchor.constraint(equalToConstant: 55),
            self.name.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            //self.surname.topAnchor.constraint(equalTo: self.name.bottomAnchor, constant: 10),
            self.surname.centerXAnchor.constraint(equalTo: self.name.centerXAnchor),
            self.surname.heightAnchor.constraint(equalToConstant: 55),
            self.surname.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.85),
            
            //self.username.topAnchor.constraint(equalTo: self.surname.bottomAnchor, constant: 10), // 20
            self.username.centerXAnchor.constraint(equalTo: self.surname.centerXAnchor),
            self.username.heightAnchor.constraint(equalToConstant: 55),
            self.username.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.85),
       
            //self.email.topAnchor.constraint(equalTo: self.username.bottomAnchor, constant: 10), // 20
            self.email.centerXAnchor.constraint(equalTo: self.username.centerXAnchor),
            self.email.heightAnchor.constraint(equalToConstant: 55),
            self.email.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.85),
       
            //self.password.topAnchor.constraint(equalTo: self.email.bottomAnchor, constant: 10), // 20
            self.password.centerXAnchor.constraint(equalTo: self.email.centerXAnchor),
            self.password.heightAnchor.constraint(equalToConstant: 55),
            self.password.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.85),
            
            //self.repassword.topAnchor.constraint(equalTo: self.password.bottomAnchor, constant: 10), // 20
            self.repassword.centerXAnchor.constraint(equalTo: self.password.centerXAnchor),
            self.repassword.heightAnchor.constraint(equalToConstant: 55),
            self.repassword.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.85),
       
            //self.registerBtn.topAnchor.constraint(equalTo: self.repassword.bottomAnchor, constant: 10), // 20
            self.registerBtn.centerXAnchor.constraint(equalTo: self.repassword.centerXAnchor),
            self.registerBtn.heightAnchor.constraint(equalToConstant: 55),
            self.registerBtn.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.85),
       
            //self.termsTextView.topAnchor.constraint(equalTo: self.registerBtn.bottomAnchor, constant: 6),
            self.termsTextView.centerXAnchor.constraint(equalTo: self.registerBtn.centerXAnchor),
            self.termsTextView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.85),
            
            self.signInBtn.topAnchor.constraint(equalTo: self.termsTextView.bottomAnchor, constant: 20),
            self.signInBtn.centerXAnchor.constraint(equalTo: self.termsTextView.centerXAnchor),
            //self.registerBtn.heightAnchor.constraint(equalToConstant: 55),
            self.signInBtn.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.85),
       
        
        ])
    }
    
    @objc private func goToSignInPage(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func registerRequest(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stringURL = "\(appDelegate.APIURL)/auth/signup"
                    
            let params = [
                "name": self.name.text,
                "surname": self.surname.text,
                "username": self.username.text,
                "email": self.email.text,
                "password": self.password.text,
                "repassword": self.repassword.text
            ]
        
            guard let url = URL(string: stringURL) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            
            let session = URLSession.shared.dataTask(with: request) { data, response, error in
            
                guard let data = data else { return }
                
                if let error = error {
                    print("there was an error: \(error.localizedDescription)")
                }
                
                do {
                    let decoder = JSONDecoder()
                    let registerRes = try decoder.decode(RegisterResponseModel.self, from: data)
                    DispatchQueue.main.async {
                        self.registerResponse = registerRes
                    }
                    print("register response: ", self.registerResponse.status)
                    if self.registerResponse.status == "ok" {
                        print("Kayıt başarılı")
                        //self.navigationController?.popViewController(animated: true)
                    } else {
                        print("Kayıt başarısız")
                        print("msg: ", self.registerResponse.msg)
                    }
                    
                } catch {
                    print("Hatalı Kayıt")
                }
                
            }
            
            session.resume()
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

