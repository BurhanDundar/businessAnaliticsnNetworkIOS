//
//  BookmarkViewController.swift
//  Today
//
//  Created by Burhan Dündar on 4.03.2023.
//

import UIKit

class CompanyViewController: UIViewController {
    
    var tryButton = CustomButton(title: "Burada Çalışanları Gör", hasBackground: true ,fontSize: .med)
    
    var company: Company?
    /*init(company: Company) {
        self.company = company
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize UserViewController using init(reminder:)")
    }*/
    
    lazy var fetchedImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.masksToBounds = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .orange
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.blue.cgColor
        iv.layer.cornerRadius = iv.frame.size.height/2
        iv.clipsToBounds = true
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let defaults = UserDefaults.standard
        //let age = defaults.integer(forKey: "Age")
        
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //let  namee = appDelegate.userName as! String
        //let  idd = appDelegate.userid as! String
        
        //print(namee ?? "")
        //print(idd ?? "")
        //print(age)
                
        view.backgroundColor = .systemBackground //.white
        
        let companyName = UILabel()
        companyName.text = company?.name
        
        fetchedImageView.translatesAutoresizingMaskIntoConstraints = false
        tryButton.translatesAutoresizingMaskIntoConstraints = false
        companyName.translatesAutoresizingMaskIntoConstraints = false
        
        loadFetchedImage(for: company?.image ?? "")
        
        self.view.addSubview(fetchedImageView)
        self.view.addSubview(companyName)
        self.view.addSubview(self.tryButton)
        
        
        NSLayoutConstraint.activate([
            fetchedImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchedImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 40),
            fetchedImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            fetchedImageView.heightAnchor.constraint(equalToConstant: 200),
            
            companyName.centerXAnchor.constraint(equalTo: self.fetchedImageView.centerXAnchor),
            companyName.topAnchor.constraint(equalTo: self.fetchedImageView.bottomAnchor, constant: 100),
            
            self.tryButton.topAnchor.constraint(equalTo: companyName.bottomAnchor, constant: 100),
            self.tryButton.centerXAnchor.constraint(equalTo: companyName.centerXAnchor),
            self.tryButton.heightAnchor.constraint(equalToConstant: 55),
            self.tryButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75)
        ])
        
        self.tryButton.addTarget(self, action: #selector(go), for: .touchUpInside)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if (segue.identifier == "Burhan") {
          let userListVC = segue.destination as! UserListViewController
           let object = sender as! [String: Company.ID?]
           userListVC.company_id = object["company_id"] as! Company.ID
       }
    }
    
    @objc private func go(_ sender: Any){
        let sender: [String: Company.ID?] = [ "company_id": company?.id ]
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "Burhan", sender: sender)
        }
    }
    
    private func loadFetchedImage(for url: String){
        fetchedImageView.loadImage(url)
    }
    
    
}