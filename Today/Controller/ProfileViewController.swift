//
//  ProfileViewController.swift
//  Today
//
//  Created by Şerife Türksever on 30.05.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    lazy var fetchedImageView: UIImageView = {
        /*let iv = UIImageView(frame: CGRectMake(0, 0, 100, 100))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .systemBackground
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.systemBlue.cgColor
        iv.layer.cornerRadius = CGRectGetWidth(iv.frame) / 2
        iv.layer.masksToBounds = false
        iv.clipsToBounds = true*/
        
        let myImageView:UIImageView = UIImageView()
                myImageView.contentMode = .scaleAspectFill
                myImageView.frame.size.width = 200
                myImageView.frame.size.height = 200
                myImageView.center = self.view.center
                
                    
                // Make Image Corners Rounded
                myImageView.layer.cornerRadius = myImageView.frame.size.width / 2
                myImageView.clipsToBounds = true
                myImageView.layer.borderWidth = 1
                myImageView.layer.borderColor = UIColor.lightGray.cgColor
        return myImageView
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func loadFetchedImage(for url: String){
        self.fetchedImageView.loadImage(url)
    }
    
    
    
    func setupUI(){
        
        
        
        let scrollView = UIScrollView()
        self.view?.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        self.view?.backgroundColor = .systemBackground
       
        stackView.addArrangedSubview(self.fetchedImageView)
        
        NSLayoutConstraint.activate([
            fetchedImageView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            fetchedImageView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 100),
            fetchedImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.6),
            fetchedImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        let urlString = "data:image/jpeg;base64,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"
        
        loadFetchedImage(for: urlString)
    }
}
