/*
 See LICENSE folder for this sample’s licensing information.
 */

// filtre sisteminden pek emin değilim

import UIKit

class UserListViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, User.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, User.ID>

    
    
        var users: [User] = User.sampleData
        var filteredUsers: [User] = []
        var dataSource: DataSource!
        var isSearching: Bool = false
        var listStyleSelectedIndex: Int = 0
    
        // search bar
        var searchController: UISearchController!
    
        let listStyleSegmentedControl = UISegmentedControl(items: ["all","bookmarked"])
    
         override func viewDidLoad() {
             
             navigationItem.title = "Members"
             let filterBarButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(didPressFilterButton))
             navigationItem.rightBarButtonItem = filterBarButton
             
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
                 (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: User.ID) in
                 var user: User!
                 print(indexPath.item)
                 if(self.listStyleSelectedIndex == 1) {
                     user = self.filteredUsers[indexPath.item]
                 } else if(self.listStyleSelectedIndex == 0) {
                     user = self.users[indexPath.item] //self.filteredUsers.count > 0 ? self.filteredUsers[indexPath.item] : self.users[indexPath.item]
                 }
                 
                 
                 var contentConfiguration = cell.defaultContentConfiguration()
                 contentConfiguration.text = user.full_name
                 contentConfiguration.secondaryText = user.title
                 
                 let systemImageName = user.isBookmarked ? "bookmark.fill" :  "bookmark"
                 
                 let customAccessory = UICellAccessory.CustomViewConfiguration(
                   customView: UIImageView(image: UIImage(systemName: systemImageName)),
                   placement: .trailing(displayed: .always))
                 
                 cell.accessories = [.customView(configuration: customAccessory),.disclosureIndicator(displayed: .always)]
                 cell.contentConfiguration = contentConfiguration
             }

             dataSource = DataSource(collectionView: collectionView) {
                 (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: User.ID) in
                 return collectionView.dequeueConfiguredReusableCell(
                     using: cellRegistration, for: indexPath, item: itemIdentifier)
             }
             
             listStyleSegmentedControl.selectedSegmentIndex = listStyleSelectedIndex
             listStyleSegmentedControl.addTarget(
                self, action: #selector(didChangeListStyle(_:)), for: .valueChanged)
             
             navigationItem.titleView = listStyleSegmentedControl
             
             updateSnapshot(for: User.sampleData)
         }
    
    override func collectionView(
        _ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        let id = isSearching ? filteredUsers[indexPath.item].id : users[indexPath.item].id
        pushDetailViewForUser(withId: id)
        return false
    }
    
    func user(withId id: User.ID) -> User {
        let index = users.indexOfUser(withId: id)
        return users[index]
    }
    
    internal func updateUser(_ user: User) {
           let index = users.indexOfUser(withId: user.id)
           users[index] = user
       }
    
    func pushDetailViewForUser(withId id:User.ID){
        let user = user(withId: id)
        let viewController = UserViewController(user: user, parent: self)
        navigationController?.pushViewController(viewController, animated: true)
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
}

extension UserListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            isSearching = false
            if(listStyleSelectedIndex == 1){
                let bookmarkedFilteredValues = self.users.filter({ $0.isBookmarked })
                self.filteredUsers = bookmarkedFilteredValues
                updateSnapshot(for: bookmarkedFilteredValues)
            } else {
                updateSnapshot(for: self.users)
            }
        } else {
            isSearching = true
            if(listStyleSelectedIndex == 1) {
                var bookmarkedFilteredValues = User.sampleData.filter({ $0.full_name.lowercased().contains(searchText.lowercased()) })
                bookmarkedFilteredValues = bookmarkedFilteredValues.filter({ $0.isBookmarked })
                self.filteredUsers = bookmarkedFilteredValues
                print("self.filteredUsers -> ", self.filteredUsers)
                updateSnapshot(for: bookmarkedFilteredValues)
            } else if(listStyleSelectedIndex == 0) {
                let allFilteredUsers = User.sampleData.filter({ $0.full_name.lowercased().contains(searchText.lowercased()) })
                self.filteredUsers = allFilteredUsers
                updateSnapshot(for: allFilteredUsers)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        if(listStyleSelectedIndex == 1){
            let bookmarkedFilteredValues = self.users.filter({ $0.isBookmarked })
            self.filteredUsers = bookmarkedFilteredValues
            updateSnapshot(for: bookmarkedFilteredValues)
        } else {
            updateSnapshot(for: User.sampleData)
        }
    }
    
    @objc private func filterMembers(){
        print("filter members")
    }
    
    @objc private func bookmark(){
        print("bookmark is tapped")
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        collectionView.reloadData()
//    }
}
