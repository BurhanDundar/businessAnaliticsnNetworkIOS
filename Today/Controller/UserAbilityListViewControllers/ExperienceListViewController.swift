//
//  ExperienceListViewController.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 4.06.2023.
//

import UIKit

class ExperienceListViewController: UIViewController {
    
        var experienceNameTxt = UILabel()
        var experienceEstablishmentTxt = UILabel()
        var stackView = UIStackView()
        var scrollView = UIScrollView()
    
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
             
             //let appDelegate = UIApplication.shared.delegate as! AppDelegate
             //Experience.sampleData = appDelegate.userExperiences as [Experience]
             //self.experiences = Experience.sampleData
             
             view.backgroundColor = .systemBackground
             navigationItem.title = "User Experiences"
             
             self.setupUI()
             for experience in self.experiences {
                 if experience.subExperiences == nil { // experience has not subExperiences array
                     self.experienceNameTxt.translatesAutoresizingMaskIntoConstraints = false
                     self.experienceNameTxt.text = "\(experience.name ?? "") at \(experience.establishment)"
                     self.experienceNameTxt.numberOfLines = 0
                     self.experienceNameTxt.sizeToFit()
                     self.stackView.addArrangedSubview(self.experienceNameTxt)
                 } else { // experience has subExperiences array
                     let establishmentTxt = UILabel()
                     establishmentTxt.translatesAutoresizingMaskIntoConstraints = false
                     establishmentTxt.text = experience.establishment
                     establishmentTxt.numberOfLines = 0
                     establishmentTxt.sizeToFit()
                     self.stackView.addArrangedSubview(establishmentTxt)
                     
                     for subExperience in experience.subExperiences! { // else içerisine girerse subExp geldiğine eminiz
                         let subExperienceTxt = UILabel()
                         subExperienceTxt.translatesAutoresizingMaskIntoConstraints = false
                         subExperienceTxt.text = subExperience.title
                         
                         subExperienceTxt.numberOfLines = 0
                         subExperienceTxt.sizeToFit()
                         self.stackView.addArrangedSubview(subExperienceTxt)
                     }
                 }
             }
             
         }
    
        private func setupUI(){
            self.view.addSubview(self.scrollView)
            
            
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            
            self.scrollView.addSubview(self.stackView)
            
            self.stackView.axis = .vertical
            self.stackView.alignment = .center
            self.stackView.spacing = 10
            
            self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
            self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
            self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
            self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
            self.stackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
            
            self.scrollView.translatesAutoresizingMaskIntoConstraints = false
            self.stackView.translatesAutoresizingMaskIntoConstraints = false
            
        }
}
