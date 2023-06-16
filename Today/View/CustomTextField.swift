//
//  CustomTextField.swift
//  Today
//
//  Created by Şerife Türksever on 21.03.2023.
//

import UIKit

class CustomTextField: UITextField {
    
    enum CustomTextFieldType {
        case name
        case surname
        case username
        case fullname
        case email
        case oldPassword
        case password
        case repassword
        case skills
        case experiences
        case languages
    }
    
    private let authFieldType: CustomTextFieldType
    
    init(fieldType: CustomTextFieldType) {
        self.authFieldType = fieldType
        super.init(frame: .zero)
        
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 10
        
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x:0, y:0,width: 12, height: self.frame.size.height))
        
        switch fieldType {
        case .name:
            self.placeholder = "Name"
        case .surname:
            self.placeholder = "Surname"
        case .username:
            self.placeholder = "Username"
        case .fullname:
            self.placeholder = "Fullname"
        case .email:
            self.placeholder = "Email Address"
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
        case .password:
            self.placeholder = "Password"
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
        case .oldPassword:
            self.placeholder = "Old Password"
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
        case .repassword:
            self.placeholder = "Repassword"
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
        case .skills:
            self.placeholder = "Skills"
        case .experiences:
            self.placeholder = "Experiences"
        case .languages:
            self.placeholder = "Languages"
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
