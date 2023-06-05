//
//  LanguageListViewController.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 4.06.2023.
//

import UIKit

class LanguageListViewController: UICollectionViewController {
        
        typealias DataSource = UICollectionViewDiffableDataSource<Int, Language.ID>
        typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Language.ID>
        
        var languages: [Language] = Language.sampleData
        var filteredLanguages: [Language] = []
        var dataSource: DataSource!
        var isSearching: Bool = false
        var dynamicSearchText: String = ""
    
        // search bar
        var searchController: UISearchController!
    
         override func viewDidLoad() {
             
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
             Language.sampleData = appDelegate.userLanguages as [Language]
             self.languages = Language.sampleData
             
             
             view.backgroundColor = .systemBackground
             navigationItem.title = "User Languages"
             
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
                 (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: Language.ID) in
                 var language: Language!
                 language = self.filteredLanguages.count > 0 ? self.filteredLanguages[indexPath.item] : self.languages[indexPath.item]
                 
                 var contentConfiguration = cell.defaultContentConfiguration()
                 contentConfiguration.text = language.title
                 cell.contentConfiguration = contentConfiguration
             }

             dataSource = DataSource(collectionView: collectionView) {
                 (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Language.ID) in
                 return collectionView.dequeueConfiguredReusableCell(
                     using: cellRegistration, for: indexPath, item: itemIdentifier)
             }
                          
             updateSnapshot(for: Language.sampleData)
         }
    
    func language(withId id: Language.ID) -> Language {
        let index = languages.indexOfLanguage(withId: id)
        return languages[index]
    }

     private func listLayout() -> UICollectionViewCompositionalLayout {
         var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
         listConfiguration.showsSeparators = true
         listConfiguration.backgroundColor = .clear
         return UICollectionViewCompositionalLayout.list(using: listConfiguration)
     }
    
    func updateSnapshot(for pLanguages: [Language]){
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(pLanguages.map { $0.id })
        dataSource.apply(snapshot)
        collectionView.dataSource = dataSource
    }
}

extension LanguageListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.dynamicSearchText = searchText
        if searchText.isEmpty {
            isSearching = false
            self.dynamicSearchText = ""
            self.filteredLanguages = []
            updateSnapshot(for: self.languages)
        } else {
            isSearching = true
            let allFilteredLanguages = Language.sampleData.filter({ $0.title!.lowercased().contains(searchText.lowercased()) })
            self.filteredLanguages = allFilteredLanguages
            updateSnapshot(for: allFilteredLanguages)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        self.dynamicSearchText = ""
        self.filteredLanguages = []
        updateSnapshot(for: Language.sampleData)
    }
    
    @objc private func filterMembers(){
        print("filter members")
    }
}
