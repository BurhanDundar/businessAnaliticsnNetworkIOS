//
//  LinkedInLoginButton.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 16.06.2023.
//

import UIKit
import WebKit

class LinkedInButton: UIButton {
    
    var title: String = ""
    var image: UIImage!
    
    init(title: String, image: UIImage){
        self.title = title
        self.image = image
        
        super.init(frame: .zero)
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        self.setTitle(self.title, for: .normal)
        self.setImage(self.image, for: .normal)
        
        self.backgroundColor = .systemBlue
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .disabled)
        self.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        
        //button.setBackgroundColor(.blue, for: .normal)
        //button.setBackgroundColor(UIColor.blue.withAlphaComponent(0.3), for: .disabled)
    }
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}
