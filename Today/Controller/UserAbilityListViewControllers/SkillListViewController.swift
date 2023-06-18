//
//  SkillListViewController.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 3.06.2023.
//

import UIKit

class SkillListViewController: UICollectionViewController {
        
        typealias DataSource = UICollectionViewDiffableDataSource<Int, Skill.ID>
        typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Skill.ID>
        
        var skills: [Skill] = Skill.sampleData
        var filteredSkills: [Skill] = []
        var dataSource: DataSource!
        var isSearching: Bool = false
        var dynamicSearchText: String = ""
    
        // search bar
        var searchController: UISearchController!
    
         override func viewDidLoad() {
             super.viewDidLoad()
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
             Skill.sampleData = appDelegate.userSkills as [Skill]
             self.skills = Skill.sampleData
             
             view.backgroundColor = .systemBackground
             navigationItem.title = "User skills"
             
             lazy var searchController: UISearchController = {
                 let searchController = UISearchController(searchResultsController: nil)
                 // searchController.dimsBackgroundDuringPresentation = false
                 searchController.hidesNavigationBarDuringPresentation = false
                 searchController.searchBar.delegate = self
                 return searchController
             }()
             
             navigationItem.searchController = searchController

             let listLayout = listLayout()
             collectionView.collectionViewLayout = listLayout
             
             let cellRegistration = UICollectionView.CellRegistration {
                 (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: Skill.ID) in
                 var skill: Skill! 
                skill = self.filteredSkills.count > 0 ? self.filteredSkills[indexPath.item] : self.skills[indexPath.item]
                 
                 var contentConfiguration = cell.defaultContentConfiguration()
                 contentConfiguration.text = skill.title
                 cell.contentConfiguration = contentConfiguration
             }

             dataSource = DataSource(collectionView: collectionView) {
                 (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Skill.ID) in
                 return collectionView.dequeueConfiguredReusableCell(
                     using: cellRegistration, for: indexPath, item: itemIdentifier)
             }
                          
             updateSnapshot(for: Skill.sampleData)
         }
    
    func skill(withId id: Skill.ID) -> Skill {
        let index = skills.indexOfSkill(withId: id)
        return skills[index]
    }

     private func listLayout() -> UICollectionViewCompositionalLayout {
         var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
         listConfiguration.showsSeparators = true
         listConfiguration.backgroundColor = .clear
         return UICollectionViewCompositionalLayout.list(using: listConfiguration)
     }
    
    func updateSnapshot(for pSkills: [Skill]){
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(pSkills.map { $0.id })
        dataSource.apply(snapshot)
        collectionView.dataSource = dataSource
    }
}

extension SkillListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.dynamicSearchText = searchText
        if searchText.isEmpty {
            isSearching = false
            self.dynamicSearchText = ""
            self.filteredSkills = []
            updateSnapshot(for: self.skills)
        } else {
            isSearching = true
            let allFilteredSkills = Skill.sampleData.filter({ $0.title.lowercased().contains(searchText.lowercased()) })
            self.filteredSkills = allFilteredSkills
            updateSnapshot(for: allFilteredSkills)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        self.dynamicSearchText = ""
        self.filteredSkills = []
        updateSnapshot(for: Skill.sampleData)
    }
    
    @objc private func filterMembers(){
        print("filter members")
    }
}
