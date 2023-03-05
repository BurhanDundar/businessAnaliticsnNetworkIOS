//
//  TabBarController.swift
//  Today
//
//  Created by Burhan Dündar on 4.03.2023.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeViewController = UserListViewController()
        let bookmarkViewController = BookmarkViewController()
        
        homeViewController.title = "home"
        bookmarkViewController.title = "bookmarks"
        
        self.setViewControllers([homeViewController,bookmarkViewController], animated: true)
        
        guard let items = self.tabBar.items else { return }
        
        let images = ["house","bookmark"]
        
        for x in 0...2 {
            items[x].image = UIImage(systemName: images[x])
        }
    }
}
