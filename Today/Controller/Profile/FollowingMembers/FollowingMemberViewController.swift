//
//  FollowingMemberViewController.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 13.06.2023.
//

import UIKit

class FollowingMemberViewController: UIViewController {
    
    var buttonCounter = 0
    var member: Member?
    
    var fullnameLabel = UILabel()
    var usernameLabel = UILabel()
    
    lazy var fetchedImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.blue.cgColor
        iv.layer.cornerRadius = iv.frame.size.height/2
        iv.clipsToBounds = true
        return iv
    }()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        view.addSubview(fetchedImageView)
        NSLayoutConstraint.activate([
            fetchedImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchedImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            fetchedImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            fetchedImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // Name
        self.fullnameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.fullnameLabel.textAlignment = .center
        self.fullnameLabel.numberOfLines = 0
        self.fullnameLabel.text = self.member?.fullname
        
        view.addSubview(self.fullnameLabel)
        
        NSLayoutConstraint.activate([
            self.fullnameLabel.topAnchor.constraint(equalTo: fetchedImageView.bottomAnchor,constant: 20),
            self.fullnameLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        
        //Location
        self.usernameLabel = UILabel()
        self.usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.usernameLabel.textAlignment = .center
        self.usernameLabel.numberOfLines = 0
        self.usernameLabel.text = self.member?.username
        
        view.addSubview(self.usernameLabel)
        
        NSLayoutConstraint.activate([
            self.usernameLabel.topAnchor.constraint(equalTo: self.fullnameLabel.bottomAnchor, constant: 10),
            self.usernameLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
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
        navigationItem.title = NSLocalizedString("Following Member", comment: "Following member view controller title")
    }
    private func loadFetchedImage(for url: String){
        fetchedImageView.loadImage(url)
    }
}
