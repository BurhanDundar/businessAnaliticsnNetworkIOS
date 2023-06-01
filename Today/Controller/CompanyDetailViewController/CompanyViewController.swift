//
//  BookmarkViewController.swift
//  Today
//
//  Created by Burhan Dündar on 4.03.2023.
//

import UIKit

class CompanyViewController: UIViewController {
    
    var tryButton = CustomButton(title: "try", hasBackground: true ,fontSize: .med)
    
    var company: Company
    init(company: Company) {
        self.company = company
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize UserViewController using init(reminder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
            
        tryButton.translatesAutoresizingMaskIntoConstraints = false
        //var text = UILabel()
        //text.translatesAutoresizingMaskIntoConstraints = false
        //text.text = company.name
        
        self.view.addSubview(self.tryButton)
        
        self.tryButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.tryButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.tryButton.addTarget(self, action: #selector(go), for: .touchUpInside)
    }
    
    @objc private func go(_ sender: Any){
        print("Burhan")
    }
    
    
}
