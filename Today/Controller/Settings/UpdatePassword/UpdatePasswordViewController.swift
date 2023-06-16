//
//  UpdatePasswordViewController.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 14.06.2023.
//

import UIKit

class UpdatePasswordViewController: UIViewController {
    
    var updatePasswordTitle = UILabel()
    var oldPassword = CustomTextField(fieldType: .oldPassword)
    var newPassword = CustomTextField(fieldType: .password)
    var repassword = CustomTextField(fieldType: .repassword)
    var updatePasswordBtn = CustomButton(title: "Update", hasBackground: true, fontSize: .med)
    
    var updateFullNameTitle = UILabel()
    var fullNameTextField = CustomTextField(fieldType: .fullname)
    
    var updateUserNameTitle = UILabel()
    var userNameTextField = CustomTextField(fieldType: .username)
    
    var updatePassResponse = UpdatePasswordandUsernameResponse(status: "", msg: "")
    let memberId = UserDefaults.standard.string(forKey: "memberId")
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.setupUI()
        self.updatePasswordBtn.addTarget(self, action: #selector(updatePassword), for: .touchUpInside)
    }
    
    @objc func updatePassword(_ sender: Any){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stringURL = "\(appDelegate.APIURL)/auth/updatePassword"
            let params = [
                "userId": memberId,
                "password": self.oldPassword.text,
                "newPassword": self.newPassword.text,
                "newPasswordAgain": self.repassword.text
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
                    let updatePassRes = try decoder.decode(UpdatePasswordandUsernameResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.updatePassResponse = updatePassRes
                        
                        if self.updatePassResponse.status == "ok" {
                            alert = UIAlertController(title: "Password changed", message: self.updatePassResponse.msg, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
//                            NSLog("The \"OK\" alert occured.")
                                self.navigationController?.popViewController(animated: true)
                            }))
                        } else {
                            alert = UIAlertController(title: "Error Occured", message: self.updatePassResponse.msg, preferredStyle: .alert)
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
        
        self.updatePasswordTitle.text = "Update Password"
        self.updatePasswordTitle.textAlignment = .left
        self.updatePasswordTitle.font = .preferredFont(forTextStyle: .title2, compatibleWith: .none)
        
        self.updatePasswordTitle.translatesAutoresizingMaskIntoConstraints = false
        self.oldPassword.translatesAutoresizingMaskIntoConstraints = false
        self.newPassword.translatesAutoresizingMaskIntoConstraints = false
        self.repassword.translatesAutoresizingMaskIntoConstraints = false
        self.updatePasswordBtn.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.updatePasswordTitle)
        self.view.addSubview(self.oldPassword)
        self.view.addSubview(self.newPassword)
        self.view.addSubview(self.repassword)
        self.view.addSubview(self.updatePasswordBtn)
        
        NSLayoutConstraint.activate([
            
            self.updatePasswordTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            self.updatePasswordTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            self.oldPassword.topAnchor.constraint(equalTo: self.updatePasswordTitle.bottomAnchor, constant: 20),
            self.oldPassword.leadingAnchor.constraint(equalTo: self.updatePasswordTitle.leadingAnchor),
            self.oldPassword.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            self.oldPassword.heightAnchor.constraint(equalToConstant: 55),
            
            self.newPassword.topAnchor.constraint(equalTo: self.oldPassword.bottomAnchor, constant: 20),
            self.newPassword.leadingAnchor.constraint(equalTo: self.oldPassword.leadingAnchor),
            self.newPassword.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            self.newPassword.heightAnchor.constraint(equalToConstant: 55),
            
            self.repassword.topAnchor.constraint(equalTo: self.newPassword.bottomAnchor, constant: 20),
            self.repassword.leadingAnchor.constraint(equalTo: self.newPassword.leadingAnchor),
            self.repassword.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            self.repassword.heightAnchor.constraint(equalToConstant: 55),
            
            self.updatePasswordBtn.topAnchor.constraint(equalTo: self.repassword.bottomAnchor, constant: 20),
            self.updatePasswordBtn.leadingAnchor.constraint(equalTo: self.repassword.leadingAnchor),
            self.updatePasswordBtn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            self.updatePasswordBtn.heightAnchor.constraint(equalToConstant: 55),
        ])
        
    }
}

