//
//  UserViewController.swift
//  Today
//
//  Created by Burhan Dündar on 10.02.2023.
//

import UIKit

class UserViewController: UIViewController,UIScrollViewDelegate {
    
    let parentView: UserListViewController
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
    
    var buttonCounter = 0

    var user: User
    init(user: User, parent: UserListViewController) {
        self.user = user
        self.parentView = parent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize UserViewController using init(reminder:)")
    }
    
    internal func inheritedUserUpdate(_ user: User){
        self.parentView.updateUser(user)
        self.parentView.collectionView.reloadData()
    }
    
    var nameLabel: UILabel! // bunlar UITextView mi yapılmalı bunlara bak
    var titleLabel: UILabel!
    var connectionCount: UILabel!
    var location: UILabel!
    var button: UIButton!
    var systemImageName: String!
    
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
    
    override func loadView() {
        
        // call functions at the beggining of launch
        self.getUserSkills()
        self.getUserExperiences()
        self.getUserEducations()
        self.getUserCourses()
        self.getUserLanguages()
        
        view = UIView()
        view.backgroundColor = .white
        
        systemImageName = user.isBookmarked ? "bookmark.fill" :  "bookmark"
        
        let bookmarkBarButton = UIBarButtonItem(image: UIImage(systemName: systemImageName), style: .plain, target: self, action: #selector(bookmarkMember))
        navigationItem.rightBarButtonItem = bookmarkBarButton
        
        view.addSubview(fetchedImageView)
        
        NSLayoutConstraint.activate([
            fetchedImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchedImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            fetchedImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            fetchedImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        loadFetchedImage(for: user.image ?? "")
    
        // Name
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.text = user.full_name
        
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: fetchedImageView.bottomAnchor,constant: 20),
            nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
                ])
        
        // Connection Count
        connectionCount = UILabel()
        connectionCount.translatesAutoresizingMaskIntoConstraints = false
        connectionCount.textAlignment = .center
        connectionCount.textColor = .gray
        connectionCount.numberOfLines = 0
        connectionCount.text = user.connection_count
        connectionCount.font = UIFont.systemFont(ofSize: 12)
        
        view.addSubview(connectionCount)
        
        NSLayoutConstraint.activate([
            connectionCount.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 10),
            connectionCount.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        //Location
        location = UILabel()
        location.translatesAutoresizingMaskIntoConstraints = false
        location.textAlignment = .center
        location.numberOfLines = 0
        location.text = user.location
        
        view.addSubview(location)
        
        NSLayoutConstraint.activate([
            location.topAnchor.constraint(equalTo: connectionCount.bottomAnchor, constant: 10),
            location.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        // Title
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = user.title
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: location.bottomAnchor,constant: 10),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
                ])
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationSetup()
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
    
    @objc private func bookmarkMember(){
        self.user.isBookmarked.toggle()
        systemImageName = self.user.isBookmarked ? "bookmark.fill" : "bookmark"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: self.systemImageName), style: .plain, target: self, action: #selector(bookmarkMember))
            
        self.inheritedUserUpdate(user)
    }
    
    private func getUserSkills(){
            let stringURL = "http://10.22.154.156:3001/skill/getUserSkills"
            
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
                            self.view.addSubview(self.skillsBtn)
                            self.skillsBtn.translatesAutoresizingMaskIntoConstraints = false
                            NSLayoutConstraint.activate([
                                self.skillsBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                self.skillsBtn.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant: CGFloat(topAnc)),
                                self.skillsBtn.widthAnchor.constraint(equalToConstant: 150)
                            ])
                            self.buttonCounter += 1
                        }
                        
                    }
                    
                } catch {
                    print("Skill verileri cekilemedi")
                }
                
            }
            
            session.resume()
        }
    private func getUserExperiences(){
            let stringURL = "http://10.22.154.156:3001/experience/getUserExperiences"
            
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
                            self.view.addSubview(self.experiencesBtn)
                            self.experiencesBtn.translatesAutoresizingMaskIntoConstraints = false
                            NSLayoutConstraint.activate([
                                self.experiencesBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                self.experiencesBtn.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant: CGFloat(topAnc)),
                                self.experiencesBtn.widthAnchor.constraint(equalToConstant: 150)
                            ])
                            self.buttonCounter += 1

                        }
                    }
                    
                } catch {
                    print("Experience verileri cekilemedi")
                }
                
            }
            
            session.resume()
        }
    private func getUserEducations(){
            let stringURL = "http://10.22.154.156:3001/education/getUserEducations"
            
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
                            self.view.addSubview(self.educationsBtn)
                            self.educationsBtn.translatesAutoresizingMaskIntoConstraints = false
                            NSLayoutConstraint.activate([
                                self.educationsBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                self.educationsBtn.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant: CGFloat(topAnc)),
                                self.educationsBtn.widthAnchor.constraint(equalToConstant: 150)
                            ])
                            self.buttonCounter += 1

                        }
                    }
                    
                } catch {
                    print("Education verileri cekilemedi")
                }
                
            }
            
            session.resume()
        }
    
    private func getUserCourses(){
            let stringURL = "http://10.22.154.156:3001/course/getUserCourses"
            
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
                            self.view.addSubview(self.coursesBtn)
                            self.coursesBtn.translatesAutoresizingMaskIntoConstraints = false
                            NSLayoutConstraint.activate([
                                self.coursesBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                self.coursesBtn.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant: CGFloat(topAnc)),
                                self.coursesBtn.widthAnchor.constraint(equalToConstant: 150)
                            ])
                            self.buttonCounter += 1

                        }
                    }
                    
                } catch {
                    print("Course verileri cekilemedi")
                }
                
            }
            
            session.resume()
        }
    
    private func getUserLanguages(){
            let stringURL = "http://10.22.154.156:3001/skill/getUserLanguages"
            
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
                            self.view.addSubview(self.languagesBtn)
                            self.languagesBtn.translatesAutoresizingMaskIntoConstraints = false
                            NSLayoutConstraint.activate([
                                self.languagesBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                self.languagesBtn.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant: CGFloat(topAnc)),
                                self.languagesBtn.widthAnchor.constraint(equalToConstant: 150)
                            ])
                            self.buttonCounter += 1

                        }
                    }
                } catch {
                    print("Language verileri cekilemedi")
                }
                
            }
            
            session.resume()
        }
    
    
    
    
}

extension UIImageView {
    func loadImage(_ url: String){
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


