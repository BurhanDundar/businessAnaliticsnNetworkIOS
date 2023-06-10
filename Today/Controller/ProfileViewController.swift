//
//  ProfileViewController.swift
//  Today
//
//  Created by Şerife Türksever on 8.06.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
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
    
    let memberFullName = UserDefaults.standard.string(forKey: "memberFullName") ?? ""
    let memberUserName = UserDefaults.standard.string(forKey: "memberUserName") ?? ""
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//
//    }
    
    override func viewDidLoad(){
        print(memberFullName)
        print(memberUserName)
        super.viewDidLoad()
        self.setupUI()
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
        
        // SCROLLVIEW SETUP
        let scrollView = UIScrollView()
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
//        stackView.spacing = 10
//        stackView.distribution = .fillEqually
//        stackView.distribution = .fill
        
        
        // FOLLOWING USERS
        self.followingUsersText.text = "following users"
        self.followingUsersText.font = .preferredFont(forTextStyle: .caption1, compatibleWith: .none)
        self.followingUsersText.numberOfLines = 0
        self.followingUsersText.sizeToFit()
        self.followingUsersText.textAlignment = .center
        
        
        self.followingUsersCount.text = "1233"
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
        
        self.followingCompaniesCount.text = "230"
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
        
        self.followingMembersCount.text = "123"
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
        
        self.followedMembersCount.text = "89"
        self.followedMembersCount.font = .boldSystemFont(ofSize: 15)
        self.followedMembersCount.numberOfLines = 0
        self.followedMembersCount.sizeToFit()
        self.followedMembersCount.textAlignment = .center
        
        self.followedMembersView.addSubview(followedMembersText)
        self.followedMembersView.addSubview(followedMembersCount)
        
        
        
        self.profileImage.translatesAutoresizingMaskIntoConstraints = false
        self.fullName.translatesAutoresizingMaskIntoConstraints = false
        self.userName.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
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
        
        self.view.addSubview(self.profileImage)
        self.view.addSubview(self.fullName)
        self.view.addSubview(self.userName)
        self.view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(self.followingUsersView)
        stackView.addArrangedSubview(self.followingCompaniesView)
        stackView.addArrangedSubview(self.followingMembersView)
        stackView.addArrangedSubview(self.followedMembersView)
        
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
            
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            scrollView.topAnchor.constraint(equalTo: self.userName.bottomAnchor, constant: 40),
            scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 120),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
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
            
            
        ])
        
        
    }
   
}
