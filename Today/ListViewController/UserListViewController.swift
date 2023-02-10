/*
 See LICENSE folder for this sample’s licensing information.
 */

import UIKit

class UserListViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
         typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>

    
        var users: [User] = User.sampleData
         var dataSource: DataSource!

         override func viewDidLoad() {
             super.viewDidLoad()

             let listLayout = listLayout()
             collectionView.collectionViewLayout = listLayout

             let cellRegistration = UICollectionView.CellRegistration {
                 (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: String) in
                 let user = User.sampleData[indexPath.item]
                 var contentConfiguration = cell.defaultContentConfiguration()
                 contentConfiguration.text = user.full_name
                 contentConfiguration.secondaryText = user.title
                 cell.accessories = [.disclosureIndicator(displayed: .always)]
                 cell.contentConfiguration = contentConfiguration
             }

             dataSource = DataSource(collectionView: collectionView) {
                 (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: String) in
                 return collectionView.dequeueConfiguredReusableCell(
                     using: cellRegistration, for: indexPath, item: itemIdentifier)
             }

             var snapshot = Snapshot()
             snapshot.appendSections([0])
             snapshot.appendItems(User.sampleData.map { $0.full_name })
             dataSource.apply(snapshot)

             collectionView.dataSource = dataSource
         }
    
    override func collectionView(
        _ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        let id = users[indexPath.item].id
        pushDetailViewForUser(withId: id)
        return false
    }
    
    func user(withId id: User.ID) -> User {
        let index = users.indexOfUser(withId: id)
        return users[index]
    }
    
        func pushDetailViewForUser(withId id:User.ID){
            let user = user(withId: id)
            let viewController = UserViewController(user: user)
            navigationController?.pushViewController(viewController, animated: true)
         }

         private func listLayout() -> UICollectionViewCompositionalLayout {
             var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
             listConfiguration.showsSeparators = true
             listConfiguration.backgroundColor = .clear
             return UICollectionViewCompositionalLayout.list(using: listConfiguration)
         }
}
