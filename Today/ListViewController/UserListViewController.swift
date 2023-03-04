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
    
        // search bar
        var searchController: UISearchController!

         override func viewDidLoad() {
             
             navigationItem.title = "Members"
             let filterBarButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(didPressFilterButton))
             navigationItem.rightBarButtonItem = filterBarButton
             //view = UIView()
             //view.backgroundColor = .white
             
             //searchController = UISearchController()
             //title = "search"
             //searchController.searchResultsUpdater = self
             //navigationItem.searchController = searchController
             
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
                 let user = self.users[indexPath.item]
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
    
    
    
    func updateSnapshot(for users: [User]){
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(users.map { $0.id })
        dataSource.apply(snapshot)
        collectionView.dataSource = dataSource
    }
    
    
}

extension UserListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            updateSnapshot(for: User.sampleData)
        } else {
            isSearching = true
            filteredUsers = users.filter({ $0.full_name.lowercased().contains(searchText.lowercased()) })
            updateSnapshot(for: filteredUsers)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateSnapshot(for: User.sampleData)
    }
    
    @objc private func filterMembers(){
        print("filter members")
    }
    
    @objc private func bookmark(){
        print("bookmark is tapped")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print("Murat Osman Ünalır users: ",users[0].isBookmarked)
        print("Murat Osman Ünalır User.sampleData: ",User.sampleData[0].isBookmarked)
        
        collectionView.reloadData()
    }
}
