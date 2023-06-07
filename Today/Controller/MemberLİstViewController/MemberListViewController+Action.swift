//
//  MemberListViewController+Action.swift
//  Today
//
//  Created by Şerife Türksever on 7.06.2023.
//

import UIKit

extension MemberListViewController {
    
    @objc func didPressFilterButton (_ sender: UIBarButtonItem){
        let viewController = MemberFilterViewController()
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
        // index -> 0: all, 1: bookmarked
        if(sender.selectedSegmentIndex == 0){
            self.listStyleSelectedIndex = 0
            if(self.dynamicSearchText == ""){
                self.filteredMembers = []
                updateSnapshot(for: self.members)
            } else {
                let searchBarFilterMembers = self.members.filter({ $0.fullname.lowercased().contains(self.dynamicSearchText.lowercased()) })
                self.filteredMembers = searchBarFilterMembers
                updateSnapshot(for: searchBarFilterMembers)
            }
            collectionView.reloadData()
                
        } else if(sender.selectedSegmentIndex == 1){
            self.listStyleSelectedIndex = 1
            if(self.dynamicSearchText == ""){
                let bookmarkedMembers = self.members.filter({ $0.isBookmarked })
                self.filteredMembers = bookmarkedMembers
                updateSnapshot(for: self.filteredMembers)
            } else {
                var filteredBookmarkMembers = self.members.filter({ $0.isBookmarked })
                filteredBookmarkMembers = filteredBookmarkMembers.filter({ $0.fullname.lowercased().contains( self.dynamicSearchText.lowercased() ) })
                self.filteredMembers = filteredBookmarkMembers
                updateSnapshot(for: self.filteredMembers)
            }
            collectionView.reloadData()
        }
        
        }
}
