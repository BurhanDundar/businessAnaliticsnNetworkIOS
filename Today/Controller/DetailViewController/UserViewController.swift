//
//  UserViewController.swift
//  Today
//
//  Created by Burhan Dündar on 10.02.2023.
//

import UIKit

class UserViewController: UIViewController,UIScrollViewDelegate {
    
    let parentView: UserListViewController
    
    var user: User
    init(user: User, parent: UserListViewController) {
        self.user = user
        self.parentView = parent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize UserViewController using init(reminder:)")
    }
    
    internal func inheritedUserUpdate(_ user: User){
        self.parentView.updateUser(user)
        self.parentView.collectionView.reloadData()
    }
    
    var nameLabel: UILabel! // bunlar UITextView mi yapılmalı bunlara bak
    var titleLabel: UILabel!
    var connectionCount: UILabel!
    var location: UILabel!
    var skillsButton: UIButton!
    var systemImageName: String!
    var educationsButton: UIButton!
    var experiencesButton: UIButton!
    var languagesButton: UIButton!
    
    
    lazy var fetchedImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .orange
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.blue.cgColor
        iv.layer.cornerRadius = 24 // iv.frame.height / 2
        iv.layer.masksToBounds = false
        iv.clipsToBounds = true
        return iv
    }()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        systemImageName = user.isBookmarked ? "bookmark.fill" :  "bookmark"
        
        let bookmarkBarButton = UIBarButtonItem(image: UIImage(systemName: systemImageName), style: .plain, target: self, action: #selector(bookmarkMember))
        navigationItem.rightBarButtonItem = bookmarkBarButton
        
        view.addSubview(fetchedImageView)
        
        NSLayoutConstraint.activate([
            fetchedImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchedImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            fetchedImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            fetchedImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        loadFetchedImage(for: user.image)
    
        // Name
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.text = user.full_name
        
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: fetchedImageView.bottomAnchor,constant: 20),
            nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
                ])
        
        // Connection Count
        connectionCount = UILabel()
        connectionCount.translatesAutoresizingMaskIntoConstraints = false
        connectionCount.textAlignment = .center
        connectionCount.textColor = .gray
        connectionCount.numberOfLines = 0
        connectionCount.text = user.connection_count
        connectionCount.font = UIFont.systemFont(ofSize: 12)
        
        view.addSubview(connectionCount)
        
        NSLayoutConstraint.activate([
            connectionCount.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 10),
            connectionCount.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        //Location
        location = UILabel()
        location.translatesAutoresizingMaskIntoConstraints = false
        location.textAlignment = .center
        location.numberOfLines = 0
        location.text = user.location
        
        view.addSubview(location)
        
        NSLayoutConstraint.activate([
            location.topAnchor.constraint(equalTo: connectionCount.bottomAnchor, constant: 10),
            location.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        // Title
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = user.title
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: location.bottomAnchor,constant: 10),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
                ])
        skillsButton = UIButton()
        skillsButton.translatesAutoresizingMaskIntoConstraints = false
        skillsButton.setTitle("Skills", for: .normal)
        skillsButton.setTitleColor(.blue, for: .normal)
        skillsButton.setTitleColor(.blue, for: .highlighted)
        skillsButton.addTarget(self, action: #selector(skillsNavigation), for: .touchUpInside)
        
        view.addSubview(skillsButton)
        
        NSLayoutConstraint.activate([
            skillsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skillsButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 10),
            skillsButton.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        educationsButton = UIButton()
        educationsButton.translatesAutoresizingMaskIntoConstraints = false
        educationsButton.setTitle("Educations", for: .normal)
        educationsButton.setTitleColor(.blue, for: .normal)
        educationsButton.setTitleColor(.blue, for: .highlighted)
        educationsButton.addTarget(self, action: #selector(educationsNavigation), for: .touchUpInside)
        
        view.addSubview(educationsButton)
        
        NSLayoutConstraint.activate([
            educationsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            educationsButton.topAnchor.constraint(equalTo: skillsButton.bottomAnchor,constant: 10),
            educationsButton.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        experiencesButton = UIButton()
        experiencesButton.translatesAutoresizingMaskIntoConstraints = false
        experiencesButton.setTitle("Experiences", for: .normal)
        experiencesButton.setTitleColor(.blue, for: .normal)
        experiencesButton.setTitleColor(.blue, for: .highlighted)
        experiencesButton.addTarget(self, action: #selector(experiencesNavigation), for: .touchUpInside)
        
        view.addSubview(experiencesButton)
        
        NSLayoutConstraint.activate([
            experiencesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            experiencesButton.topAnchor.constraint(equalTo: educationsButton.bottomAnchor,constant: 10),
            experiencesButton.widthAnchor.constraint(equalToConstant: 150)
        ])

        languagesButton = UIButton()
        languagesButton.translatesAutoresizingMaskIntoConstraints = false
        languagesButton.setTitle("Languages", for: .normal)
        languagesButton.setTitleColor(.blue, for: .normal)
        languagesButton.setTitleColor(.blue, for: .highlighted)
        languagesButton.addTarget(self, action: #selector(languagesNavigation), for: .touchUpInside)
        
        view.addSubview(languagesButton)
        
        NSLayoutConstraint.activate([
            languagesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            languagesButton.topAnchor.constraint(equalTo: experiencesButton.bottomAnchor,constant: 10),
            languagesButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationSetup()
    }
    
    func navigationSetup(){
        // Navigation
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }
        navigationItem.title = NSLocalizedString("User", comment: "User view controller title")
    }
    
    @objc func skillsNavigation(){
        navigationController?.pushViewController(SkillsViewController(), animated: true)
    }
    
    @objc func educationsNavigation(){
        navigationController?.pushViewController(EducationsViewController(), animated: true)
    }
    
    @objc func experiencesNavigation(){
        navigationController?.pushViewController(ExperiencesViewController(), animated: true)
    }
    
    @objc func languagesNavigation(){
        navigationController?.pushViewController(LanguagesViewController(), animated: true)
    }
    private func loadFetchedImage(for url: String){
        fetchedImageView.loadImage(url)
    }
    
    @objc private func bookmarkMember(){
        self.user.isBookmarked.toggle()
        systemImageName = user.isBookmarked ? "bookmark.fill" :  "bookmark"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: self.systemImageName), style: .plain, target: self, action: #selector(bookmarkMember))
            
        self.inheritedUserUpdate(user)
    }
}

extension UIImageView {
    func loadImage(_ url: String){
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                guard let url = URL(string: url) else {
                    return
                }
                
                guard let data = try? Data(contentsOf: url) else {
                    return
                }
                
                self.image = UIImage(data: data)
            }
        }
    }
}


