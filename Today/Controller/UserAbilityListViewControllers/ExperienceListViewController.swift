//
//  ExperienceListViewController.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 4.06.2023.
//

import UIKit

class UpdateExperienceUIButton: UIButton {
    var experienceId: String?
}

class ExperienceListViewController: UIViewController {
        var stackView = UIStackView()
        var scrollView = UIScrollView(frame: UIScreen.main.bounds)
    
    
        var experiences: [Experience]
        init(experiences: [Experience]) {
            self.experiences = experiences
            super.init(nibName: nil, bundle: nil)
        }
    
        required init?(coder: NSCoder) {
            fatalError("Always initialize ExperienceListViewController using init(reminder:)")
        }
    
         override func viewDidLoad() {
             super.viewDidLoad()
             
             view.backgroundColor = .systemBackground
             navigationItem.title = "User Experiences"
             
             var elementConter = 0
             self.setupUI()
             for experience in self.experiences {
                 if experience.subExperiences == nil { // experience has not subExperiences array
                     if(elementConter > 0){
                         self.divider()
                     }
                     
                     var experienceEstablishmentTxt = UILabel()
                     experienceEstablishmentTxt.translatesAutoresizingMaskIntoConstraints = false
                     experienceEstablishmentTxt.text = experience.establishment ?? ""
                     experienceEstablishmentTxt.font = UIFont.boldSystemFont(ofSize: 18)
                     experienceEstablishmentTxt.numberOfLines = 0
                     experienceEstablishmentTxt.sizeToFit()
                     experienceEstablishmentTxt.textAlignment = .center
                     self.stackView.addArrangedSubview(experienceEstablishmentTxt)
                     
                     var experienceNameTxt = UILabel()
                     experienceNameTxt.translatesAutoresizingMaskIntoConstraints = false
                     experienceNameTxt.text = experience.name ?? ""
                     experienceNameTxt.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .none)
                     experienceNameTxt.numberOfLines = 0
                     experienceNameTxt.textColor = .systemBlue
                     experienceNameTxt.sizeToFit()
                     self.stackView.addArrangedSubview(experienceNameTxt)
                     
                     
                     if let date = experience.range {
                         if date.contains("·"){
                             let startEndDateStr = experience.range?.split(separator: "·")[0]
                             let experienceDate = UILabel()
                             experienceDate.translatesAutoresizingMaskIntoConstraints = false
                             experienceDate.text = "\(startEndDateStr ?? "")"
                             experienceDate.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .none)
                             experienceDate.numberOfLines = 0
                             experienceDate.sizeToFit()
                             experienceDate.textColor = .systemGray
                             self.stackView.addArrangedSubview(experienceDate)
                         } else {
                             let experienceDate = UILabel()
                             experienceDate.translatesAutoresizingMaskIntoConstraints = false
                             experienceDate.text = "\(experience.range ?? "")"
                             experienceDate.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .none)
                             experienceDate.numberOfLines = 0
                             experienceDate.sizeToFit()
                             experienceDate.textColor = .systemGray
                             self.stackView.addArrangedSubview(experienceDate)
                         }
                     }
                     
                     let editDeleteStackView = UIStackView()
                     
                     let editButton = UpdateExperienceUIButton()
                     let deleteButton = UpdateExperienceUIButton()
                     
                     editButton.backgroundColor = .systemBlue
                     editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
                     editButton.tintColor = .white
                     editButton.isUserInteractionEnabled = true
                     
                     editButton.experienceId = experience.id
                     editButton.addTarget(self, action: #selector(editExperience), for: .touchUpInside)
                     
                     deleteButton.backgroundColor = .systemRed
                     deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
                     deleteButton.tintColor = .white
                     deleteButton.isUserInteractionEnabled = true
                     
                     deleteButton.experienceId = experience.id
                     deleteButton.addTarget(self, action: #selector(deleteExperience), for: .touchUpInside)

                     
                     editDeleteStackView.axis = .horizontal
                     editDeleteStackView.alignment = .fill
                     editDeleteStackView.distribution = .fillEqually
                     editDeleteStackView.spacing = 10
                     editDeleteStackView.isUserInteractionEnabled = true


                
                     editDeleteStackView.translatesAutoresizingMaskIntoConstraints = false
                     editButton.translatesAutoresizingMaskIntoConstraints = false
                     deleteButton.translatesAutoresizingMaskIntoConstraints = false
                     
                     
                     editDeleteStackView.addArrangedSubview(editButton)
                     editDeleteStackView.addArrangedSubview(deleteButton)
                     self.stackView.addArrangedSubview(editDeleteStackView)

                     
                     self.seperator()
                 } else { // experience has subExperiences array
                     
                     if(elementConter > 0){
                         self.divider()
                     }
                     
                     let establishmentTxt = UILabel()
                     establishmentTxt.translatesAutoresizingMaskIntoConstraints = false
                     establishmentTxt.text = experience.establishment
                     establishmentTxt.numberOfLines = 0
                     establishmentTxt.sizeToFit()
                     establishmentTxt.font = UIFont.boldSystemFont(ofSize: 18)
                     self.stackView.addArrangedSubview(establishmentTxt)
                     
                     for subExperience in experience.subExperiences! { // else içerisine girerse subExp geldiğine eminiz
                         let subExperienceTxt = UILabel()
                         subExperienceTxt.translatesAutoresizingMaskIntoConstraints = false
                         subExperienceTxt.text = subExperience.title
                         subExperienceTxt.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .none)
                         subExperienceTxt.numberOfLines = 0
                         subExperienceTxt.sizeToFit()
                         subExperienceTxt.textColor = .systemBlue
                         self.stackView.addArrangedSubview(subExperienceTxt)
                         
                         if let date = subExperience.start_date {
                             if date.contains("·"){
                                 let startEndDateStr = subExperience.start_date?.split(separator: "·")[0]
                                 let subExperienceDate = UILabel()
                                 subExperienceDate.translatesAutoresizingMaskIntoConstraints = false
                                 subExperienceDate.text = "\(startEndDateStr ?? "")"
                                 subExperienceDate.font = .preferredFont(forTextStyle: .subheadline, compatibleWith: .none)
                                 subExperienceDate.numberOfLines = 0
                                 subExperienceDate.sizeToFit()
                                 subExperienceDate.textColor = .systemGray
                                 self.stackView.addArrangedSubview(subExperienceDate)
                             }
                         }
                         self.seperator()
                     }
                 }
                 elementConter += 1
             }
         }
    
    func divider(){
            let divider = UIView()
            divider.backgroundColor = .label
            divider.heightAnchor.constraint(equalToConstant: 2).isActive = true
            divider.translatesAutoresizingMaskIntoConstraints = false
            self.stackView.addArrangedSubview(divider)
            divider.widthAnchor.constraint(equalTo: self.stackView.widthAnchor).isActive = true
    }
    
    func seperator(){
            let seperator = UIView()
            seperator.backgroundColor = .systemBackground
            seperator.heightAnchor.constraint(equalToConstant: 2).isActive = true
            seperator.translatesAutoresizingMaskIntoConstraints = false
            self.stackView.addArrangedSubview(seperator)
            seperator.widthAnchor.constraint(equalTo: self.stackView.widthAnchor).isActive = true
    }
    
    @objc func editExperience(_ sender: UpdateExperienceUIButton){
        print(sender.experienceId ?? "")
    }
    
    @objc func deleteExperience(_ sender: UpdateExperienceUIButton){
        print(sender.experienceId ?? "")
    }
    
        private func setupUI(){
            self.view.addSubview(self.scrollView)
            
            
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            self.scrollView.isUserInteractionEnabled = true

            self.scrollView.addSubview(self.stackView)
            
            self.stackView.axis = .vertical
            self.stackView.alignment = .center
            self.stackView.spacing = 10
                        
            self.stackView.isUserInteractionEnabled = true
            self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
            self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
            self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 60).isActive = true
            self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
            self.stackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, multiplier: 0.85).isActive = true
            self.stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            
            self.scrollView.translatesAutoresizingMaskIntoConstraints = false
            self.stackView.translatesAutoresizingMaskIntoConstraints = false
            
        }
}
