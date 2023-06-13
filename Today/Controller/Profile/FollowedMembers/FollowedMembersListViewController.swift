//
//  FollowedMembersListViewController.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 13.06.2023.
//

import UIKit

class FollowedMembersListViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Member.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Member.ID>
    
        var members: [Member] = Member.sampleData
        var filteredMembers: [Member] = []
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
            iv.backgroundColor = .orange
            iv.layer.borderWidth = 1
            iv.layer.borderColor = UIColor.blue.cgColor
            iv.layer.cornerRadius = iv.frame.size.height/2
            iv.clipsToBounds = true
            return iv
        }()
         override func viewDidLoad() {
             self.getMembers()
             navigationItem.title = "Followed Members"

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
                 (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: Member.ID) in
                 var member: Member!
                 member = self.filteredMembers.count > 0 ?  self.filteredMembers[indexPath.item] : self.members[indexPath.item]
                 
                 var contentConfiguration = cell.defaultContentConfiguration()
                 contentConfiguration.text = member.fullname
                 contentConfiguration.secondaryText = member.username
                 
                 cell.contentConfiguration = contentConfiguration
             }

             dataSource = DataSource(collectionView: collectionView) {
                 (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Member.ID) in
                 return collectionView.dequeueConfiguredReusableCell(
                     using: cellRegistration, for: indexPath, item: itemIdentifier)
             }
             updateSnapshot(for: Member.sampleData)
         }
    
    override func collectionView(
        _ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        let id = filteredMembers.count > 0 ? filteredMembers[indexPath.item].id : members[indexPath.item].id // isSearching?
        pushDetailViewForMember(withId: id)
        return false
    }
    
    func member(withId id: Member.ID) -> Member {
        let index = members.indexOfMember(withId: id)
        return members[index]
    }
    
    func updateMember(_ member: Member) {
            let index = self.members.indexOfMember(withId: member.id)
            self.members[index] = member
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if (segue.identifier == "ShowFollowedMemberDetail") {
          let followedMemberVC = segue.destination as! FollowedMemberViewController
          let object = sender as! [String: Member?]
           followedMemberVC.member = object["member"] as! Member
       }
        
    }
    
    func pushDetailViewForMember(withId id:Member.ID){
        let member = member(withId: id)
        DispatchQueue.main.async {
            let sender: [String: Member?] = [ "member": member ]
            self.performSegue(withIdentifier: "ShowFollowedMemberDetail", sender: sender)
        }
     }

     private func listLayout() -> UICollectionViewCompositionalLayout {
         var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
         listConfiguration.showsSeparators = true
         listConfiguration.backgroundColor = .clear
         return UICollectionViewCompositionalLayout.list(using: listConfiguration)
     }
    
    func updateSnapshot(for pMembers: [Member]){
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(pMembers.map { $0.id })
        dataSource.apply(snapshot)
        collectionView.dataSource = dataSource
    }
    
    private func loadFetchedImage(for url: String){
        fetchedImageView.loadImage(url)
    }
    
    private func getMembers(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stringURL = "\(appDelegate.APIURL)/member"
        guard let url = URL(string: stringURL) else { return }
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("there was an error: \(error.localizedDescription)")
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let members = try decoder.decode([Member].self, from: data)
                DispatchQueue.main.async {
                    self.members = members
                    Member.sampleData = self.members
                    self.filteredMembers = []
                    self.collectionView.reloadData()
                    self.updateSnapshot(for: self.members)
                }
            } catch {
                print("Error Occured!")
            }
            
        }
        session.resume()
    }
    
}

extension FollowedMembersListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.dynamicSearchText = searchText
        if searchText.isEmpty {
            isSearching = false
            self.dynamicSearchText = ""
            self.filteredMembers = []
            updateSnapshot(for: self.members)
        } else {
            isSearching = true
            let allFilteredMembers = Member.sampleData.filter({ $0.fullname.lowercased().contains(searchText.lowercased()) })
            self.filteredMembers = allFilteredMembers
            updateSnapshot(for: allFilteredMembers)
        }
    }
    
    func memberSearchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        self.dynamicSearchText = ""
        self.filteredMembers = []
        updateSnapshot(for: Member.sampleData)
    }
}


