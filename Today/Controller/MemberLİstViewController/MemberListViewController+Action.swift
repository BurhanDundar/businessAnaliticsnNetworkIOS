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
   
    @objc func didPressProfileButton (_ sender: UIBarButtonItem){
//        let viewController = ProfileViewController()
        
//        navigationController?.pushViewController(viewController, animated: true)
        performSegue(withIdentifier: "GoToProfilePage", sender: self)
        let backBarButtonItem = UIBarButtonItem(title: "Members", style: .plain, target: nil, action: nil)
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
        var res = [Member]()
        var members = [Member]()
            if(sender.selectedSegmentIndex == 0){
                Task{
                        do {
                            members = try await getAllMembers()
                            } catch {
                                print("Oops!")
                            }
                }
                self.listStyleSelectedIndex = 0
                self.members = members
                updateSnapshot(for: self.members)
                    
            } else if(sender.selectedSegmentIndex == 1){
                Task{
                        do {
                            res = try await getBookmarkedMembers()
                            } catch {
                                print("Oops!")
                            }
                }
                self.listStyleSelectedIndex = 1
                self.filteredMembers = res
                updateSnapshot(for: self.filteredMembers)
            }
            
            }
}
