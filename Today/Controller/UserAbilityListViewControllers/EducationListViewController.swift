//
//  EducationListViewController.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 4.06.2023.
//

import UIKit

class EducationListViewController: UICollectionViewController {
        
        typealias DataSource = UICollectionViewDiffableDataSource<Int, Education.ID>
        typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Education.ID>
        
        var educations: [Education] = Education.sampleData
        var filteredEducations: [Education] = []
        var dataSource: DataSource!
        var isSearching: Bool = false
        var dynamicSearchText: String = ""
    
        // search bar
        var searchController: UISearchController!
    
         override func viewDidLoad() {
             
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
             Education.sampleData = appDelegate.userEducations as [Education]
             self.educations = Education.sampleData
             
             
             view.backgroundColor = .systemBackground
             navigationItem.title = "User Educations"
             
             lazy var searchController: UISearchController = {
                 let searchController = UISearchController(searchResultsController: nil)
                 // searchController.dimsBackgroundDuringPresentation = false
                 searchController.hidesNavigationBarDuringPresentation = false
                 searchController.searchBar.delegate = self
                 return searchController
             }()
             
             super.viewDidLoad()
             navigationItem.searchController = searchController

             let listLayout = listLayout()
             collectionView.collectionViewLayout = listLayout
             
             let cellRegistration = UICollectionView.CellRegistration {
                 (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: Education.ID) in
                 var education: Education!
                 education = self.filteredEducations.count > 0 ? self.filteredEducations[indexPath.item] : self.educations[indexPath.item]
                 
                 var contentConfiguration = cell.defaultContentConfiguration()
                 contentConfiguration.text = education.department
                 contentConfiguration.secondaryText = education.degree
                 cell.contentConfiguration = contentConfiguration
             }

             dataSource = DataSource(collectionView: collectionView) {
                 (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Education.ID) in
                 return collectionView.dequeueConfiguredReusableCell(
                     using: cellRegistration, for: indexPath, item: itemIdentifier)
             }
                          
             updateSnapshot(for: Education.sampleData)
         }
    
    func education(withId id: Education.ID) -> Education {
        let index = educations.indexOfEducation(withId: id)
        return educations[index]
    }

     private func listLayout() -> UICollectionViewCompositionalLayout {
         var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
         listConfiguration.showsSeparators = true
         listConfiguration.backgroundColor = .clear
         return UICollectionViewCompositionalLayout.list(using: listConfiguration)
     }
    
    func updateSnapshot(for pEducations: [Education]){
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(pEducations.map { $0.id })
        dataSource.apply(snapshot)
        collectionView.dataSource = dataSource
    }
}

extension EducationListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.dynamicSearchText = searchText
        if searchText.isEmpty {
            isSearching = false
            self.dynamicSearchText = ""
            self.filteredEducations = []
            updateSnapshot(for: self.educations)
        } else {
            isSearching = true
            let allFilteredEducations = Education.sampleData.filter({ $0.department!.lowercased().contains(searchText.lowercased()) })
            self.filteredEducations = allFilteredEducations
            updateSnapshot(for: allFilteredEducations)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        self.dynamicSearchText = ""
        self.filteredEducations = []
        updateSnapshot(for: Education.sampleData)
    }
    
    @objc private func filterMembers(){
        print("filter members")
    }
}

