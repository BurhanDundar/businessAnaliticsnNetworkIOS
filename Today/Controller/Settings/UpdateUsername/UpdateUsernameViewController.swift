//
//  UpdateUsernameViewController.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 14.06.2023.
//

import UIKit

class UpdateUsernameViewController: UIViewController {
    var updateUsernameTitle = UILabel()
    var userNameTextField = CustomTextField(fieldType: .username)
    var updateUsernameBtn = CustomButton(title: "Update", hasBackground: true, fontSize: .med)
    let memberId = UserDefaults.standard.string(forKey: "memberId")
    
    var updateUsernameResponse = UpdatePasswordandUsernameResponse(status: "", msg: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.updateUsernameBtn.addTarget(self, action: #selector(updateUsername), for: .touchUpInside)
    }
    
    @objc func updateUsername(_ sender: Any){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stringURL = "\(appDelegate.APIURL)/auth/updateUsername"
            let params = [
                "memberId": memberId,
                "newMemberName": self.userNameTextField.text
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
                    let updateUsernameRes = try decoder.decode(UpdatePasswordandUsernameResponse.self, from: data)
                    print(updateUsernameRes)
                    DispatchQueue.main.async {
                        self.updateUsernameResponse = updateUsernameRes
                        
                        if self.updateUsernameResponse.status == "ok" {
                            alert = UIAlertController(title: "User name changed", message: self.updateUsernameResponse.msg, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                                self.navigationController?.popViewController(animated: true)
                            }))
                            UserDefaults.standard.set(self.userNameTextField.text, forKey: "memberUserName")
                        } else {
                            alert = UIAlertController(title: "Error Occured", message: self.updateUsernameResponse.msg, preferredStyle: .alert)
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
        
        self.updateUsernameTitle.text = "Update User Name"
        self.updateUsernameTitle.textAlignment = .left
        self.updateUsernameTitle.font = .preferredFont(forTextStyle: .title2, compatibleWith: .none)
        
        self.updateUsernameTitle.translatesAutoresizingMaskIntoConstraints = false
        self.userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.updateUsernameBtn.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.updateUsernameTitle)
        self.view.addSubview(self.userNameTextField)
        self.view.addSubview(self.updateUsernameBtn)
        
        NSLayoutConstraint.activate([
            self.updateUsernameTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            self.updateUsernameTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            self.userNameTextField.topAnchor.constraint(equalTo: self.updateUsernameTitle.bottomAnchor, constant: 20),
            self.userNameTextField.leadingAnchor.constraint(equalTo: self.updateUsernameTitle.leadingAnchor),
            self.userNameTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            self.userNameTextField.heightAnchor.constraint(equalToConstant: 55),
            
            self.updateUsernameBtn.topAnchor.constraint(equalTo: self.userNameTextField.bottomAnchor, constant: 20),
            self.updateUsernameBtn.leadingAnchor.constraint(equalTo: self.userNameTextField.leadingAnchor),
            self.updateUsernameBtn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            self.updateUsernameBtn.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
}
