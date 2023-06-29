//
//  NotifyMeSheet.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 29.06.2023.
//

import UIKit

class NotifyMeSheet: UIViewController {
    
    var notifyMeTitle = UILabel()
    var notifyMeDescription = UILabel()
    var notifyMeSwitch = UISwitch()
    
    var full_name: String!
    init(full_name: String) {
        self.full_name = full_name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize NotifyMeSheet using init(reminder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI(){
        self.view.backgroundColor = .systemBackground
        
        self.notifyMeTitle.text = "Notify Me!"
        self.notifyMeTitle.font = .boldSystemFont(ofSize: 22)
        self.notifyMeTitle.textAlignment = .center
        self.notifyMeTitle.textColor = .systemBlue
        self.notifyMeTitle.numberOfLines = 0
        self.notifyMeTitle.sizeToFit()
        
        self.notifyMeDescription.text = "Send me report email if anything changes about \(self.full_name ?? "")"
        self.notifyMeDescription.font = .preferredFont(forTextStyle: .body, compatibleWith: .none)
        self.notifyMeDescription.textAlignment = .center
        self.notifyMeDescription.numberOfLines = 0
        self.notifyMeDescription.sizeToFit()
        
        self.notifyMeSwitch.setOn(false, animated: true)
        
        self.notifyMeTitle.translatesAutoresizingMaskIntoConstraints = false
        self.notifyMeDescription.translatesAutoresizingMaskIntoConstraints = false
        self.notifyMeSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.notifyMeTitle)
        self.view.addSubview(self.notifyMeDescription)
        self.view.addSubview(self.notifyMeSwitch)
        
        NSLayoutConstraint.activate([
            self.notifyMeTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
            self.notifyMeTitle.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            self.notifyMeTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.notifyMeDescription.topAnchor.constraint(equalTo: self.notifyMeTitle.bottomAnchor, constant: 20),
            self.notifyMeDescription.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            self.notifyMeDescription.centerXAnchor.constraint(equalTo: self.notifyMeTitle.centerXAnchor),
            
            self.notifyMeSwitch.topAnchor.constraint(equalTo: self.notifyMeDescription.bottomAnchor, constant: 20),
            self.notifyMeSwitch.centerXAnchor.constraint(equalTo: self.notifyMeDescription.centerXAnchor),
            
        ])
    }
}
