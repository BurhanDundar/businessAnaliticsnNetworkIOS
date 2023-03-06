//
//  UserListViewController+Action.swift
//  Today
//
//  Created by Burhan Dündar on 4.03.2023.
//

import UIKit

extension UserListViewController {
    
    @objc func didPressFilterButton (_ sender: UIBarButtonItem){
        let viewController = FilterViewController()
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: self, action: #selector(didCancelAdd(_:)))
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: self, action: #selector(didDoneAdd(_:)))
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
        
    }
    
    @objc func didDoneAdd(_ sender: UIBarButtonItem){
        dismiss(animated: true)
    }
    
    @objc func didCancelAdd(_ sender: UIBarButtonItem){
        dismiss(animated: true)
    }
    
    @objc func didChangeListStyle(_ sender: UISegmentedControl) {
        print("isSearching: ", isSearching)
        // index -> 0: all, 1: bookmarked
        if(sender.selectedSegmentIndex == 0){
            self.listStyleSelectedIndex = 0
            updateSnapshot(for: User.sampleData)
            collectionView.reloadData()
        } else if(sender.selectedSegmentIndex == 1){
            self.listStyleSelectedIndex = 1
            var bookmarkedUsers = isSearching ? self.filteredUsers.filter({ $0.isBookmarked }) : users.filter({ $0.isBookmarked })
           self.filteredUsers = bookmarkedUsers
            updateSnapshot(for: bookmarkedUsers)
            collectionView.reloadData()
        }
        
        }
}
