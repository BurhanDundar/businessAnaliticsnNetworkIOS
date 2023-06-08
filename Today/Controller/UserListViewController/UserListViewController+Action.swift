//
//  UserListViewController+Action.swift
//  Today
//
//  Created by Burhan Dündar on 4.03.2023.
//

import UIKit

extension UserListViewController {
    
    @objc func didPressFilterButton (_ sender: UIBarButtonItem){
        let viewController = UserFilterViewController()
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: self, action: #selector(didCancelAdd(_:)))
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: self, action: #selector(didDoneAdd(_:)))
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
        
    }
    @objc func didPressProfileButton (_ sender: UIBarButtonItem){
        let viewController = ProfileViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
        let backBarButtonItem = UIBarButtonItem(title: "Users", style: .plain, target: nil, action: nil)
                navigationItem.backBarButtonItem = backBarButtonItem
        
        
    }
    @objc func didDoneAdd(_ sender: UIBarButtonItem){
        dismiss(animated: true)
    }
    
    @objc func didCancelAdd(_ sender: UIBarButtonItem){
        dismiss(animated: true)
    }
    
    @objc func didChangeListStyle(_ sender: UISegmentedControl) {
        // index -> 0: all, 1: bookmarked
        if(sender.selectedSegmentIndex == 0){
            self.listStyleSelectedIndex = 0
            if(self.dynamicSearchText == ""){
                self.filteredUsers = []
                updateSnapshot(for: self.users)
            } else {
                let searchBarFilterUsers = self.users.filter({ $0.full_name.lowercased().contains(self.dynamicSearchText.lowercased()) })
                self.filteredUsers = searchBarFilterUsers
                updateSnapshot(for: self.filteredUsers)
            }
            collectionView.reloadData()
            	
        } else if(sender.selectedSegmentIndex == 1){
            self.listStyleSelectedIndex = 1
            if(self.dynamicSearchText == ""){
                let bookmarkedUsers = self.users.filter({ $0.isBookmarked })
                self.filteredUsers = bookmarkedUsers
                updateSnapshot(for: self.filteredUsers)
            } else {
                var filteredBookmarkUsers = self.users.filter({ $0.isBookmarked })
                filteredBookmarkUsers = filteredBookmarkUsers.filter({ $0.full_name.lowercased().contains( self.dynamicSearchText.lowercased() ) })
                self.filteredUsers = filteredBookmarkUsers
                updateSnapshot(for: self.filteredUsers)
            }
            collectionView.reloadData()
        }
        
        }
}
