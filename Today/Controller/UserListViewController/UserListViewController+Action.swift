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
    
    @objc func didChangeListStyle(_ sender: UISegmentedControl) {
        self.showSpinner()
        self.listStyleSegmentedControl.isEnabled = false
            // index -> 0: all, 1: bookmarked
        var res = [User]()
        var users = [User]()
            if(sender.selectedSegmentIndex == 0){
                Task{
                    do {
                        users = try await getAllUsers()
                        } catch {
                            print("Oops!")
                        }
                }
                self.listStyleSelectedIndex = 0
                self.users = users
                updateSnapshot(for: self.users)
                    
            } else if(sender.selectedSegmentIndex == 1){
                Task{
                    do {
                        res = try await getBookmarkedUsers()
                    } catch {
                        print("Oops!")
                    }
                }
                self.listStyleSelectedIndex = 1
                self.filteredUsers = res
                updateSnapshot(for: self.filteredUsers)
            }
            }
}
