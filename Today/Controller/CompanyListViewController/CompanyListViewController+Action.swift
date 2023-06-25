//
//  CompanyListViewController+Action.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 31.05.2023.
//

import UIKit

extension CompanyListViewController {
    
    @objc func didPressFilterButton (_ sender: UIBarButtonItem){
        let viewController = CompanyFilterViewController()
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
        self.showSpinner()
        self.listStyleSegmentedControl.isEnabled = false
            // index -> 0: all, 1: bookmarked
        var res = [Company]()
        var companies = [Company]()
            if(sender.selectedSegmentIndex == 0){
                Task{
                    do {
                        companies = try await getAllCompanies()
                    } catch {
                        print("Oops!")
                    }
                }
                self.listStyleSelectedIndex = 0
                self.companies = companies
                updateSnapshot(for: self.companies)
                    
            } else if(sender.selectedSegmentIndex == 1){
                Task{
                    do {
                        res = try await getBookmarkedCompanies()
                    } catch {
                        print("Oops!")
                    }
                }
                self.listStyleSelectedIndex = 1
                self.filteredCompanies = res
                updateSnapshot(for: self.filteredCompanies)
            }
            
            }
}
