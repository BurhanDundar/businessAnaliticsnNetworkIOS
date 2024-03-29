//
//  Login.swift
//  Today
//
//  Created by Şerife Türksever on 20.03.2023.
//

import UIKit

struct LoginResponseModel: Codable {
    var status: String
    var msg: String
    var _id: String
    var fullname: String
    var username: String
    var userId: String?
}

class Login: UIViewController {
    var text: UILabel!
    
    private let email = CustomTextField(fieldType: .email)
    private let password = CustomTextField(fieldType: .password)
    
    private let signInBtn = CustomButton(title: "Sign In", hasBackground: true, fontSize: .med)
    private var signInResponse: LoginResponseModel = LoginResponseModel(status: "", msg: "", _id: "", fullname: "", username: "")
    
    private let registerBtn = CustomButton(title: "Create Account" , fontSize: .small)
    private let forgotPassBtn = CustomButton(title: "Forgot Password", fontSize: .small)
    
    private let authHeader = AuthHeaderView(title: "Sign In", subTitle: "Sign in to your account")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        signInBtn.addTarget(self, action: #selector(loginRequest), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(goToRegisterPage), for: .touchUpInside)
        forgotPassBtn.addTarget(self, action: #selector(goToForgotPasswordPage), for: .touchUpInside)
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
            self.registerBtn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.forgotPassBtn.topAnchor.constraint(equalTo: self.registerBtn.bottomAnchor, constant: 15),
            self.forgotPassBtn.centerXAnchor.constraint(equalTo: self.registerBtn.centerXAnchor),
            self.forgotPassBtn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85)
            
        ])
    }
    
    @objc private func goToRegisterPage(){
        navigationController?.pushViewController(Register(), animated: true)
    }
    
    @objc private func goToMainPage(){
        performSegue(withIdentifier: "LoginToTabBar", sender: nil)
    }
    
    @objc private func goToForgotPasswordPage(){
        navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
    }
    
    @objc private func loginRequest(){
        self.showSpinner()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stringURL = "\(appDelegate.APIURL)/auth/login"
            let params = [
                "email": "serifeturksever@gmail.com", // self.email.text
                "password": "123456" // self.password.text
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
                    let loginRes = try decoder.decode(LoginResponseModel.self, from: data)
                    DispatchQueue.main.async {
                        self.signInResponse = loginRes
                    
                    
                    if self.signInResponse.status == "ok" {
                        print("Giriş başarılı")
                        self.removeSpinner()
                        let defaults = UserDefaults.standard
                        defaults.set(loginRes._id, forKey: "memberId")
                        defaults.set("serifeturksever@gmail.com", forKey: "memberEmail")
                        defaults.set(loginRes.fullname, forKey: "memberFullName")
                        defaults.set(loginRes.username, forKey: "memberUserName")
                        
                        if(self.signInResponse.userId != nil){
                            defaults.set(self.signInResponse.userId ?? "", forKey: "memberUserId")
                        }
                        
                        let alert = UIAlertController(title: "Yey! 🎉", message: "Logged in successfully", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            self.performSegue(withIdentifier: "LoginToTabBar", sender: self)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Oops Error!", message: loginRes.msg, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            NSLog("The \"OK\" alert occured.")
                        }))
                        self.present(alert, animated: true, completion: nil)
                        print("Giriş başarısız")
                    }
                    }
                } catch {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Oops Error!", message: "Problem Occured", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            NSLog("The \"OK\" alert occured.")
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    print("Hatalı Giriş")
                }
                
            }
            
            session.resume()
        }
    
    
}

