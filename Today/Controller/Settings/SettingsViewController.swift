//
//  SettingsViewController.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 14.06.2023.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let settingsNames = ["update password","update username"]
    let settingsSystemImages = ["lock.rectangle.on.rectangle","rectangle.and.pencil.and.ellipsis"]
    let settingDetailSegues = ["UpdatePassword","UpdateUsername"]
    
    var settingsName = ""
    var settingsSystemImage = ""
    var settingDetailSegue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Settings"
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell()
            var content = cell.defaultContentConfiguration()
            content.text = "\(settingsNames[indexPath.item])"
            content.image = UIImage(systemName: settingsSystemImages[indexPath.item])
            cell.accessoryType = .disclosureIndicator
            cell.contentConfiguration = content
            cell.selectionStyle = .none
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            settingsName = settingsNames[indexPath.item]
            settingsSystemImage = settingsSystemImages[indexPath.item]
            settingDetailSegue = settingDetailSegues[indexPath.item]
            performSegue(withIdentifier: settingDetailSegue, sender: nil)
            
        }
}
