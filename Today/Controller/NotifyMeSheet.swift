//
//  NotifyMeSheet.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 29.06.2023.
//

import UIKit

protocol PresentedViewControllerDelegate: AnyObject {
    func presentedViewControllerDidDismiss()
}

class NotifyMeSheet: UIViewController {
    
    var notifyMeTitle = UILabel()
    var notifyMeDescription = UILabel()
    var notifyMeSwitch = UISwitch()
    var doneBtn = CustomButton(title: "Done", hasBackground: false, fontSize: .med)
    
    weak var delegate: PresentedViewControllerDelegate?
    
    var userId: String!
    var memberId: String
    var full_name: String!
    var isNotificationsOpened: Bool!
    var parentView: UserViewController?
    init(userId: String, memberId: String, full_name: String, isNotificationsOpened: Bool, parentView: UserViewController) {
        self.userId = userId
        self.memberId = memberId
        self.full_name = full_name
        self.isNotificationsOpened = isNotificationsOpened
        self.parentView = parentView
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
        
        self.notifyMeSwitch.setOn(self.isNotificationsOpened, animated: true)
        self.notifyMeSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        
        self.notifyMeTitle.translatesAutoresizingMaskIntoConstraints = false
        self.notifyMeDescription.translatesAutoresizingMaskIntoConstraints = false
        self.notifyMeSwitch.translatesAutoresizingMaskIntoConstraints = false
        self.doneBtn.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.notifyMeTitle)
        self.view.addSubview(self.notifyMeDescription)
        self.view.addSubview(self.notifyMeSwitch)
        self.view.addSubview(self.doneBtn)
        
        if self.notifyMeSwitch.isOn == self.isNotificationsOpened {
            self.doneBtn.isEnabled = false
            self.doneBtn.alpha = 0.5
        }
        
        self.doneBtn.addTarget(self, action: #selector(addObserverToUser), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            self.notifyMeTitle.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
            self.notifyMeTitle.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            self.notifyMeTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.notifyMeDescription.topAnchor.constraint(equalTo: self.notifyMeTitle.bottomAnchor, constant: 20),
            self.notifyMeDescription.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            self.notifyMeDescription.centerXAnchor.constraint(equalTo: self.notifyMeTitle.centerXAnchor),
            
            self.notifyMeSwitch.topAnchor.constraint(equalTo: self.notifyMeDescription.bottomAnchor, constant: 20),
            self.notifyMeSwitch.centerXAnchor.constraint(equalTo: self.notifyMeDescription.centerXAnchor),
            
            self.doneBtn.topAnchor.constraint(equalTo: self.notifyMeSwitch.bottomAnchor, constant: 20),
            self.doneBtn.centerXAnchor.constraint(equalTo: self.notifyMeSwitch.centerXAnchor),
            
        ])
    }
    
    @objc private func switchChanged(mySwitch: UISwitch) {
        if self.notifyMeSwitch.isOn == self.isNotificationsOpened {
            self.doneBtn.isEnabled = false
            self.doneBtn.alpha = 0.5
        } else {
            self.doneBtn.isEnabled = true
            self.doneBtn.alpha = 1.0
        }
    }
    
    @objc private func addObserverToUser(_ sender: Any){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stringURL = "\(appDelegate.APIURL)/follow/update"
        
            let params = [
                "memberId": self.memberId,
                "followedId": self.userId,
                "isAdded": self.notifyMeSwitch.isOn
            ] as [String: Any]
        
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
                    let response = try decoder.decode(NotifyResponseModel.self, from: data)
                    if response.status == "ok" && response.actionType == "create" {
                        appDelegate.memberNotifyMeUsers.append(self.userId)
                    } else if response.status == "ok" && response.actionType == "delete" {
                        appDelegate.memberNotifyMeUsers.append(self.userId)
                        appDelegate.memberNotifyMeUsers = appDelegate.memberNotifyMeUsers.filter { $0 != self.userId }
                    }
                    print(appDelegate.memberNotifyMeUsers)
                    DispatchQueue.main.async {
                        self.dismiss(animated: true){
                            self.parentView?.updateNotifiedIcon()
                        }
                    }
                } catch {
                    print("Member Notify Users Güncellenemedi")
                }
                
            }
            
            session.resume()
    }
}
