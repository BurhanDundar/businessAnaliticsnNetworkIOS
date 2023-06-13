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
//        let viewController = ProfileViewController()
        
//        navigationController?.pushViewController(viewController, animated: true)
        
        performSegue(withIdentifier: "GoToProfilePage", sender: self)
        
        let backBarButtonItem = UIBarButtonItem(title: "Users", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        
        
    }
    @objc func didDoneAdd(_ sender: UIBarButtonItem){
        dismiss(animated: true)
    }
    
    @objc func didCancelAdd(_ sender: UIBarButtonItem){
        dismiss(animated: true)
    }
    
    @objc func didChangeListStyle(_ sender: UISegmentedControl) async {
//            Task {
//                do {
//                    try await self.getBookmarkedUsers()
//                    print("aa")
//                } catch {
//                    print("Something went wrong!")
//                }
//            }
//            print("merhaba")
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
                print(self.tempFilteredUsers)
                self.listStyleSelectedIndex = 1
                if(self.dynamicSearchText == ""){
//                    let bookmarkedUsers = self.users.filter({ $0.isBookmarked })
//                    self.filteredUsers = bookmarkedUsers
//                    self.filteredUsers = self.tempFilteredUsers
                    updateSnapshot(for: self.filteredUsers)
                } else {
//                    var filteredBookmarkUsers = self.users.filter({ $0.isBookmarked })
                    let filteredBookmarkUsers = self.filteredUsers.filter({ $0.full_name.lowercased().contains( self.dynamicSearchText.lowercased() ) })
//                    self.filteredUsers = filteredBookmarkUsers
                    updateSnapshot(for: filteredBookmarkUsers)
                }
                collectionView.reloadData()
            }
            
            }
        
        }
