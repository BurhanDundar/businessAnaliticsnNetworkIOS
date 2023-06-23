//
//  BookmarkViewController.swift
//  Today
//
//  Created by Burhan Dündar on 4.03.2023.
//

import UIKit

class CompanyViewController: UIViewController {
    
    var tryButton = CustomButton(title: "See All Experiencers", hasBackground: true ,fontSize: .med)
    
    var systemImageName: String!
    var company: Company?
    var isCompanyBookmarked: Bool?
    var experienceCount: Int = 0
    
    var experienceCountLabel = UILabel()
    
    lazy var fetchedImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.layer.borderWidth = 1
//        iv.layer.borderColor = UIColor.blue.cgColor
//        iv.layer.cornerRadius = iv.frame.size.height/2
        iv.clipsToBounds = true
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getCompanyExperienceCount()
        
        systemImageName = (self.isCompanyBookmarked ?? false) ? "bookmark.fill" :  "bookmark"
        let bookmarkBarButton = UIBarButtonItem(image: UIImage(systemName: systemImageName), style: .plain, target: self, action: #selector(bookmarkCompany))
        navigationItem.rightBarButtonItem = bookmarkBarButton
        view.backgroundColor = .systemBackground
        
        let companyName = UILabel()
        companyName.text = company?.name
        companyName.font = .boldSystemFont(ofSize: 22)
        companyName.textColor = .systemBlue
        companyName.textAlignment = .center
        companyName.numberOfLines = 0
        companyName.sizeToFit()
        
        experienceCountLabel.text = "\(experienceCount) Ege University Computer Engineering members have been worked in this company 👩🏼‍💻👨🏽‍💻"
        experienceCountLabel.font = .preferredFont(forTextStyle: .body, compatibleWith: .none)
        experienceCountLabel.textAlignment = .center
        experienceCountLabel.numberOfLines = 0
        experienceCountLabel.sizeToFit()
        
        fetchedImageView.translatesAutoresizingMaskIntoConstraints = false
        companyName.translatesAutoresizingMaskIntoConstraints = false
        tryButton.translatesAutoresizingMaskIntoConstraints = false
        experienceCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        loadFetchedImage(for: company?.image ?? "")
        
        self.view.addSubview(fetchedImageView)
        self.view.addSubview(companyName)
        self.view.addSubview(experienceCountLabel)
        self.view.addSubview(self.tryButton)
        
        
        NSLayoutConstraint.activate([
            fetchedImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchedImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 40),
            fetchedImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            fetchedImageView.heightAnchor.constraint(equalToConstant: 200),
            
            companyName.centerXAnchor.constraint(equalTo: self.fetchedImageView.centerXAnchor),
            companyName.topAnchor.constraint(equalTo: self.fetchedImageView.bottomAnchor, constant: 60),
            companyName.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            experienceCountLabel.topAnchor.constraint(equalTo: companyName.bottomAnchor, constant: 40),
            experienceCountLabel.centerXAnchor.constraint(equalTo: companyName.centerXAnchor),
            experienceCountLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            
            self.tryButton.topAnchor.constraint(equalTo: experienceCountLabel.bottomAnchor, constant: 100),
            self.tryButton.centerXAnchor.constraint(equalTo: experienceCountLabel.centerXAnchor),
            self.tryButton.heightAnchor.constraint(equalToConstant: 55),
            self.tryButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75)
        ])
        
        self.tryButton.addTarget(self, action: #selector(go), for: .touchUpInside)
    }
    
    @objc private func bookmarkCompany(){
        self.isCompanyBookmarked?.toggle()
        systemImageName = (self.isCompanyBookmarked ?? false) ? "bookmark.fill" : "bookmark"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: self.systemImageName), style: .plain, target: self, action: #selector(bookmarkCompany))
        
        if let memberId = UserDefaults.standard.string(forKey: "memberId") {
            self.updateMemberFavourite(who: memberId, whom: company?.id ?? "" , with: "company")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if (segue.identifier == "ShowCompanyUsers") {
          let userListVC = segue.destination as! UserListViewController
           let object = sender as! [String: Company.ID?]
           userListVC.company_id = object["company_id"] as! Company.ID
       }
    }
    
    @objc private func go(_ sender: Any){
        let sender: [String: Company.ID?] = [ "company_id": company?.id ]
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ShowCompanyUsers", sender: sender)
        }
    }
    
    private func loadFetchedImage(for url: String){
        fetchedImageView.loadImage(url, "company")
    }
    
    private func getCompanyExperienceCount(){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let stringURL = "\(appDelegate.APIURL)/experience/companyExperienceCount"
            let params = [
                "companyId": company?.id
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
                    let response = try decoder.decode(CompanyExperienceCountResponseModel.self, from: data)
                    DispatchQueue.main.async {
                        self.experienceCount = response.count
                        self.experienceCountLabel.text = "\(self.experienceCount) Ege University Computer Engineering members have been worked in this company 👩🏼‍💻👨🏽‍💻"
                    }
                } catch {
                    print("Error Occured!")
                }
                
            }
            
            session.resume()
        }
}
