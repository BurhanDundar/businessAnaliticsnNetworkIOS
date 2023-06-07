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
        // index -> 0: all, 1: bookmarked
        if(sender.selectedSegmentIndex == 0){
            print("selfcompanies",self.companies.count)
            self.listStyleSelectedIndex = 0
            if(self.dynamicSearchText == ""){
                self.filteredCompanies = []
                updateSnapshot(for: self.companies)
            } else {
                let searchBarFilterCompanies = self.companies.filter({ $0.name.lowercased().contains(self.dynamicSearchText.lowercased()) })
                self.filteredCompanies = searchBarFilterCompanies
                updateSnapshot(for: searchBarFilterCompanies)
            }
            collectionView.reloadData()
                
        } else if(sender.selectedSegmentIndex == 1){
            self.listStyleSelectedIndex = 1
            if(self.dynamicSearchText == ""){
                let bookmarkedCompanies = self.companies.filter({ $0.isBookmarked })
                self.filteredCompanies = bookmarkedCompanies
                updateSnapshot(for: self.filteredCompanies)
            } else {
                var filteredBookmarkCompanies = self.companies.filter({ $0.isBookmarked })
                filteredBookmarkCompanies = filteredBookmarkCompanies.filter({ $0.name.lowercased().contains( self.dynamicSearchText.lowercased() ) })
                self.filteredCompanies = filteredBookmarkCompanies
                updateSnapshot(for: self.filteredCompanies)
            }
            collectionView.reloadData()
        }
        
        }
}
