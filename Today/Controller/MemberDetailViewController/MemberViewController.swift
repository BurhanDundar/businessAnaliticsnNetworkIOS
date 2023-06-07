//
//  MemberViewController.swift
//  Today
//
//  Created by Şerife Türksever on 7.06.2023.
//

import UIKit

class MemberViewController: UIViewController,UIScrollViewDelegate {
    
    let parentView: MemberListViewController
//    var skills: [Skill] = [Skill]()
//    var experiences: [Experience] = [Experience]()
//    var educations: [Education] = [Education]()
//    var courses: [Course] = [Course]()
//    var languages: [Language] = [Language]()
    
//    private let skillsBtn = CustomButton(title: "Skills", hasBackground: true, fontSize: .med)
//    private let experiencesBtn = CustomButton(title: "Experiences", hasBackground: true, fontSize: .med)
//    private let educationsBtn = CustomButton(title: "Educations", hasBackground: true, fontSize: .med)
//    private let coursesBtn = CustomButton(title: "Courses", hasBackground: true, fontSize: .med)
//    private let languagesBtn = CustomButton(title: "Languages", hasBackground: true, fontSize: .med)
//
    var buttonCounter = 0

    var member: Member
    init(member: Member, parent: MemberListViewController) {
        self.member = member
        self.parentView = parent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize UserViewController using init(reminder:)")
    }
    
    internal func inheritedMemberUpdate(_ member: Member){
        self.parentView.updateMember(member)
        self.parentView.collectionView.reloadData()
    }
    
    var fullnameLabel: UILabel! // bunlar UITextView mi yapılmalı bunlara bak
    var usernameLabel: UILabel!
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
//        self.getUserSkills()
//        self.getUserExperiences()
//        self.getUserEducations()
//        self.getUserCourses()
//        self.getUserLanguages()
//
//        skillsBtn.addTarget(self, action: #selector(showUserSkills), for: .touchUpInside)
//        experiencesBtn.addTarget(self, action: #selector(showUserExperiences), for: .touchUpInside)
//        educationsBtn.addTarget(self, action: #selector(showUserEducations), for: .touchUpInside)
//        coursesBtn.addTarget(self, action: #selector(showUserCourses), for: .touchUpInside)
//        languagesBtn.addTarget(self, action: #selector(showUserLanguages), for: .touchUpInside)
//
        view = UIView()
        view.backgroundColor = .systemBackground
        
        systemImageName = member.isBookmarked ? "bookmark.fill" :  "bookmark"
        
        let bookmarkBarButton = UIBarButtonItem(image: UIImage(systemName: systemImageName), style: .plain, target: self, action: #selector(bookmarkMember))
        navigationItem.rightBarButtonItem = bookmarkBarButton
        
        view.addSubview(fetchedImageView)
        
        NSLayoutConstraint.activate([
            fetchedImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchedImageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            fetchedImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            fetchedImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
//        loadFetchedImage(for: member.image ?? "")
    
        // Name
        fullnameLabel = UILabel()
        fullnameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullnameLabel.textAlignment = .center
        fullnameLabel.numberOfLines = 0
        fullnameLabel.text = member.fullname
        
        view.addSubview(fullnameLabel)
        
        NSLayoutConstraint.activate([
            fullnameLabel.topAnchor.constraint(equalTo: fetchedImageView.bottomAnchor,constant: 20),
            fullnameLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
                ])
    
        
        //Location
        usernameLabel = UILabel()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.textAlignment = .center
        usernameLabel.numberOfLines = 0
        usernameLabel.text = member.username
        
        view.addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: fullnameLabel.bottomAnchor, constant: 10),
            usernameLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
//
//        // Title
//        titleLabel = UILabel()
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.numberOfLines = 0
//        titleLabel.textAlignment = .center
//        titleLabel.text = member.title
//
//        view.addSubview(titleLabel)
//
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: location.bottomAnchor,constant: 10),
//            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
//                ])
        

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
    
//    @objc func skillsNavigation(){
//        print("merhaba")
//    }
//
    private func loadFetchedImage(for url: String){
        fetchedImageView.loadImage(url)
    }
    
    @objc private func bookmarkMember(){
        self.member.isBookmarked.toggle()
        systemImageName = self.member.isBookmarked ? "bookmark.fill" : "bookmark"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: self.systemImageName), style: .plain, target: self, action: #selector(bookmarkMember))
            
        self.inheritedMemberUpdate(member)
    }
    
//    private func getUserSkills(){
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let stringURL = "\(appDelegate.APIURL)/skill/getUserSkills"
//
//            let params = [
//                "user_id": self.user.id
//            ]
//
//            guard let url = URL(string: stringURL) else { return }
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
//
//            let session = URLSession.shared.dataTask(with: request) { data, response, error in
//
//                guard let data = data else { return }
//
//                if let error = error {
//                    print("there was an error: \(error.localizedDescription)")
//                }
//
//                do {
//                    let decoder = JSONDecoder()
//                    let userSkillsRes = try decoder.decode([Skill].self, from: data)
//                    DispatchQueue.main.async {
//                        self.skills = userSkillsRes
//                        if self.skills.count > 0{
//                            var topAnc = (self.buttonCounter + 1) * 40
//                            self.view.addSubview(self.skillsBtn)
//                            self.skillsBtn.translatesAutoresizingMaskIntoConstraints = false
//                            NSLayoutConstraint.activate([
//                                self.skillsBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//                                self.skillsBtn.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant: CGFloat(topAnc)),
//                                self.skillsBtn.widthAnchor.constraint(equalToConstant: 150)
//                            ])
//                            self.buttonCounter += 1
//                            /*let defaults = UserDefaults.standard
//                            defaults.set(self.skills, forKey: "userSkills")*/
//
//                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                            appDelegate.userSkills = self.skills
//                        }
//
//                    }
//
//                } catch {
//                    print("Skill verileri cekilemedi")
//                }
//
//            }
//
//            session.resume()
//        }
//    private func getUserExperiences(){
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let stringURL = "\(appDelegate.APIURL)/experience/getUserExperiences"
//
//
//            let params = [
//                "user_id": self.user.id
//            ]
//
//            guard let url = URL(string: stringURL) else { return }
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
//
//            let session = URLSession.shared.dataTask(with: request) { data, response, error in
//
//                guard let data = data else { return }
//
//                if let error = error {
//                    print("there was an error: \(error.localizedDescription)")
//                }
//
//                do {
//                    let decoder = JSONDecoder()
//                    let userExperiencesRes = try decoder.decode([Experience].self, from: data)
//                    DispatchQueue.main.async {
//                        self.experiences = userExperiencesRes
//                        if self.experiences.count > 0{
//                            var topAnc = (self.buttonCounter + 1) * 40
//                            self.view.addSubview(self.experiencesBtn)
//                            self.experiencesBtn.translatesAutoresizingMaskIntoConstraints = false
//                            NSLayoutConstraint.activate([
//                                self.experiencesBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//                                self.experiencesBtn.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant: CGFloat(topAnc)),
//                                self.experiencesBtn.widthAnchor.constraint(equalToConstant: 150)
//                            ])
//                            self.buttonCounter += 1
//
//                        }
//                        //let defaults = UserDefaults.standard
//                        //defaults.set(self.experiences, forKey: "userExperiences")
//                        /*if let encoded = try? JSONEncoder().encode([Experience]) {
//                            UserDefaults.standard.set(encoded, forKey: "userExperiences")
//                        }*/
//                    }
//
//                } catch {
//                    print("Experience verileri cekilemedi")
//                }
//
//            }
//
//            session.resume()
//        }
//    private func getUserEducations(){
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let stringURL = "\(appDelegate.APIURL)/education/getUserEducations"
//            let params = [
//                "user_id": self.user.id
//            ]
//
//            guard let url = URL(string: stringURL) else { return }
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
//
//            let session = URLSession.shared.dataTask(with: request) { data, response, error in
//
//                guard let data = data else { return }
//
//                if let error = error {
//                    print("there was an error: \(error.localizedDescription)")
//                }
//
//                do {
//                    let decoder = JSONDecoder()
//                    let userEducationsRes = try decoder.decode([Education].self, from: data)
//                    DispatchQueue.main.async {
//                        self.educations = userEducationsRes
//                        if self.educations.count > 0{
//                            var topAnc = (self.buttonCounter + 1) * 40
//                            self.view.addSubview(self.educationsBtn)
//                            self.educationsBtn.translatesAutoresizingMaskIntoConstraints = false
//                            NSLayoutConstraint.activate([
//                                self.educationsBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//                                self.educationsBtn.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant: CGFloat(topAnc)),
//                                self.educationsBtn.widthAnchor.constraint(equalToConstant: 150)
//                            ])
//                            self.buttonCounter += 1
//                            /*let defaults = UserDefaults.standard
//                            defaults.set(self.educations, forKey: "userEducations")*/
//
//                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                            appDelegate.userEducations = self.educations
//                        }
//                    }
//
//                } catch {
//                    print("Education verileri cekilemedi")
//                }
//
//            }
//
//            session.resume()
//        }
//
//    private func getUserCourses(){
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let stringURL = "\(appDelegate.APIURL)/course/getUserCourses"
//
//            let params = [
//                "user_id": self.user.id
//            ]
//
//            guard let url = URL(string: stringURL) else { return }
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
//
//            let session = URLSession.shared.dataTask(with: request) { data, response, error in
//
//                guard let data = data else { return }
//
//                if let error = error {
//                    print("there was an error: \(error.localizedDescription)")
//                }
//
//                do {
//                    let decoder = JSONDecoder()
//                    let userCoursesRes = try decoder.decode([Course].self, from: data)
//                    DispatchQueue.main.async {
//                        self.courses = userCoursesRes
//                        if self.courses.count > 0{
//                            var topAnc = (self.buttonCounter + 1) * 40
//                            self.view.addSubview(self.coursesBtn)
//                            self.coursesBtn.translatesAutoresizingMaskIntoConstraints = false
//                            NSLayoutConstraint.activate([
//                                self.coursesBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//                                self.coursesBtn.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant: CGFloat(topAnc)),
//                                self.coursesBtn.widthAnchor.constraint(equalToConstant: 150)
//                            ])
//                            self.buttonCounter += 1
//                            /*let defaults = UserDefaults.standard
//                            defaults.set(self.courses, forKey: "userCourses")*/
//
//                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                            appDelegate.userCourses = self.courses
//                        }
//                    }
//
//                } catch {
//                    print("Course verileri cekilemedi")
//                }
//
//            }
//
//            session.resume()
//        }
//
//    private func getUserLanguages(){
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let stringURL = "\(appDelegate.APIURL)/language/getUserLanguages"
//
//
//            let params = [
//                "user_id": self.user.id
//            ]
//
//            guard let url = URL(string: stringURL) else { return }
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
//
//            let session = URLSession.shared.dataTask(with: request) { data, response, error in
//
//                guard let data = data else { return }
//
//                if let error = error {
//                    print("there was an error: \(error.localizedDescription)")
//                }
//
//                do {
//                    let decoder = JSONDecoder()
//                    let userLanguagesRes = try decoder.decode([Language].self, from: data)
//                    DispatchQueue.main.async {
//                        self.languages = userLanguagesRes
//                        if self.languages.count > 0{
//                            var topAnc = (self.buttonCounter + 1) * 40
//                            self.view.addSubview(self.languagesBtn)
//                            self.languagesBtn.translatesAutoresizingMaskIntoConstraints = false
//                            NSLayoutConstraint.activate([
//                                self.languagesBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//                                self.languagesBtn.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant: CGFloat(topAnc)),
//                                self.languagesBtn.widthAnchor.constraint(equalToConstant: 150)
//                            ])
//                            self.buttonCounter += 1
//                            /*let defaults = UserDefaults.standard
//                            defaults.set(self.languages, forKey: "userLanguages")*/
//
//                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                            appDelegate.userLanguages = self.languages
//
//                        }
//                    }
//                } catch {
//                    print("Language verileri cekilemedi")
//                }
//
//            }
            
//            session.resume()
//        }
    
//    @objc private func showUserSkills(_ Sender: Any){
//        let skillsVC = SkillListViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        navigationController?.pushViewController(skillsVC, animated: true)
//    }
//    @objc private func showUserExperiences(_ Sender: Any){
//        let experiencesVC = ExperienceListViewController(experiences: self.experiences)
//        navigationController?.pushViewController(experiencesVC, animated: true)
//    }
//    @objc private func showUserEducations(_ Sender: Any){
//        let educationsVC = EducationListViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        navigationController?.pushViewController(educationsVC, animated: true)
//    }
//    @objc private func showUserCourses(_ Sender: Any){
//        let coursesVC = CourseListViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        navigationController?.pushViewController(coursesVC, animated: true)
//    }
//    @objc private func showUserLanguages(_ Sender: Any){
//        let languagesVC = LanguageListViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        navigationController?.pushViewController(languagesVC, animated: true)
//    }
//
//
    
}

//extension UIImageView {
//    func loadImage(_ url: String){
//        DispatchQueue.global(qos: .background).async {
//            DispatchQueue.main.async {
//                guard let url = URL(string: url) else {
//                    return
//                }
//
//                guard let data = try? Data(contentsOf: url) else {
//                    return
//                }
//
//                self.image = UIImage(data: data)
//            }
//        }
//    }
//}

