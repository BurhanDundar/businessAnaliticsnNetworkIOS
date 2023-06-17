//
//  UserViewController.swift
//  Today
//
//  Created by Burhan Dündar on 10.02.2023.
//

import UIKit
import WebKit

class UserViewController: UIViewController,UIScrollViewDelegate,UIWebViewDelegate, WKUIDelegate,WKNavigationDelegate {
    
    var skills: [Skill] = [Skill]()
    var experiences: [Experience] = [Experience]()
    var educations: [Education] = [Education]()
    var courses: [Course] = [Course]()
    var languages: [Language] = [Language]()
    
    private let skillsBtn = CustomButton(title: "Skills", hasBackground: true, fontSize: .med)
    private let experiencesBtn = CustomButton(title: "Experiences", hasBackground: true, fontSize: .med)
    private let educationsBtn = CustomButton(title: "Educations", hasBackground: true, fontSize: .med)
    private let coursesBtn = CustomButton(title: "Courses", hasBackground: true, fontSize: .med)
    private let languagesBtn = CustomButton(title: "Languages", hasBackground: true, fontSize: .med)
    
    var openUserProfileLinkedInPageBtn = LinkedInButton(title: "Open User Linkedin Profile", image: UIImage(named: "linkedin_icon")!)
    var webView = WKWebView()
    
    var buttonCounter = 0

    var isUserBookmarked: Bool
    var user: User
    init(user: User, isUserBookmarked: Bool) {
        self.user = user
        self.isUserBookmarked = isUserBookmarked
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize UserViewController using init(reminder:)")
    }
    
    var nameLabel: UILabel! // bunlar UITextView mi yapılmalı bunlara bak
    var titleLabel: UILabel!
    var connectionCount: UILabel!
    var location: UILabel!
    var button: UIButton!
    var systemImageName: String!
    var scrollView = UIScrollView()
    var stackView = UIStackView()
    
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
        
        // call functions at the beggining of launch
        self.getUserSkills()
        self.getUserExperiences()
        self.getUserEducations()
        self.getUserCourses()
        self.getUserLanguages()
        
        skillsBtn.addTarget(self, action: #selector(showUserSkills), for: .touchUpInside)
        experiencesBtn.addTarget(self, action: #selector(showUserExperiences), for: .touchUpInside)
        educationsBtn.addTarget(self, action: #selector(showUserEducations), for: .touchUpInside)
        coursesBtn.addTarget(self, action: #selector(showUserCourses), for: .touchUpInside)
        languagesBtn.addTarget(self, action: #selector(showUserLanguages), for: .touchUpInside)
        self.openUserProfileLinkedInPageBtn.addTarget(self, action: #selector(setUserLinkedInProfileView), for: .touchUpInside)
        
        view = UIView()
        view.backgroundColor = .systemBackground
    
//        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 400)
        scrollView.backgroundColor = .red
        self.view.addSubview(self.scrollView)
        
        
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
        
        self.scrollView.addSubview(self.stackView)
        
        self.stackView.axis = .vertical
        self.stackView.alignment = .center
        self.stackView.spacing = 10
        
        self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        self.stackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        systemImageName = self.isUserBookmarked ? "bookmark.fill" :  "bookmark"
        
        let bookmarkBarButton = UIBarButtonItem(image: UIImage(systemName: systemImageName), style: .plain, target: self, action: #selector(bookmarkUser))
        navigationItem.rightBarButtonItem = bookmarkBarButton
        self.stackView.addArrangedSubview(fetchedImageView)
        
        loadFetchedImage(for: user.image ?? "")
    
        // Name
        nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.text = user.full_name
        
        // Connection Count
        connectionCount = UILabel()
        connectionCount.textAlignment = .center
        connectionCount.textColor = .gray
        connectionCount.numberOfLines = 0
        connectionCount.text = user.connection_count
        connectionCount.font = UIFont.systemFont(ofSize: 12)
        
        //Location
        location = UILabel()
        location.textAlignment = .center
        location.numberOfLines = 0
        location.text = user.location
        
        // Title
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = user.title
        
        
        self.stackView.addArrangedSubview(nameLabel)
        self.stackView.addArrangedSubview(connectionCount)
        self.stackView.addArrangedSubview(location)
        self.stackView.addArrangedSubview(titleLabel)
        self.stackView.addArrangedSubview(openUserProfileLinkedInPageBtn)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        connectionCount.translatesAutoresizingMaskIntoConstraints = false
        location.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        openUserProfileLinkedInPageBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.fetchedImageView.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor),
            self.fetchedImageView.topAnchor.constraint(equalTo: self.stackView.topAnchor, constant: 60),
            self.fetchedImageView.widthAnchor.constraint(equalTo: self.stackView.widthAnchor, multiplier: 0.6),
            self.fetchedImageView.heightAnchor.constraint(equalToConstant: 200),
            
            self.nameLabel.topAnchor.constraint(equalTo: self.fetchedImageView.bottomAnchor,constant: 20),
            self.nameLabel.widthAnchor.constraint(equalTo: self.stackView.widthAnchor),
            
            self.connectionCount.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor,constant: 10),
            self.connectionCount.widthAnchor.constraint(equalTo: self.stackView.widthAnchor),
            
            self.location.topAnchor.constraint(equalTo: self.connectionCount.bottomAnchor, constant: 10),
            self.location.widthAnchor.constraint(equalTo: self.stackView.widthAnchor),
            
            
            self.titleLabel.topAnchor.constraint(equalTo: self.location.bottomAnchor,constant: 10),
            self.titleLabel.widthAnchor.constraint(equalTo: self.stackView.widthAnchor),
            
            self.openUserProfileLinkedInPageBtn.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 20),
            self.openUserProfileLinkedInPageBtn.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor),
            self.openUserProfileLinkedInPageBtn.widthAnchor.constraint(equalTo: self.stackView.widthAnchor, multiplier: 0.85),
            self.openUserProfileLinkedInPageBtn.heightAnchor.constraint(equalToConstant: 55)
                ])
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationSetup()
    }
    
    @objc func setUserLinkedInProfileView(){
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
        let url = URL(string: self.user.profileLink!) // "https://www.linkedin.com/in/burhan-d%C3%BCndar-9a8787256/"
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
    
    func navigationSetup(){
        // Navigation
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }
        navigationItem.title = NSLocalizedString("User", comment: "User view controller title")
    }
    
    @objc func skillsNavigation(){
        print("merhaba")
    }
    
    private func loadFetchedImage(for url: String){
        fetchedImageView.loadImage(url)
    }
    
    @objc private func bookmarkUser(){
        self.isUserBookmarked.toggle()
        systemImageName = self.isUserBookmarked ? "bookmark.fill" : "bookmark"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: self.systemImageName), style: .plain, target: self, action: #selector(bookmarkUser))
        
        if let memberId = UserDefaults.standard.string(forKey: "memberId") {
            self.updateMemberFavourite(who: memberId, whom: user.id!, with: "user")
        }
    }
    
    
    
    private func getUserSkills(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stringURL = "\(appDelegate.APIURL)/skill/getUserSkills"
                    
            let params = [
                "user_id": self.user.id
            ]
        
            guard let url = URL(string: stringURL) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            
            let session = URLSession.shared.dataTask(with: request) { data, response, error in
            
                guard let data = data else { return }
                
                if let error = error {
                    print("there was an error: \(error.localizedDescription)")
                }
                
                do {
                    let decoder = JSONDecoder()
                    let userSkillsRes = try decoder.decode([Skill].self, from: data)
                    DispatchQueue.main.async {
                        self.skills = userSkillsRes
                        if self.skills.count > 0{
                            var topAnc = (self.buttonCounter + 1) * 40
                            self.stackView.addSubview(self.skillsBtn)
                            self.skillsBtn.translatesAutoresizingMaskIntoConstraints = false
                            NSLayoutConstraint.activate([
                                self.skillsBtn.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor),
                                self.skillsBtn.topAnchor.constraint(equalTo: self.openUserProfileLinkedInPageBtn.bottomAnchor,constant: CGFloat(topAnc)),
                                self.skillsBtn.widthAnchor.constraint(equalToConstant: 150)
                            ])
                            self.buttonCounter += 1
                            /*let defaults = UserDefaults.standard
                            defaults.set(self.skills, forKey: "userSkills")*/
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.userSkills = self.skills
                        }
                        
                    }
                    
                } catch {
                    print("Skill verileri cekilemedi")
                }
                
            }
            
            session.resume()
        }
    private func getUserExperiences(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stringURL = "\(appDelegate.APIURL)/experience/getUserExperiences"
        
            
            let params = [
                "user_id": self.user.id
            ]
        
            guard let url = URL(string: stringURL) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            
            let session = URLSession.shared.dataTask(with: request) { data, response, error in
            
                guard let data = data else { return }
                
                if let error = error {
                    print("there was an error: \(error.localizedDescription)")
                }
                
                do {
                    let decoder = JSONDecoder()
                    let userExperiencesRes = try decoder.decode([Experience].self, from: data)
                    DispatchQueue.main.async {
                        self.experiences = userExperiencesRes
                        if self.experiences.count > 0{
                            var topAnc = (self.buttonCounter + 1) * 40
                            self.stackView.addSubview(self.experiencesBtn)
                            self.experiencesBtn.translatesAutoresizingMaskIntoConstraints = false
                            NSLayoutConstraint.activate([
                                self.experiencesBtn.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor),
                                self.experiencesBtn.topAnchor.constraint(equalTo: self.openUserProfileLinkedInPageBtn.bottomAnchor,constant: CGFloat(topAnc)),
                                self.experiencesBtn.widthAnchor.constraint(equalToConstant: 150)
                            ])
                            self.buttonCounter += 1
                            
                        }
                        //let defaults = UserDefaults.standard
                        //defaults.set(self.experiences, forKey: "userExperiences")
                        /*if let encoded = try? JSONEncoder().encode([Experience]) {
                            UserDefaults.standard.set(encoded, forKey: "userExperiences")
                        }*/
                    }
                    
                } catch {
                    print("Experience verileri cekilemedi")
                }
                
            }
            
            session.resume()
        }
    private func getUserEducations(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stringURL = "\(appDelegate.APIURL)/education/getUserEducations"
            let params = [
                "user_id": self.user.id
            ]
        
            guard let url = URL(string: stringURL) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            
            let session = URLSession.shared.dataTask(with: request) { data, response, error in
            
                guard let data = data else { return }
                
                if let error = error {
                    print("there was an error: \(error.localizedDescription)")
                }
                
                do {
                    let decoder = JSONDecoder()
                    let userEducationsRes = try decoder.decode([Education].self, from: data)
                    DispatchQueue.main.async {
                        self.educations = userEducationsRes
                        if self.educations.count > 0{
                            var topAnc = (self.buttonCounter + 1) * 40
                            self.stackView.addSubview(self.educationsBtn)
                            self.educationsBtn.translatesAutoresizingMaskIntoConstraints = false
                            NSLayoutConstraint.activate([
                                self.educationsBtn.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor),
                                self.educationsBtn.topAnchor.constraint(equalTo: self.openUserProfileLinkedInPageBtn.bottomAnchor,constant: CGFloat(topAnc)),
                                self.educationsBtn.widthAnchor.constraint(equalToConstant: 150)
                            ])
                            self.buttonCounter += 1
                            /*let defaults = UserDefaults.standard
                            defaults.set(self.educations, forKey: "userEducations")*/
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.userEducations = self.educations
                        }
                    }
                    
                } catch {
                    print("Education verileri cekilemedi")
                }
                
            }
            
            session.resume()
        }
    
    private func getUserCourses(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stringURL = "\(appDelegate.APIURL)/course/getUserCourses"
            
            let params = [
                "user_id": self.user.id
            ]
        
            guard let url = URL(string: stringURL) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            
            let session = URLSession.shared.dataTask(with: request) { data, response, error in
            
                guard let data = data else { return }
                
                if let error = error {
                    print("there was an error: \(error.localizedDescription)")
                }
                
                do {
                    let decoder = JSONDecoder()
                    let userCoursesRes = try decoder.decode([Course].self, from: data)
                    DispatchQueue.main.async {
                        self.courses = userCoursesRes
                        if self.courses.count > 0{
                            var topAnc = (self.buttonCounter + 1) * 40
                            self.stackView.addSubview(self.coursesBtn)
                            self.coursesBtn.translatesAutoresizingMaskIntoConstraints = false
                            NSLayoutConstraint.activate([
                                self.coursesBtn.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor),
                                self.coursesBtn.topAnchor.constraint(equalTo: self.openUserProfileLinkedInPageBtn.bottomAnchor,constant: CGFloat(topAnc)),
                                self.coursesBtn.widthAnchor.constraint(equalToConstant: 150)
                            ])
                            self.buttonCounter += 1
                            /*let defaults = UserDefaults.standard
                            defaults.set(self.courses, forKey: "userCourses")*/
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.userCourses = self.courses
                        }
                    }
                    
                } catch {
                    print("Course verileri cekilemedi")
                }
                
            }
            
            session.resume()
        }
    
    private func getUserLanguages(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stringURL = "\(appDelegate.APIURL)/language/getUserLanguages"

        
            let params = [
                "user_id": self.user.id
            ]
        
            guard let url = URL(string: stringURL) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            
            let session = URLSession.shared.dataTask(with: request) { data, response, error in
            
                guard let data = data else { return }
                
                if let error = error {
                    print("there was an error: \(error.localizedDescription)")
                }
                
                do {
                    let decoder = JSONDecoder()
                    let userLanguagesRes = try decoder.decode([Language].self, from: data)
                    DispatchQueue.main.async {
                        self.languages = userLanguagesRes
                        if self.languages.count > 0{
                            var topAnc = (self.buttonCounter + 1) * 40
                            self.stackView.addSubview(self.languagesBtn)
                            self.languagesBtn.translatesAutoresizingMaskIntoConstraints = false
                            NSLayoutConstraint.activate([
                                self.languagesBtn.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor),
                                self.languagesBtn.topAnchor.constraint(equalTo: self.openUserProfileLinkedInPageBtn.bottomAnchor,constant: CGFloat(topAnc)),
                                self.languagesBtn.widthAnchor.constraint(equalToConstant: 150)
                            ])
                            self.buttonCounter += 1
                            /*let defaults = UserDefaults.standard
                            defaults.set(self.languages, forKey: "userLanguages")*/
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.userLanguages = self.languages

                        }
                    }
                } catch {
                    print("Language verileri cekilemedi")
                }
                
            }
            
            session.resume()
        }
    
    @objc private func showUserSkills(_ Sender: Any){
        let skillsVC = SkillListViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(skillsVC, animated: true)
    }
    @objc private func showUserExperiences(_ Sender: Any){
        let experiencesVC = ExperienceListViewController(experiences: self.experiences)
        navigationController?.pushViewController(experiencesVC, animated: true)
    }
    @objc private func showUserEducations(_ Sender: Any){
        let educationsVC = EducationListViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(educationsVC, animated: true)
    }
    @objc private func showUserCourses(_ Sender: Any){
        let coursesVC = CourseListViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(coursesVC, animated: true)
    }
    @objc private func showUserLanguages(_ Sender: Any){
        let languagesVC = LanguageListViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(languagesVC, animated: true)
    }
    
    
    
}

extension UIImageView {
    func loadImage(_ url: String, _ type: String = "user"){
        
        if(!url.contains("https://media.licdn.com/dms/image")){
            if(type == "company"){
                self.image = UIImage(systemName: "building.fill")
                return
            } else {
                self.image = UIImage(systemName: "person.circle")
                return
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                guard let url = URL(string: url) else {
                    return
                }
                
                guard let data = try? Data(contentsOf: url) else {
                    return
                }
                
                self.image = UIImage(data: data)
            }
        }
    }
}


extension UIViewController {
    func updateMemberFavourite(who following: String, whom followed: String, with fav_type: String){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stringURL = "\(appDelegate.APIURL)/favourite/update"
        
            let params = [
                "user_id": following,
                "fav_id": followed,
                "fav_type": fav_type
            ]
        
            guard let url = URL(string: stringURL) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            
            let session = URLSession.shared.dataTask(with: request) { data, response, error in
            
                guard let data = data else { return }
                
                if let error = error {
                    print("there was an error: \(error.localizedDescription)")
                }
                
                do {
                    let decoder = JSONDecoder()
                    let UpdateMemberResponse = try decoder.decode(String.self, from: data)
                    print(UpdateMemberResponse)
                } catch {
                    print("Skill verileri cekilemedi")
                }
                
            }
            
            session.resume()
        
    }
}
