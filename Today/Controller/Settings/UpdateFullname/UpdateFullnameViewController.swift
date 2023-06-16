//
//  UpdateFullnameViewController.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 14.06.2023.
//

import UIKit

class UpdateFullnameViewController: UIViewController {
    var updateFullnameTitle = UILabel()
    var fullNameTextField = CustomTextField(fieldType: .fullname)
    var updateFullnameBtn = CustomButton(title: "Update", hasBackground: true, fontSize: .med)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    func setupUI(){
        self.view.backgroundColor = .systemBackground
        
        self.updateFullnameTitle.text = "Update Full Name"
        self.updateFullnameTitle.textAlignment = .left
        self.updateFullnameTitle.font = .preferredFont(forTextStyle: .title2, compatibleWith: .none)
        
        self.updateFullnameTitle.translatesAutoresizingMaskIntoConstraints = false
        self.fullNameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.updateFullnameBtn.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.updateFullnameTitle)
        self.view.addSubview(self.fullNameTextField)
        self.view.addSubview(self.updateFullnameBtn)
        
        NSLayoutConstraint.activate([
            self.updateFullnameTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            self.updateFullnameTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            
            self.fullNameTextField.topAnchor.constraint(equalTo: self.updateFullnameTitle.bottomAnchor, constant: 20),
            self.fullNameTextField.leadingAnchor.constraint(equalTo: self.updateFullnameTitle.leadingAnchor),
            self.fullNameTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            self.fullNameTextField.heightAnchor.constraint(equalToConstant: 55),
            
            self.updateFullnameBtn.topAnchor.constraint(equalTo: self.fullNameTextField.bottomAnchor, constant: 20),
            self.updateFullnameBtn.leadingAnchor.constraint(equalTo: self.fullNameTextField.leadingAnchor),
            self.updateFullnameBtn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            self.updateFullnameBtn.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
}
