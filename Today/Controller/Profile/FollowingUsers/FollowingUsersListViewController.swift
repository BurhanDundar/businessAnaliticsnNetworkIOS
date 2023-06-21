//
//  FollowingUsersListViewController.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 13.06.2023.
//

import UIKit

class FollowingUsersListViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, User.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, User.ID>
    
        var users: [User]!
        var filteredUsers: [User] = []
        var dataSource: DataSource!
        var isSearching: Bool = false
        var dynamicSearchText: String = ""
        // search bar
        var searchController: UISearchController!
    
        lazy var fetchedImageView: UIImageView = {
            let iv = UIImageView()
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.layer.masksToBounds = false
            iv.contentMode = .scaleAspectFill
            iv.backgroundColor = .clear
            iv.layer.borderWidth = 1
            iv.layer.borderColor = UIColor.blue.cgColor
            iv.layer.cornerRadius = iv.frame.size.height/2
            iv.clipsToBounds = true
            return iv
        }()
         override func viewDidLoad() {
             User.sampleData = self.users
             super.viewDidLoad()
             navigationItem.title = "Following Users"

             lazy var searchController: UISearchController = {
                 let searchController = UISearchController(searchResultsController: nil)
                 searchController.hidesNavigationBarDuringPresentation = false
                 searchController.searchBar.delegate = self
                 return searchController
             }()
             
             navigationItem.searchController = searchController

             let listLayout = listLayout()
             collectionView.collectionViewLayout = listLayout
             
             let cellRegistration = UICollectionView.CellRegistration {
                 (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: User.ID) in
                 var user: User!
                 user = self.filteredUsers.count > 0 ?  self.filteredUsers[indexPath.item] : self.users[indexPath.item]
                 
                 var contentConfiguration = cell.defaultContentConfiguration()
                 contentConfiguration.text = user.full_name
                 contentConfiguration.secondaryText = user.title
                 
//                 contentConfiguration.image = UIImage(systemName: "building.fill")
                 
                 cell.contentConfiguration = contentConfiguration
             }

             dataSource = DataSource(collectionView: collectionView) {
                 (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: User.ID) in
                 return collectionView.dequeueConfiguredReusableCell(
                     using: cellRegistration, for: indexPath, item: itemIdentifier)
             }
             updateSnapshot(for: User.sampleData)
         }
    
    override func collectionView(
        _ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        let id = filteredUsers.count > 0 ? filteredUsers[indexPath.item].id : users[indexPath.item].id
        pushDetailViewForUser(withId: id)
        return false
    }
    
    func user(withId id: User.ID) -> User {
        let index = users.indexOfUser(withId: id)
        return users[index]
    }
    
    func updateUser(_ user: User) {
            let index = self.users.indexOfUser(withId: user.id)
            self.users[index] = user
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if (segue.identifier == "ShowFollowingUserDetail") {
          let followingUserVC = segue.destination as! FollowingUserViewController
          let object = sender as! [String: User?]
           followingUserVC.user = object["user"] as! User
       }
        
    }
    
    func pushDetailViewForUser(withId id:User.ID){
        let user = user(withId: id)
        DispatchQueue.main.async {
            let sender: [String: User?] = [ "user": user ]
            self.performSegue(withIdentifier: "ShowFollowingUserDetail", sender: sender)
        }
     }

     private func listLayout() -> UICollectionViewCompositionalLayout {
         var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
         listConfiguration.showsSeparators = true
         listConfiguration.backgroundColor = .clear
         return UICollectionViewCompositionalLayout.list(using: listConfiguration)
     }
    
    func updateSnapshot(for pUsers: [User]){
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(pUsers.map { $0.id })
        dataSource.apply(snapshot)
        collectionView.dataSource = dataSource
    }
    
    private func loadFetchedImage(for url: String){
        fetchedImageView.loadImage(url)
    }
}

extension FollowingUsersListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.dynamicSearchText = searchText
        if searchText.isEmpty {
            isSearching = false
            self.dynamicSearchText = ""
            self.filteredUsers = []
            updateSnapshot(for: self.users)
        } else {
            isSearching = true
            let allFilteredUsers = User.sampleData.filter({ $0.full_name.lowercased().contains(searchText.lowercased()) })
            self.filteredUsers = allFilteredUsers
            updateSnapshot(for: allFilteredUsers)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        self.dynamicSearchText = ""
        self.filteredUsers = []
        updateSnapshot(for: User.sampleData)
    }
}

