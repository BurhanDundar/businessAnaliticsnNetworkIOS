//
//  ProfileViewController.swift
//  Today
//
//  Created by Şerife Türksever on 8.06.2023.
//

import UIKit
import WebKit

class ProfileViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var profileImage: UIImageView = UIImageView()
    var fullName: UILabel = UILabel()
    var userName: UILabel = UILabel()
    
    var followingUsersView = UIView()
    var followingUsersText = UILabel()
    var followingUsersCount = UILabel()
    
    var followingCompaniesView = UIView()
    var followingCompaniesText = UILabel()
    var followingCompaniesCount = UILabel()
    
    var followingMembersView = UIView()
    var followingMembersText = UILabel()
    var followingMembersCount = UILabel()
    
    var followedMembersView = UIView()
    var followedMembersText = UILabel()
    var followedMembersCount = UILabel()
    
    let memberId = UserDefaults.standard.string(forKey: "memberId") ?? ""
    let memberEmail = UserDefaults.standard.string(forKey: "memberEmail") ?? ""
    let memberFullName = UserDefaults.standard.string(forKey: "memberFullName") ?? ""
    let memberUserName = UserDefaults.standard.string(forKey: "memberUserName") ?? ""
    let memberUserId = UserDefaults.standard.string(forKey: "memberUserId") ?? ""
    
    var followingUsersArray = [User]()
    var followingCompaniesArray = [Company]()
    var followingMembersArray = [Member]()
    var followedMembersArray = [Member]()
    
    var connectWithLinkedInTitle = UILabel()
    var connectWithLinkedInTextField = CustomTextField(fieldType: .linkedinProfileLink)
    var connectWithLinkedInBtn = LinkedInButton(title: "Connect account with linkedIn", image: UIImage(named: "linkedin_icon")!)
    var webView = WKWebView()
    
    var linkedInId = ""
    var linkedInFirstName = ""
    var linkedInLastName = ""
    var linkedInEmail = ""
    var linkedInProfilePicURL = ""
    var linkedInAccessToken = ""
    
    override func viewDidLoad(){
        super.viewDidLoad()
                
        self.getFollowingUsers()
        self.getFollowingCompanies()
        self.getFollowingMembers()
        self.getFollowedMembers()
        
        let settingsBarButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(openSettings))
        navigationItem.rightBarButtonItem = settingsBarButton
        self.connectWithLinkedInBtn.addTarget(self, action: #selector(linkedInAuthVC), for: .touchUpInside)
        self.connectWithLinkedInTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.connectWithLinkedInBtn.isEnabled = false
        self.setupUI()
    }
    
    @objc func openSettings(_ sender: Any){
        self.performSegue(withIdentifier: "OpenSettings", sender: self)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if(self.connectWithLinkedInTextField.text == ""){
            self.connectWithLinkedInBtn.isEnabled = false
        } else {
            self.connectWithLinkedInBtn.isEnabled = true
        }
    }
    
    private func getFollowingUsers(){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let stringURL = "\(appDelegate.APIURL)/favourite/getBookmarkedUsers"
            let params = [
                "user_id": memberId,
                "fav_type": "user"
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
                    let followingUsers = try decoder.decode([User].self, from: data)
                    DispatchQueue.main.async {
                        if(followingUsers.count > 0){
                            self.followingUsersView.isUserInteractionEnabled = true
                            self.followingUsersArray = followingUsers
                        } else {
                            self.followingUsersView.isUserInteractionEnabled = false
                        }
                        self.followingUsersCount.text = "\(followingUsers.count)"
                    }
                } catch {
                    print("Error Occured!")
                }
                
            }
            
            session.resume()
        }
    
    private func getFollowingCompanies(){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let stringURL = "\(appDelegate.APIURL)/favourite/getBookmarkedUsers"
            let params = [
                "user_id": memberId,
                "fav_type": "company"
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
                    let followingCompanies = try decoder.decode([Company].self, from: data)
                    DispatchQueue.main.async {
                        if(followingCompanies.count > 0){
                            self.followingCompaniesView.isUserInteractionEnabled = true
                            self.followingCompaniesArray = followingCompanies
                        } else {
                            self.followingCompaniesView.isUserInteractionEnabled = false
                        }
                        self.followingCompaniesCount.text = "\(followingCompanies.count)"
                    }
                } catch {
                    print("Error Occured!")
                }
                
            }
            
            session.resume()
        }
    
    private func getFollowingMembers(){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let stringURL = "\(appDelegate.APIURL)/favourite/getBookmarkedUsers"
            let params = [
                "user_id": memberId,
                "fav_type": "member"
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
                    let followingMembers = try decoder.decode([Member].self, from: data)
                    DispatchQueue.main.async {
                        if(followingMembers.count > 0){
                            self.followingMembersView.isUserInteractionEnabled = true
                            self.followingMembersArray = followingMembers
                        } else {
                            self.followingMembersView.isUserInteractionEnabled = false
                        }
                        self.followingMembersCount.text = "\(followingMembers.count)"
                    }
                } catch {
                    print("Error Occured!")
                }
                
            }
            
            session.resume()
        }
    
    private func getFollowedMembers(){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let stringURL = "\(appDelegate.APIURL)/favourite/getMemberFollowers"
            let params = [
                "fav_id": memberId,
                "fav_type": "member"
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
                    let followedMembers = try decoder.decode([Member].self, from: data)
                    DispatchQueue.main.async {
                        if(followedMembers.count > 0){
                            self.followedMembersView.isUserInteractionEnabled = true
                            self.followedMembersArray = followedMembers
                        } else {
                            self.followedMembersView.isUserInteractionEnabled = false
                        }
                        self.followedMembersCount.text = "\(followedMembers.count)"
                    }
                } catch {
                    print("Error Occured!")
                }
                
            }
            
            session.resume()
        }
    
    func setupUI(){
        // VIEWSETUP
        self.view.backgroundColor = .systemBackground
        
        self.profileImage = UIImageView(image: UIImage(systemName: "person.circle"))
        self.fullName.text = memberFullName
        self.fullName.textAlignment = .center
        self.fullName.numberOfLines = 0
        self.fullName.sizeToFit()
        
        self.userName.text = memberUserName
        self.userName.textAlignment = .center
        self.userName.numberOfLines = 0
        self.userName.sizeToFit()
        
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        // FOLLOWING USERS
        self.followingUsersText.text = "following users"
        self.followingUsersText.font = .preferredFont(forTextStyle: .caption1, compatibleWith: .none)
        self.followingUsersText.numberOfLines = 0
        self.followingUsersText.sizeToFit()
        self.followingUsersText.textAlignment = .center
        
        
        self.followingUsersCount.text = "loading..." // 1233
        self.followingUsersCount.font = .boldSystemFont(ofSize: 15)
        self.followingUsersCount.numberOfLines = 0
        self.followingUsersCount.sizeToFit()
        self.followingUsersCount.textAlignment = .center
        
        self.followingUsersView.addSubview(followingUsersText)
        self.followingUsersView.addSubview(followingUsersCount)
        
        // FOLLOWING COMPANIES
        self.followingCompaniesText.text = "following companies"
        self.followingCompaniesText.font = .preferredFont(forTextStyle: .caption1, compatibleWith: .none)
        self.followingCompaniesText.numberOfLines = 0
        self.followingCompaniesText.sizeToFit()
        self.followingCompaniesText.textAlignment = .center
        
        self.followingCompaniesCount.text = "loading..."
        self.followingCompaniesCount.font = .boldSystemFont(ofSize: 15)
        self.followingCompaniesCount.numberOfLines = 0
        self.followingCompaniesCount.sizeToFit()
        self.followingCompaniesCount.textAlignment = .center
        
        self.followingCompaniesView.addSubview(followingCompaniesText)
        self.followingCompaniesView.addSubview(followingCompaniesCount)
        
        // FOLLOWING MEMBERS
        self.followingMembersText.text = "following members"
        self.followingMembersText.font = .preferredFont(forTextStyle: .caption1, compatibleWith: .none)
        self.followingMembersText.numberOfLines = 0
        self.followingMembersText.sizeToFit()
        self.followingMembersText.textAlignment = .center
        
        self.followingMembersCount.text = "loading..."
        self.followingMembersCount.font = .boldSystemFont(ofSize: 15)
        self.followingMembersCount.numberOfLines = 0
        self.followingMembersCount.sizeToFit()
        self.followingMembersCount.textAlignment = .center
        
        self.followingMembersView.addSubview(followingMembersText)
        self.followingMembersView.addSubview(followingMembersCount)
        
        
        // FOLLOWED MEMBERS
        self.followedMembersText.text = "followed members"
        self.followedMembersText.font = .preferredFont(forTextStyle: .caption1, compatibleWith: .none)
        self.followedMembersText.numberOfLines = 0
        self.followedMembersText.sizeToFit()
        self.followedMembersText.textAlignment = .center
        
        self.followedMembersCount.text = "loading..."
        self.followedMembersCount.font = .boldSystemFont(ofSize: 15)
        self.followedMembersCount.numberOfLines = 0
        self.followedMembersCount.sizeToFit()
        self.followedMembersCount.textAlignment = .center
        
        self.followedMembersView.addSubview(followedMembersText)
        self.followedMembersView.addSubview(followedMembersCount)
        
        self.connectWithLinkedInTitle.text = "Connect Your Account With LinkedIn"
        self.connectWithLinkedInTitle.textAlignment = .left
        self.connectWithLinkedInTitle.font = .preferredFont(forTextStyle: .headline, compatibleWith: .none)
        
//        self.followingUsersView.backgroundColor = .red
        
//        self.followingUsersView.isUserInteractionEnabled = true
        let tapGesture_0 = UITapGestureRecognizer(target: self, action: #selector(openFollowingUsers))
        tapGesture_0.numberOfTapsRequired = 1
        tapGesture_0.delegate = self
        self.followingUsersView.addGestureRecognizer(tapGesture_0)
        
//        self.followingCompaniesView.isUserInteractionEnabled = true
        let tapGesture_1 = UITapGestureRecognizer(target: self, action: #selector(openFollowingCompanies))
        tapGesture_1.numberOfTapsRequired = 1
        tapGesture_1.delegate = self
        self.followingCompaniesView.addGestureRecognizer(tapGesture_1)
        
//        self.followingMembersView.isUserInteractionEnabled = true
        let tapGesture_2 = UITapGestureRecognizer(target: self, action: #selector(openFollowingMembers))
        tapGesture_2.numberOfTapsRequired = 1
        tapGesture_2.delegate = self
        self.followingMembersView.addGestureRecognizer(tapGesture_2)
        
//        self.followedMembersView.isUserInteractionEnabled = true
        let tapGesture_3 = UITapGestureRecognizer(target: self, action: #selector(openFollowedMembers))
        tapGesture_3.numberOfTapsRequired = 1
        tapGesture_3.delegate = self
        self.followedMembersView.addGestureRecognizer(tapGesture_3)
        
        self.profileImage.translatesAutoresizingMaskIntoConstraints = false
        self.fullName.translatesAutoresizingMaskIntoConstraints = false
        self.userName.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.followingUsersText.translatesAutoresizingMaskIntoConstraints = false
        self.followingUsersCount.translatesAutoresizingMaskIntoConstraints = false
        self.followingUsersView.translatesAutoresizingMaskIntoConstraints = false
        
        self.followingCompaniesText.translatesAutoresizingMaskIntoConstraints = false
        self.followingCompaniesCount.translatesAutoresizingMaskIntoConstraints = false
        self.followingCompaniesView.translatesAutoresizingMaskIntoConstraints = false
        
        self.followingMembersText.translatesAutoresizingMaskIntoConstraints = false
        self.followingMembersCount.translatesAutoresizingMaskIntoConstraints = false
        self.followingMembersView.translatesAutoresizingMaskIntoConstraints = false
        
        self.followedMembersText.translatesAutoresizingMaskIntoConstraints = false
        self.followedMembersCount.translatesAutoresizingMaskIntoConstraints = false
        self.followedMembersView.translatesAutoresizingMaskIntoConstraints = false
        
        self.connectWithLinkedInTitle.translatesAutoresizingMaskIntoConstraints = false
        self.connectWithLinkedInTextField.translatesAutoresizingMaskIntoConstraints = false
        self.connectWithLinkedInBtn.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.profileImage)
        self.view.addSubview(self.fullName)
        self.view.addSubview(self.userName)
        self.view.addSubview(stackView)
        stackView.addArrangedSubview(self.followingUsersView)
        stackView.addArrangedSubview(self.followingCompaniesView)
        stackView.addArrangedSubview(self.followingMembersView)
        stackView.addArrangedSubview(self.followedMembersView)
        self.view.addSubview(self.connectWithLinkedInTitle)
        self.view.addSubview(self.connectWithLinkedInTextField)
        self.view.addSubview(self.connectWithLinkedInBtn)
        
        NSLayoutConstraint.activate([
            self.profileImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110),
            self.profileImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.profileImage.widthAnchor.constraint(equalToConstant: 75),
            self.profileImage.heightAnchor.constraint(equalToConstant: 75),
            
            self.fullName.topAnchor.constraint(equalTo: self.profileImage.bottomAnchor, constant: 20),
            self.fullName.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.fullName.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            
            self.userName.topAnchor.constraint(equalTo: self.fullName.bottomAnchor, constant: 20),
            self.userName.centerXAnchor.constraint(equalTo: self.fullName.centerXAnchor),
            self.userName.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: self.userName.bottomAnchor, constant: 40),
            stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 100),
            
            // FOLLOWING USERS
            self.followingUsersView.topAnchor.constraint(equalTo: stackView.topAnchor),
            self.followingUsersView.heightAnchor.constraint(equalTo: stackView.heightAnchor),
            self.followingUsersView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.20),
            self.followingUsersView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            
            self.followingUsersCount.topAnchor.constraint(equalTo: self.followingUsersView.topAnchor),
            self.followingUsersCount.centerXAnchor.constraint(equalTo: self.followingUsersView.centerXAnchor),
            self.followingUsersCount.leadingAnchor.constraint(equalTo: self.followingUsersView.leadingAnchor),
            
            self.followingUsersText.topAnchor.constraint(equalTo: self.followingUsersCount.bottomAnchor, constant: 5),
            self.followingUsersText.centerXAnchor.constraint(equalTo: self.followingUsersView.centerXAnchor),
            self.followingUsersText.leadingAnchor.constraint(equalTo: self.followingUsersView.leadingAnchor),
            
            // FOLLOWING COMPANIES
            self.followingCompaniesView.topAnchor.constraint(equalTo: stackView.topAnchor),
            self.followingCompaniesView.heightAnchor.constraint(equalTo: stackView.heightAnchor),
            self.followingCompaniesView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.20),
//            self.followingCompaniesView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),

            self.followingCompaniesCount.topAnchor.constraint(equalTo: self.followingCompaniesView.topAnchor),
            self.followingCompaniesCount.centerXAnchor.constraint(equalTo: self.followingCompaniesView.centerXAnchor),
            self.followingCompaniesCount.leadingAnchor.constraint(equalTo: self.followingCompaniesView.leadingAnchor),

            self.followingCompaniesText.topAnchor.constraint(equalTo: self.followingCompaniesCount.bottomAnchor, constant: 5),
            self.followingCompaniesText.centerXAnchor.constraint(equalTo: self.followingCompaniesView.centerXAnchor),
            self.followingCompaniesText.leadingAnchor.constraint(equalTo: self.followingCompaniesView.leadingAnchor),

            // FOLLOWING MEMBERS
            self.followingMembersView.topAnchor.constraint(equalTo: stackView.topAnchor),
            self.followingMembersView.heightAnchor.constraint(equalTo: stackView.heightAnchor),
            self.followingMembersView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.20),
//            self.followingMembersView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),

            self.followingMembersCount.topAnchor.constraint(equalTo: self.followingMembersView.topAnchor),
            self.followingMembersCount.centerXAnchor.constraint(equalTo: self.followingMembersView.centerXAnchor),
            self.followingMembersCount.leadingAnchor.constraint(equalTo: self.followingMembersView.leadingAnchor),

            self.followingMembersText.topAnchor.constraint(equalTo: self.followingMembersCount.bottomAnchor, constant: 5),
            self.followingMembersText.centerXAnchor.constraint(equalTo: self.followingMembersView.centerXAnchor),
            self.followingMembersText.leadingAnchor.constraint(equalTo: self.followingMembersView.leadingAnchor),

            // FOLLOWED MEMBERS
            self.followedMembersView.topAnchor.constraint(equalTo: stackView.topAnchor),
            self.followedMembersView.heightAnchor.constraint(equalTo: stackView.heightAnchor),
            self.followedMembersView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.20),
//            self.followedMembersView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 20),

            self.followedMembersCount.topAnchor.constraint(equalTo: self.followedMembersView.topAnchor),
            self.followedMembersCount.centerXAnchor.constraint(equalTo: self.followedMembersView.centerXAnchor),
            self.followedMembersCount.leadingAnchor.constraint(equalTo: self.followedMembersView.leadingAnchor),

            self.followedMembersText.topAnchor.constraint(equalTo: self.followedMembersCount.bottomAnchor, constant: 5),
            self.followedMembersText.centerXAnchor.constraint(equalTo: self.followedMembersView.centerXAnchor),
            self.followedMembersText.leadingAnchor.constraint(equalTo: self.followedMembersView.leadingAnchor),
            
            self.connectWithLinkedInTitle.topAnchor.constraint(equalTo: self.followedMembersText.bottomAnchor, constant: 40),
            self.connectWithLinkedInTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.connectWithLinkedInTitle.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.connectWithLinkedInTextField.topAnchor.constraint(equalTo: self.connectWithLinkedInTitle.bottomAnchor, constant: 20),
            self.connectWithLinkedInTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.connectWithLinkedInTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            self.connectWithLinkedInTextField.heightAnchor.constraint(equalToConstant: 55),
            
            self.connectWithLinkedInBtn.topAnchor.constraint(equalTo: self.connectWithLinkedInTextField.bottomAnchor, constant: 20),
            self.connectWithLinkedInBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.connectWithLinkedInBtn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            self.connectWithLinkedInBtn.heightAnchor.constraint(equalToConstant: 55),
            
            
        ])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if (segue.identifier == "ShowFollowingUsers") {
          let followingUsersVC = segue.destination as! FollowingUsersListViewController
          let object = sender as! [String: [User]?]
           followingUsersVC.users = object["users"] as! [User]
       } else if(segue.identifier == "ShowFollowingCompanies"){
           let followingCompaniesVC = segue.destination as! FollowingCompaniesListViewController
           let object = sender as! [String: [Company]?]
           followingCompaniesVC.companies = object["companies"] as! [Company]
       } else if(segue.identifier == "ShowFollowingMembers"){
           let followingMembersVC = segue.destination as! FollowingMembersListViewController
           let object = sender as! [String: [Member]?]
           followingMembersVC.members = object["members"] as! [Member]
       } else if(segue.identifier == "ShowFollowedMembers"){
           let followedMembersVC = segue.destination as! FollowedMembersListViewController
           let object = sender as! [String: [Member]?]
           followedMembersVC.members = object["members"] as! [Member]
       }
    }
    
    @objc func openFollowingUsers(_ sender: UITapGestureRecognizer){
        let sender: [String: [User]?] = [ "users": self.followingUsersArray ]
        self.performSegue(withIdentifier: "ShowFollowingUsers", sender: sender)
    }
    
    @objc func openFollowingCompanies(_ sender: UITapGestureRecognizer){
        let sender: [String: [Company]?] = [ "companies": self.followingCompaniesArray ]
        self.performSegue(withIdentifier: "ShowFollowingCompanies", sender: sender)
    }
    
    @objc func openFollowingMembers(_ sender: UITapGestureRecognizer){
        let sender: [String: [Member]?] = [ "members": self.followingMembersArray ]
        self.performSegue(withIdentifier: "ShowFollowingMembers", sender: sender)
    }
    
    @objc func openFollowedMembers(_ sender: UITapGestureRecognizer){
        let sender: [String: [Member]?] = [ "members": self.followedMembersArray ]
        self.performSegue(withIdentifier: "ShowFollowedMembers", sender: sender)
    }
    
    @objc func didCancelAdd(_ sender: UIBarButtonItem){
        dismiss(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.userName.text = UserDefaults.standard.string(forKey: "memberUserName")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(self.memberUserId != ""){
            self.connectWithLinkedInTitle.removeFromSuperview()
            self.connectWithLinkedInTextField.removeFromSuperview()
            self.connectWithLinkedInBtn.removeFromSuperview()
        }
    }
    
    // LINKEDIN LOGIN
    @objc func linkedInAuthVC() {
        // Create linkedIn Auth ViewController
        let linkedInVC = UIViewController()
        // Create WebView
        let webView = WKWebView()
        webView.navigationDelegate = self
        linkedInVC.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: linkedInVC.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: linkedInVC.view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: linkedInVC.view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: linkedInVC.view.trailingAnchor)
            ])

        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"

        let authURLFull = LinkedInConstants.AUTHURL + "?response_type=code&client_id=" + LinkedInConstants.CLIENT_ID + "&scope=" + LinkedInConstants.SCOPE + "&state=" + state + "&redirect_uri=" + LinkedInConstants.REDIRECT_URI


        let urlRequest = URLRequest.init(url: URL.init(string: authURLFull)!)
        webView.load(urlRequest)

        // Create Navigation Controller
        let navController = UINavigationController(rootViewController: linkedInVC)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        linkedInVC.navigationItem.leftBarButtonItem = cancelButton
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshAction))
        linkedInVC.navigationItem.rightBarButtonItem = refreshButton
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = textAttributes
        linkedInVC.navigationItem.title = "linkedin.com"
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = UIColor.black
        navController.navigationBar.barTintColor = UIColor.colorFromHex("#0072B1")
        navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.modalTransitionStyle = .coverVertical

        self.present(navController, animated: true, completion: nil)
    }

    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func refreshAction() {
        self.webView.reload()
    }

}

// LINKEDIN LOGIN
extension ProfileViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        RequestForCallbackURL(request: navigationAction.request)
        
        //Close the View Controller after getting the authorization code
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlStr.contains("?code=") {
                self.dismiss(animated: true, completion: nil)
            }
        }
        decisionHandler(.allow)
    }

    func RequestForCallbackURL(request: URLRequest) {
        // Get the authorization code string after the '?code=' and before '&state='
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(LinkedInConstants.REDIRECT_URI) {
            if requestURLString.contains("?code=") {
                if let range = requestURLString.range(of: "=") {
                    let linkedinCode = requestURLString[range.upperBound...]
                    if let range = linkedinCode.range(of: "&state=") {
                        let linkedinCodeFinal = linkedinCode[..<range.lowerBound]
                        handleAuth(linkedInAuthorizationCode: String(linkedinCodeFinal))
                    }
                }
            }
        }
    }

    func handleAuth(linkedInAuthorizationCode: String) {
        linkedinRequestForAccessToken(authCode: linkedInAuthorizationCode)
    }

    func linkedinRequestForAccessToken(authCode: String) {
        let grantType = "authorization_code"

        // Set the POST parameters.
        let postParams = "grant_type=" + grantType + "&code=" + authCode + "&redirect_uri=" + LinkedInConstants.REDIRECT_URI + "&client_id=" + LinkedInConstants.CLIENT_ID + "&client_secret=" + LinkedInConstants.CLIENT_SECRET
        let postData = postParams.data(using: String.Encoding.utf8)
        let request = NSMutableURLRequest(url: URL(string: LinkedInConstants.TOKENURL)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                let results = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                
//                print("results is: \(results)")


                let accessToken = results?["access_token"] as! String
//                print("accessToken is: \(accessToken)")

                let expiresIn = results?["expires_in"] as! Int
//                print("expires in: \(expiresIn)")

                // Get user's id, first name, last name, profile pic url
                self.fetchLinkedInUserProfile(accessToken: accessToken)
            }
        }
        task.resume()
    }


    func fetchLinkedInUserProfile(accessToken: String) {
        let tokenURLFull = "https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture(displayImage~:playableStreams))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let verify: NSURL = NSURL(string: tokenURLFull!)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
//            print("data is: \(data)")
//            print("response is: \(response)")


            if error == nil {
                let linkedInProfileModel = try? JSONDecoder().decode(LinkedInProfileModel.self, from: data!)
                
//                print("Profile Model **************",linkedInProfileModel)
                
//                print("Linkedin Profile Link")
                print(self.connectWithLinkedInTextField.text)
                
                //AccessToken
//                print("LinkedIn Access Token: \(accessToken)")
                self.linkedInAccessToken = accessToken
                
                // LinkedIn Id
                let linkedinId: String! = linkedInProfileModel?.id
//                print("LinkedIn Id: \(linkedinId ?? "")")
                self.linkedInId = linkedinId

                // LinkedIn First Name
                let linkedinFirstName: String! = linkedInProfileModel?.firstName.localized.enUS
//                print("LinkedIn First Name: \(linkedinFirstName ?? "")")
                self.linkedInFirstName = linkedinFirstName

                // LinkedIn Last Name
                let linkedinLastName: String! = linkedInProfileModel?.lastName.localized.enUS
//                print("LinkedIn Last Name: \(linkedinLastName ?? "")")
                self.linkedInLastName = linkedinLastName

                // LinkedIn Profile Picture URL
                let linkedinProfilePic: String!

                if let pictureUrls = linkedInProfileModel?.profilePicture?.displayImage.elements[2].identifiers[0].identifier {
                    linkedinProfilePic = pictureUrls
                } else {
                    linkedinProfilePic = "Not exists"
                }
//                print("LinkedIn Profile Avatar URL: \(linkedinProfilePic ?? "")")
                self.linkedInProfilePicURL = linkedinProfilePic

                // Get user's email address
                self.fetchLinkedInEmailAddress(accessToken: accessToken)
            }
        }
        task.resume()
    }

    func fetchLinkedInEmailAddress(accessToken: String) {
        let tokenURLFull = "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let verify: NSURL = NSURL(string: tokenURLFull!)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                let linkedInEmailModel = try? JSONDecoder().decode(LinkedInEmailModel.self, from: data!)

                // LinkedIn Email
                let linkedinEmail: String! = linkedInEmailModel?.elements[0].elementHandle.emailAddress
//                print("LinkedIn Email: \(linkedinEmail ?? "")")
                self.linkedInEmail = linkedinEmail
                
                DispatchQueue.main.async {
                    if((self.memberEmail ?? "") == (self.linkedInEmail ?? "")){
                        self.connectAccountWithLinkedInFunc()
                    } else {
                        let alert = UIAlertController(title: "Oops!", message: "Mails don't match", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    func connectAccountWithLinkedInFunc(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stringURL = "\(appDelegate.APIURL)/member/connectAccountWithLinkedIn"
        
            let params = [
                "memberId": memberId,
                "profileLink": self.connectWithLinkedInTextField.text ?? ""
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
                    let response = try decoder.decode(ConnectAccountResponse.self, from: data)
                    print(response)
                    
                    if(response.userId != ""){
                        UserDefaults.standard.set(response.userId, forKey: "memberUserId")
                    }
                    
                    DispatchQueue.main.async {
                        if response.status == "ok" {
                            let alert = UIAlertController(title: "Congratulations! 🎉", message: "Your accounts are matched successfully", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                                self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            self.connectWithLinkedInTitle.removeFromSuperview()
                            self.connectWithLinkedInTextField.removeFromSuperview()
                            self.connectWithLinkedInBtn.removeFromSuperview()
                        } else {
                            let alert = UIAlertController(title: "Oops!", message: "Mails don't match", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                                NSLog("The \"OK\" alert occured.")
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                } catch {
                    print("Hatalı Giriş Yapıldı")
                }
                
            }
            session.resume()
    }
    
    
    
}

