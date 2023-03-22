//
//  AuthHeaderView.swift
//  Today
//
//  Created by Şerife Türksever on 21.03.2023.
//

import UIKit

class AuthHeaderView: UIView {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "egeLogo")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Error"
        title.textColor = .label
        title.textAlignment = .center
        title.font = .systemFont(ofSize: 26, weight: .bold )
        return title
    }()
    
    private let subTitleLabel: UILabel = {
        let subTitle = UILabel()
        subTitle.text = "Error"
        subTitle.textColor = .secondaryLabel
        subTitle.textAlignment = .center
        subTitle.font = .systemFont(ofSize: 18, weight: .regular )
        return subTitle
    }()
    
    init(title: String, subTitle: String){
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.subTitleLabel.text = subTitle
        self.setupUI()
        
        
    }
    
    private func setupUI() {
        self.addSubview(logoImageView)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.logoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            self.logoImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 90),
            self.logoImageView.heightAnchor.constraint(equalTo: self.logoImageView.widthAnchor),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 19),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.subTitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 12),
            self.subTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.subTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}




