//
//  CreateExperiencePage.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 20.06.2023.
//

import UIKit

class CreateExperiencePage: UIViewController {
    
    var experienceName = CustomTextField(fieldType: .experienceName)
    var experienceCompany = CustomTextField(fieldType: .experienceCompany)
    var experienceDate = CustomTextField(fieldType: .experienceDate)
    var experienceLocation = CustomTextField(fieldType: .experienceLocation)
    var isExperienceInformable = UISwitch()
    
    var addBtn = CustomButton(title: "Add", fontSize: .med)
    
    var footnote: UILabel!
    var titleTxt: UILabel!
    var isExperienceInformableTitleTxt: UILabel!
    
    let memberId = UserDefaults.standard.string(forKey: "memberId") ?? ""
    let memberEmail = UserDefaults.standard.string(forKey: "memberEmail") ?? ""
    let memberFullName = UserDefaults.standard.string(forKey: "memberFullName") ?? ""
    let memberUserName = UserDefaults.standard.string(forKey: "memberUserName") ?? ""
    let memberUserId = UserDefaults.standard.string(forKey: "memberUserId") ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isExperienceInformable.setOn(false, animated: true)
        view = UIView()
        view.backgroundColor = .systemBackground
        
        self.addBtn.addTarget(self, action: #selector(createExperienceRequest), for: .touchUpInside)
        
        self.setupUI()
    }
    
    private func setupUI(){
        print(memberId)
        
        self.footnote = UILabel()
        self.footnote.text = "Example: IOS developer - Apple - USA/San Francisco - 17 Haziran 2023"
        self.footnote.font = .preferredFont(forTextStyle: .footnote, compatibleWith: .none)
        self.footnote.numberOfLines = 0
        self.footnote.sizeToFit()
        self.footnote.textAlignment = .center
        
        self.titleTxt = UILabel()
        self.titleTxt.text = "👩🏼‍💻 Create Experience 👨🏽‍💻"
        self.titleTxt.font = .boldSystemFont(ofSize: 18)
        self.titleTxt.numberOfLines = 0
        self.titleTxt.sizeToFit()
        self.titleTxt.textAlignment = .center
        
        self.isExperienceInformableTitleTxt = UILabel()
        self.isExperienceInformableTitleTxt.text = "I want to share my new experience with my followers by email 🦾"
        self.isExperienceInformableTitleTxt.font = .boldSystemFont(ofSize: 18)
        self.isExperienceInformableTitleTxt.numberOfLines = 0
        self.isExperienceInformableTitleTxt.sizeToFit()
        self.isExperienceInformableTitleTxt.textAlignment = .center

        self.view.addSubview(self.titleTxt)
        self.view.addSubview(self.experienceName)
        self.view.addSubview(self.experienceCompany)
        self.view.addSubview(self.experienceDate)
        self.view.addSubview(self.experienceLocation)
        self.view.addSubview(self.isExperienceInformableTitleTxt)
        self.view.addSubview(self.isExperienceInformable)
        self.view.addSubview(self.addBtn)
        self.view.addSubview(self.footnote)
        
        self.titleTxt.translatesAutoresizingMaskIntoConstraints = false
        self.experienceName.translatesAutoresizingMaskIntoConstraints = false
        self.experienceCompany.translatesAutoresizingMaskIntoConstraints = false
        self.experienceDate.translatesAutoresizingMaskIntoConstraints = false
        self.experienceLocation.translatesAutoresizingMaskIntoConstraints = false
        self.isExperienceInformableTitleTxt.translatesAutoresizingMaskIntoConstraints = false
        self.isExperienceInformable.translatesAutoresizingMaskIntoConstraints = false
        self.addBtn.translatesAutoresizingMaskIntoConstraints = false
        self.footnote.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            
            self.titleTxt.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120),
            self.titleTxt.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.titleTxt.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
        
            self.experienceName.topAnchor.constraint(equalTo: self.titleTxt.bottomAnchor, constant: 20),
            self.experienceName.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.experienceName.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            self.experienceName.heightAnchor.constraint(equalToConstant: 55),
            
            self.experienceCompany.topAnchor.constraint(equalTo: self.experienceName.bottomAnchor, constant: 10),
            self.experienceCompany.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.experienceCompany.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            self.experienceCompany.heightAnchor.constraint(equalToConstant: 55),
            
            self.experienceDate.topAnchor.constraint(equalTo: self.experienceCompany.bottomAnchor, constant: 10),
            self.experienceDate.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.experienceDate.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            self.experienceDate.heightAnchor.constraint(equalToConstant: 55),
            
            self.experienceLocation.topAnchor.constraint(equalTo: self.experienceDate.bottomAnchor, constant: 10),
            self.experienceLocation.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.experienceLocation.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            self.experienceLocation.heightAnchor.constraint(equalToConstant: 55),
            
            self.isExperienceInformableTitleTxt.topAnchor.constraint(equalTo: self.experienceLocation.bottomAnchor, constant: 10),
            self.isExperienceInformableTitleTxt.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.isExperienceInformableTitleTxt.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.isExperienceInformable.topAnchor.constraint(equalTo: self.isExperienceInformableTitleTxt.bottomAnchor, constant: 10),
            self.isExperienceInformable.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.footnote.topAnchor.constraint(equalTo: self.isExperienceInformable.bottomAnchor, constant: 10),
            self.footnote.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.footnote.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            
            self.addBtn.topAnchor.constraint(equalTo: self.footnote.bottomAnchor, constant: 10),
            self.addBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
        ])
    }
    
    @objc private func createExperienceRequest(){
        self.showSpinner()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stringURL = "\(appDelegate.APIURL)/experience/createExperience"

            let params = [
                "memberFullname": memberFullName,
                "memberId": memberId,
                "memberUserId": memberUserId,
                "experienceName": self.experienceName.text,
                "experienceCompany": self.experienceCompany.text,
                "experienceDate": self.experienceDate.text,
                "experienceLocation": self.experienceLocation.text,
                "isExperienceConformable": self.isExperienceInformable.isOn
            ] as [String: Any?]

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
                    let createExperienceResponse = try decoder.decode(ResponseModel.self, from: data)
                    DispatchQueue.main.async {
                        self.removeSpinner()
                        if(createExperienceResponse.status == "ok") {
                            let alert = UIAlertController(title: "işlem Başarılı", message: "Experience başarıyla oluşturuldu!", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Experience Eklenemedi!", message: "Experience eklenirken bir hata oluştu", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                                    NSLog("The \"OK\" alert occured.")
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Experience Eklenemedi!", message: "Experience eklenirken bir hata oluştu", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            NSLog("The \"OK\" alert occured.")
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    print("Hata oluştu")
                }

            }

            session.resume()
        }
}

