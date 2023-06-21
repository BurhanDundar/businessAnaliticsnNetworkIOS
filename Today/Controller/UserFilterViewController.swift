//
//  FilterViewController.swift
//  Today
//
//  Created by Burhan Dündar on 4.03.2023.
//

import UIKit

class UserFilterViewController: UIViewController {
    
    var skillTxtField = CustomTextField(fieldType: .skills)
    var experienceTxtField = CustomTextField(fieldType: .experiences)
    var languageTxtField = CustomTextField(fieldType: .languages)
    
    var searchBtn = CustomButton(title: "Search", fontSize: .med)
    var footnote: UILabel!
    var titleTxt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = UIView()
        view.backgroundColor = .systemBackground
        
        self.searchBtn.addTarget(self, action: #selector(getFilteredUsers), for: .touchUpInside)
        
        self.setupUI()
    }
    
    private func setupUI(){
        
        self.footnote = UILabel()
        self.footnote.text = "Seperate skills, experiences and languages with comma if you want to search for multiple ability"
        self.footnote.font = .preferredFont(forTextStyle: .footnote, compatibleWith: .none)
        self.footnote.numberOfLines = 0
        self.footnote.sizeToFit()
        self.footnote.textAlignment = .center
        
        self.titleTxt = UILabel()
        self.titleTxt.text = "Which abilities are you looking for ? 💪"
        self.titleTxt.font = .preferredFont(forTextStyle: .title2, compatibleWith: .none)
        self.titleTxt.numberOfLines = 0
        self.titleTxt.sizeToFit()
        self.titleTxt.textAlignment = .center

        self.view.addSubview(self.titleTxt)
        self.view.addSubview(self.skillTxtField)
        self.view.addSubview(self.experienceTxtField)
        self.view.addSubview(self.languageTxtField)
        self.view.addSubview(self.searchBtn)
        self.view.addSubview(self.footnote)
        
        self.titleTxt.translatesAutoresizingMaskIntoConstraints = false
        self.skillTxtField.translatesAutoresizingMaskIntoConstraints = false
        self.experienceTxtField.translatesAutoresizingMaskIntoConstraints = false
        self.languageTxtField.translatesAutoresizingMaskIntoConstraints = false
        self.searchBtn.translatesAutoresizingMaskIntoConstraints = false
        self.footnote.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            
            self.titleTxt.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120),
            self.titleTxt.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.titleTxt.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
        
            self.skillTxtField.topAnchor.constraint(equalTo: self.titleTxt.bottomAnchor, constant: 40),
            self.skillTxtField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.skillTxtField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            self.skillTxtField.heightAnchor.constraint(equalToConstant: 55),
            
            self.experienceTxtField.topAnchor.constraint(equalTo: self.skillTxtField.bottomAnchor, constant: 20),
            self.experienceTxtField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.experienceTxtField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            self.experienceTxtField.heightAnchor.constraint(equalToConstant: 55),
            
            self.languageTxtField.topAnchor.constraint(equalTo: self.experienceTxtField.bottomAnchor, constant: 20),
            self.languageTxtField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.languageTxtField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            self.languageTxtField.heightAnchor.constraint(equalToConstant: 55),
            
            self.footnote.topAnchor.constraint(equalTo: self.languageTxtField.bottomAnchor, constant: 20),
            self.footnote.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.footnote.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            
            self.searchBtn.topAnchor.constraint(equalTo: self.footnote.bottomAnchor, constant: 20),
            self.searchBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
        ])
    }
    
    @objc private func getFilteredUsers(_ sender: Any){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stringURL = "\(appDelegate.APIURL)/user/getFilteredUsers"

            let params = [
                "skills": self.skillTxtField.text,
                "experiences": self.experienceTxtField.text,
                "languages": self.languageTxtField.text
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
                    let filteredUsers = try decoder.decode([User].self, from: data)
                    DispatchQueue.main.async {
                        appDelegate.UserSpecialFilterUsers = filteredUsers
                        self.dismiss(animated: true, completion: nil)
                    }
                } catch {
                    print("Hata oluştu")
                }

            }

            session.resume()
            
        }
}
