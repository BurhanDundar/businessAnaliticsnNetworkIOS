//
//  CompanyFilterViewController.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 7.06.2023.
//

import UIKit

class CompanyFilterViewController: UIViewController {
    
    var skillTxtField = CustomTextField(fieldType: .skills)
    var experienceTxtField = CustomTextField(fieldType: .experiences)
    var languageTxtField = CustomTextField(fieldType: .languages)
    
    var searchBtn = CustomButton(title: "Search", hasBackground: true, fontSize: .med)
    var footnote: UILabel!
    var titleTxt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = UIView()
        view.backgroundColor = .systemBackground
        
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
        self.titleTxt.text = "Which company features are you looking for ? 💪"
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
}
