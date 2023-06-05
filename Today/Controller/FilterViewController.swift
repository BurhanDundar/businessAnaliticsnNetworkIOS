//
//  FilterViewController.swift
//  Today
//
//  Created by Burhan Dündar on 4.03.2023.
//

import UIKit

class FilterViewController: UIViewController {
        
    var text: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = UIView()
        view.backgroundColor = .systemBackground //.white
        
        text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Burhan"
        text.textAlignment = .center
        
        view.addSubview(text)
        
        text.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        text.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
    }
}
