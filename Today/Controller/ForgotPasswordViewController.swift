//
//  ForgotPasswordViewController.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 16.06.2023.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    var forgotPasswordTitle = UILabel()
    var forgotPasswordTextField = CustomTextField(fieldType: .email)
    var forgotPasswordBtn = CustomButton(title: "send mail", hasBackground: true, fontSize: .med)
    var forgotPassResponse = UpdatePasswordandUsernameResponse(status: "", msg: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        forgotPasswordBtn.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
    }
    
    @objc func forgotPassword(_ sender: Any){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stringURL = "\(appDelegate.APIURL)/auth/forgotPassword"
            let params = [
                "email": self.forgotPasswordTextField.text
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
                    var alert: UIAlertController!
                    let decoder = JSONDecoder()
                    let forgotPassRes = try decoder.decode(UpdatePasswordandUsernameResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.forgotPassResponse = forgotPassRes
                        
                        if self.forgotPassResponse.status == "ok" {
                            alert = UIAlertController(title: "Password Successfully Updated", message: "New password is sent to your email!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                                self.navigationController?.popViewController(animated: true)
                            }))
                        } else {
                            alert = UIAlertController(title: "Error Occured", message: self.forgotPassResponse.msg, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            NSLog("The \"OK\" alert occured.")
                            }))
                            print("Password couldn't be changed!")
                        }
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    
                } catch {
                    print("Hatalı Giriş")
                }
                
            }
            
            session.resume()
        }
    
    func setupUI(){
        self.view.backgroundColor = .systemBackground
        
        self.forgotPasswordTitle.text = "We will send you new password!"
        self.forgotPasswordTitle.textAlignment = .left
        self.forgotPasswordTitle.font = .preferredFont(forTextStyle: .title2, compatibleWith: .none)
        
        self.forgotPasswordTitle.translatesAutoresizingMaskIntoConstraints = false
        self.forgotPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.forgotPasswordBtn.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.forgotPasswordTitle)
        self.view.addSubview(self.forgotPasswordTextField)
        self.view.addSubview(self.forgotPasswordBtn)
        
        NSLayoutConstraint.activate([
            self.forgotPasswordTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            self.forgotPasswordTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            self.forgotPasswordTextField.topAnchor.constraint(equalTo: self.forgotPasswordTitle.bottomAnchor, constant: 20),
            self.forgotPasswordTextField.leadingAnchor.constraint(equalTo: self.forgotPasswordTitle.leadingAnchor),
            self.forgotPasswordTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            self.forgotPasswordTextField.heightAnchor.constraint(equalToConstant: 55),
            
            self.forgotPasswordBtn.topAnchor.constraint(equalTo: self.forgotPasswordTextField.bottomAnchor, constant: 20),
            self.forgotPasswordBtn.leadingAnchor.constraint(equalTo: self.forgotPasswordTextField.leadingAnchor),
            self.forgotPasswordBtn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            self.forgotPasswordBtn.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
}

