//
//  MemberViewController.swift
//  Today
//
//  Created by Şerife Türksever on 7.06.2023.
//
import UIKit
import WebKit

class MemberViewController: UIViewController,UIGestureRecognizerDelegate {
    
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
    
    var followingUsersArray = [User]()
    var followingCompaniesArray = [Company]()
    var followingMembersArray = [Member]()
    var followedMembersArray = [Member]()
    
    var stackView = UIStackView()
    
    var memberId = ""
    var memberEmail = ""
    var memberFullName = ""
    var memberUserName = ""
    var memberUserId = ""
    
    var globalMemberId = ""
    
    var systemImageName: String!
    var member: Member!
    var isMemberBookmarked: Bool?
    
    var memberUserDetailBtn = CustomButton(title: "Show User Detail", hasBackground: true, fontSize: .med)

    @objc private func bookmarkMember(){
        self.isMemberBookmarked?.toggle()
        systemImageName = (self.isMemberBookmarked ?? false) ? "bookmark.fill" : "bookmark"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: self.systemImageName), style: .plain, target: self, action: #selector(bookmarkMember))
        
        if let memberId = UserDefaults.standard.string(forKey: "memberId") {
            self.updateMemberFavourite(who: memberId, whom: member.id!, with: "member")
        }
    }
    
    override func viewDidLoad(){
        self.globalMemberId = UserDefaults.standard.string(forKey: "memberId") ?? ""
        self.memberId = self.member.id ?? ""
        self.memberEmail = self.member.email
        self.memberFullName = self.member.fullname
        self.memberUserName = self.member.username
        self.memberUserId = self.member.userId ?? ""
        
        
        super.viewDidLoad()
                
        self.getFollowingUsers()
        self.getFollowingCompanies()
        self.getFollowingMembers()
        self.getFollowedMembers()
        
        systemImageName = (self.isMemberBookmarked ?? false) ? "bookmark.fill" :  "bookmark"
    
        if(self.globalMemberId != self.member.id) {
            let bookmarkBarButton = UIBarButtonItem(image: UIImage(systemName: systemImageName), style: .plain, target: self, action: #selector(bookmarkMember))
            navigationItem.rightBarButtonItem = bookmarkBarButton
        }
        
        self.setupUI()
    }
    
    @objc func openSettings(_ sender: Any){
        self.performSegue(withIdentifier: "OpenSettings", sender: self)
    }
    
    func showConnectedUserDetailButton(){
        self.memberUserDetailBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.memberUserDetailBtn)
        self.memberUserDetailBtn.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85).isActive = true
        self.memberUserDetailBtn.heightAnchor.constraint(equalToConstant: 55).isActive = true
        self.memberUserDetailBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.memberUserDetailBtn.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 25).isActive = true
        
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
        
        self.stackView.axis = .horizontal
        self.stackView.alignment = .fill
        self.stackView.distribution = .equalSpacing
        
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
        
        let tapGesture_0 = UITapGestureRecognizer(target: self, action: #selector(openFollowingUsers))
        tapGesture_0.numberOfTapsRequired = 1
        tapGesture_0.delegate = self
        self.followingUsersView.addGestureRecognizer(tapGesture_0)
        
        let tapGesture_1 = UITapGestureRecognizer(target: self, action: #selector(openFollowingCompanies))
        tapGesture_1.numberOfTapsRequired = 1
        tapGesture_1.delegate = self
        self.followingCompaniesView.addGestureRecognizer(tapGesture_1)
        
        let tapGesture_2 = UITapGestureRecognizer(target: self, action: #selector(openFollowingMembers))
        tapGesture_2.numberOfTapsRequired = 1
        tapGesture_2.delegate = self
        self.followingMembersView.addGestureRecognizer(tapGesture_2)
        
        let tapGesture_3 = UITapGestureRecognizer(target: self, action: #selector(openFollowedMembers))
        tapGesture_3.numberOfTapsRequired = 1
        tapGesture_3.delegate = self
        self.followedMembersView.addGestureRecognizer(tapGesture_3)
        
        self.profileImage.translatesAutoresizingMaskIntoConstraints = false
        self.fullName.translatesAutoresizingMaskIntoConstraints = false
        self.userName.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
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
        self.view.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.followingUsersView)
        self.stackView.addArrangedSubview(self.followingCompaniesView)
        self.stackView.addArrangedSubview(self.followingMembersView)
        self.stackView.addArrangedSubview(self.followedMembersView)
        
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
            
            self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.stackView.topAnchor.constraint(equalTo: self.userName.bottomAnchor, constant: 40),
            self.stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.stackView.heightAnchor.constraint(equalToConstant: 100),
            
            // FOLLOWING USERS
            self.followingUsersView.topAnchor.constraint(equalTo: self.stackView.topAnchor),
            self.followingUsersView.heightAnchor.constraint(equalTo: self.stackView.heightAnchor),
            self.followingUsersView.widthAnchor.constraint(equalTo: self.stackView.widthAnchor, multiplier: 0.20),
            self.followingUsersView.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
            
            self.followingUsersCount.topAnchor.constraint(equalTo: self.followingUsersView.topAnchor),
            self.followingUsersCount.centerXAnchor.constraint(equalTo: self.followingUsersView.centerXAnchor),
            self.followingUsersCount.leadingAnchor.constraint(equalTo: self.followingUsersView.leadingAnchor),
            
            self.followingUsersText.topAnchor.constraint(equalTo: self.followingUsersCount.bottomAnchor, constant: 5),
            self.followingUsersText.centerXAnchor.constraint(equalTo: self.followingUsersView.centerXAnchor),
            self.followingUsersText.leadingAnchor.constraint(equalTo: self.followingUsersView.leadingAnchor),
            
            // FOLLOWING COMPANIES
            self.followingCompaniesView.topAnchor.constraint(equalTo: self.stackView.topAnchor),
            self.followingCompaniesView.heightAnchor.constraint(equalTo: self.stackView.heightAnchor),
            self.followingCompaniesView.widthAnchor.constraint(equalTo: self.stackView.widthAnchor, multiplier: 0.20),
//            self.followingCompaniesView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),

            self.followingCompaniesCount.topAnchor.constraint(equalTo: self.followingCompaniesView.topAnchor),
            self.followingCompaniesCount.centerXAnchor.constraint(equalTo: self.followingCompaniesView.centerXAnchor),
            self.followingCompaniesCount.leadingAnchor.constraint(equalTo: self.followingCompaniesView.leadingAnchor),

            self.followingCompaniesText.topAnchor.constraint(equalTo: self.followingCompaniesCount.bottomAnchor, constant: 5),
            self.followingCompaniesText.centerXAnchor.constraint(equalTo: self.followingCompaniesView.centerXAnchor),
            self.followingCompaniesText.leadingAnchor.constraint(equalTo: self.followingCompaniesView.leadingAnchor),

            // FOLLOWING MEMBERS
            self.followingMembersView.topAnchor.constraint(equalTo: self.stackView.topAnchor),
            self.followingMembersView.heightAnchor.constraint(equalTo: self.stackView.heightAnchor),
            self.followingMembersView.widthAnchor.constraint(equalTo: self.stackView.widthAnchor, multiplier: 0.20),
//            self.followingMembersView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),

            self.followingMembersCount.topAnchor.constraint(equalTo: self.followingMembersView.topAnchor),
            self.followingMembersCount.centerXAnchor.constraint(equalTo: self.followingMembersView.centerXAnchor),
            self.followingMembersCount.leadingAnchor.constraint(equalTo: self.followingMembersView.leadingAnchor),

            self.followingMembersText.topAnchor.constraint(equalTo: self.followingMembersCount.bottomAnchor, constant: 5),
            self.followingMembersText.centerXAnchor.constraint(equalTo: self.followingMembersView.centerXAnchor),
            self.followingMembersText.leadingAnchor.constraint(equalTo: self.followingMembersView.leadingAnchor),

            // FOLLOWED MEMBERS
            self.followedMembersView.topAnchor.constraint(equalTo: self.stackView.topAnchor),
            self.followedMembersView.heightAnchor.constraint(equalTo: self.stackView.heightAnchor),
            self.followedMembersView.widthAnchor.constraint(equalTo: self.stackView.widthAnchor, multiplier: 0.20),
//            self.followedMembersView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 20),

            self.followedMembersCount.topAnchor.constraint(equalTo: self.followedMembersView.topAnchor),
            self.followedMembersCount.centerXAnchor.constraint(equalTo: self.followedMembersView.centerXAnchor),
            self.followedMembersCount.leadingAnchor.constraint(equalTo: self.followedMembersView.leadingAnchor),

            self.followedMembersText.topAnchor.constraint(equalTo: self.followedMembersCount.bottomAnchor, constant: 5),
            self.followedMembersText.centerXAnchor.constraint(equalTo: self.followedMembersView.centerXAnchor),
            self.followedMembersText.leadingAnchor.constraint(equalTo: self.followedMembersView.leadingAnchor),
        ])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if (segue.identifier == "MemberShowFollowingUsers") {
          let followingUsersVC = segue.destination as! FollowingUsersListViewController
          let object = sender as! [String: [User]?]
           followingUsersVC.users = object["users"] as! [User]
       } else if(segue.identifier == "MemberShowFollowingCompanies"){
           let followingCompaniesVC = segue.destination as! FollowingCompaniesListViewController
           let object = sender as! [String: [Company]?]
           followingCompaniesVC.companies = object["companies"] as! [Company]
       } else if(segue.identifier == "MemberShowFollowingMembers"){
           let followingMembersVC = segue.destination as! FollowingMembersListViewController
           let object = sender as! [String: [Member]?]
           followingMembersVC.members = object["members"] as! [Member]
       } else if(segue.identifier == "MemberShowFollowedMembers"){
           let followedMembersVC = segue.destination as! FollowedMembersListViewController
           let object = sender as! [String: [Member]?]
           followedMembersVC.members = object["members"] as! [Member]
       }
    }
    
    @objc func showConnectedUser(_ sender: Any){
        let userListVC = UserListViewController(collectionViewLayout: UICollectionViewLayout())
        let user = userListVC.user(withId: self.memberUserId)
        navigationController?.pushViewController(UserViewController(user: user, isUserBookmarked: user.isBookmarked), animated: true)
    }
    
    @objc func openFollowingUsers(_ sender: UITapGestureRecognizer){
        let sender: [String: [User]?] = [ "users": self.followingUsersArray ]
        self.performSegue(withIdentifier: "MemberShowFollowingUsers", sender: sender)
    }
    
    @objc func openFollowingCompanies(_ sender: UITapGestureRecognizer){
        let sender: [String: [Company]?] = [ "companies": self.followingCompaniesArray ]
        self.performSegue(withIdentifier: "MemberShowFollowingCompanies", sender: sender)
    }
    
    @objc func openFollowingMembers(_ sender: UITapGestureRecognizer){
        let sender: [String: [Member]?] = [ "members": self.followingMembersArray ]
        self.performSegue(withIdentifier: "MemberShowFollowingMembers", sender: sender)
    }
    
    @objc func openFollowedMembers(_ sender: UITapGestureRecognizer){
        let sender: [String: [Member]?] = [ "members": self.followedMembersArray ]
        self.performSegue(withIdentifier: "MemberShowFollowedMembers", sender: sender)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(self.memberUserId != ""){
            self.showConnectedUserDetailButton()
            self.memberUserDetailBtn.addTarget(self, action: #selector(showConnectedUser), for: .touchUpInside)
        }
    }
}
