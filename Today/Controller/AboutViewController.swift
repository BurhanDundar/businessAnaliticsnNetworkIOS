//
//  AboutViewController.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 20.06.2023.
//

import UIKit
import WebKit

class AboutViewController: UIViewController,UIScrollViewDelegate,UIWebViewDelegate, WKUIDelegate,WKNavigationDelegate {
    
    var egeUniTitleTxt = "Ege University Computer Engineering"
    var establishmentDate = "establishment date is 1970"
    var seeLinkedinPageOfDepartment = LinkedInButton(title: "Open User Linkedin Profile", image: UIImage(named: "linkedin_icon")!)
       var webView = WKWebView()
    
    var appInfoTitleTxt = "About App"
    var appDescription = "This app is created with swift and backend app that used with microservice architecture. We love using microservice architecture and swift because they are so fast and well designed! If you have any idea about this application or you want to share special something with us, please feel comfortable to contact with us. dundarrburhan@gmail.com is the email address 🥳🎉"
    
    var appPurposeTitleTxt = "App Purpose"
    var appPurpose = "This app is created for Ege University Computer Engineering members. Thanks to this application you can access the computer engineering member and learning so much thin about them. Members, users and companies can be saved and filtered successfully. You always should be in touch with your University family! 🎓"
    
    var specialThanksTitleTxt = "Special Thanks"
    var specialThanks = "This microservice app is created in a short time. We pushed ourselves and worked so hard. We achieve this because dear Birol Çiloğlugil gave us important lessons that is so much important for us. We have learnt so much from him and his effort. Thanks for all 👋"
    
    var appCreatorsTitleTxt = "App Creators"
    var appCreators = "This app is created by Şerife Türksever 👩🏼‍💻 & Burhan Dündar 👨🏽‍💻"
    
    var scrollView = UIScrollView(frame: UIScreen.main.bounds)
    var stackView = UIStackView()
    
    private let egeUniImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "egeLogo")
        return imageView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        super.viewDidLoad()
        self.setupUI()
        self.seeLinkedinPageOfDepartment.addTarget(self, action: #selector(openDepartmentLinkedinPage), for: .touchUpInside)
    }
    
    private func setupUI(){
        let egeUniTitleTxtLabel = UILabel()
        let establishmentDateLabel = UILabel()
        let appInfoTitleTxtLabel = UILabel()
        let appDescriptionLabel = UILabel()
        let appPurposeTitleTxtLabel = UILabel()
        let appPurposeLabel = UILabel()
        let specialThanksTitleTxtLabel = UILabel()
        let specialThanksLabel = UILabel()
        let appCreatorsTitleTxtLabel = UILabel()
        let appCreatorsLabel = UILabel()
        
        egeUniTitleTxtLabel.text = egeUniTitleTxt
        establishmentDateLabel.text = establishmentDate
        appInfoTitleTxtLabel.text = appInfoTitleTxt
        appDescriptionLabel.text = appDescription
        appPurposeTitleTxtLabel.text = appPurposeTitleTxt
        appPurposeLabel.text = appPurpose
        specialThanksTitleTxtLabel.text = specialThanksTitleTxt
        specialThanksLabel.text = specialThanks
        appCreatorsTitleTxtLabel.text = appCreatorsTitleTxt
        appCreatorsLabel.text = appCreators
        
        appDescriptionLabel.numberOfLines = 0
        appDescriptionLabel.sizeToFit()
        
        appPurposeLabel.numberOfLines = 0
        appPurposeLabel.sizeToFit()
        
        specialThanksTitleTxtLabel.numberOfLines = 0
        specialThanksTitleTxtLabel.sizeToFit()
        
        appCreatorsLabel.numberOfLines = 0
        appCreatorsLabel.sizeToFit()
        
        specialThanksLabel.numberOfLines = 0
        specialThanksLabel.sizeToFit()
        
        egeUniTitleTxtLabel.font = .boldSystemFont(ofSize: 18)
        appInfoTitleTxtLabel.font = .boldSystemFont(ofSize: 18)
        appPurposeTitleTxtLabel.font = .boldSystemFont(ofSize: 18)
        specialThanksTitleTxtLabel.font = .boldSystemFont(ofSize: 18)
        appCreatorsTitleTxtLabel.font = .boldSystemFont(ofSize: 18)
        
        establishmentDateLabel.textColor = .systemGray
        establishmentDateLabel.font = .preferredFont(forTextStyle: .footnote, compatibleWith: .current)
        
        
        self.egeUniImage.translatesAutoresizingMaskIntoConstraints = false
        egeUniTitleTxtLabel.translatesAutoresizingMaskIntoConstraints = false
        establishmentDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.seeLinkedinPageOfDepartment.translatesAutoresizingMaskIntoConstraints = false
        appInfoTitleTxtLabel.translatesAutoresizingMaskIntoConstraints = false
        appDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        appPurposeTitleTxtLabel.translatesAutoresizingMaskIntoConstraints = false
        appPurposeLabel.translatesAutoresizingMaskIntoConstraints = false
        specialThanksTitleTxtLabel.translatesAutoresizingMaskIntoConstraints = false
        specialThanksLabel.translatesAutoresizingMaskIntoConstraints = false
        appCreatorsTitleTxtLabel.translatesAutoresizingMaskIntoConstraints = false
        appCreatorsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.stackView)
        
        self.stackView.axis = .vertical
        self.stackView.alignment = .center
        self.stackView.spacing = 20
        
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 60).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        self.stackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, multiplier: 0.85).isActive = true
        self.stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.egeUniImage.widthAnchor.constraint(equalToConstant: 90).isActive = true
        self.egeUniImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        
        
        self.stackView.addArrangedSubview(self.egeUniImage)
        self.stackView.addArrangedSubview(egeUniTitleTxtLabel)
        self.stackView.addArrangedSubview(establishmentDateLabel)
        self.stackView.addArrangedSubview(self.seeLinkedinPageOfDepartment)
        self.stackView.addArrangedSubview(appInfoTitleTxtLabel)
        self.stackView.addArrangedSubview(appDescriptionLabel)
        self.stackView.addArrangedSubview(appPurposeTitleTxtLabel)
        self.stackView.addArrangedSubview(appPurposeLabel)
        self.stackView.addArrangedSubview(specialThanksTitleTxtLabel)
        self.stackView.addArrangedSubview(specialThanksLabel)
        self.stackView.addArrangedSubview(appCreatorsTitleTxtLabel)
        self.stackView.addArrangedSubview(appCreatorsLabel)
        
        self.seeLinkedinPageOfDepartment.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, multiplier: 0.85).isActive = true
        self.seeLinkedinPageOfDepartment.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    @objc func openDepartmentLinkedinPage(){
            let linkedInVC = UIViewController()
            webView.navigationDelegate = self
            
            linkedInVC.view.addSubview(webView)
            webView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                webView.topAnchor.constraint(equalTo: linkedInVC.view.topAnchor),
                webView.leadingAnchor.constraint(equalTo: linkedInVC.view.leadingAnchor),
                webView.bottomAnchor.constraint(equalTo: linkedInVC.view.bottomAnchor),
                webView.trailingAnchor.constraint(equalTo: linkedInVC.view.trailingAnchor)
                ])
            let url = URL(string: "https://www.linkedin.com/company/egebilmuh/")
            let request = URLRequest(url: url!)
            webView.load(request)
            
            // Create Navigation Controller
            let navController = UINavigationController(rootViewController: linkedInVC)
            let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
            linkedInVC.navigationItem.leftBarButtonItem = cancelButton
            let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshAction))
            linkedInVC.navigationItem.rightBarButtonItem = refreshButton
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navController.navigationBar.titleTextAttributes = textAttributes
            linkedInVC.navigationItem.title = "linkedin.com"
            navController.navigationBar.isTranslucent = false
            navController.navigationBar.tintColor = UIColor.black
            navController.navigationBar.barTintColor = UIColor.colorFromHex("#0072B1")
            navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen //overFullScreen
            navController.modalTransitionStyle = .coverVertical
            
            self.present(navController, animated: true, completion: nil)
        }
        
        @objc func cancelAction() {
            self.dismiss(animated: true, completion: nil)
        }

        @objc func refreshAction() {
            self.webView.reload()
        }
}
