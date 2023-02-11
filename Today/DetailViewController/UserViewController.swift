//
//  UserViewController.swift
//  Today
//
//  Created by Burhan Dündar on 10.02.2023.
//

import UIKit

class UserViewController: UIViewController {
    
    var user: User
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize UserViewController using init(reminder:)")
    }
    
    var imageView: UIImageView!
    var nameLabel: UILabel! // bunlar UITextView mi yapılmalı bunlara bak
    var titleLabel: UILabel!
    var connectionCount: UILabel!
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        
        
        // Image
        // imageView.loadImage(for: user.image)
        imageView = UIImageView(image: UIImage(named: "murat.png")!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // border radius
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.blue.cgColor
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
        // shadow
        //imageView.layer.shadowColor = UIColor.black.cgColor
        //imageView.layer.shadowOpacity = 1
        //imageView.layer.shadowOffset = CGSize.zero
        //imageView.layer.shadowRadius = 10
        //imageView.layer.shadowPath = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: 10).cgPath
        
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20)
        ])
    
        // Name
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.text = user.full_name
        
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 20),
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
        
        // Title
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = user.title
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: connectionCount.bottomAnchor,constant: 10),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
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
}


