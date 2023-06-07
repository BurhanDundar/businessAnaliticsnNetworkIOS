//
//  MemberLİstViewController.swift
//  Today
//
//  Created by Şerife Türksever on 7.06.2023.
//

import UIKit

class MemberListViewController: UICollectionViewController {

            
            typealias DataSource = UICollectionViewDiffableDataSource<Int, Member.ID>
            typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Member.ID>
            
            var members: [Member] = Member.sampleData
            var filteredMembers: [Member] = []
            var dataSource: DataSource!
            var isSearching: Bool = false
            var listStyleSelectedIndex: Int = 0
            var dynamicSearchText: String = ""
        
            var memberId: String = ""
            var memberFullname: String = ""
            var memberUsername: String = ""
            
        
            // search bar
            var searchController: UISearchController!
        
            let listStyleSegmentedControl = UISegmentedControl(items: ["all","bookmarked"])
        
             override func viewDidLoad() {
                 
                 //print(companyIdForCompanyUsers ?? "")
                 //let defaults = UserDefaults.standard
                 //defaults.set(25, forKey: "Age")
                 /*
                 if let data = UserDefaults.standard.data(forKey: "Member") {
                     do {
                         // Create JSON Decoder
                         let decoder = JSONDecoder()

                         // Decode Note
                         let member = try decoder.decode(Member.self, from: data)
                         print(member)

                     } catch {
                         print("Unable to Decode Note (\(error))")
                     }
                 }*/
                 
                 //let appDelegate = UIApplication.shared.delegate as! AppDelegate
                 //appDelegate.userName = "Burhan"
                 //appDelegate.userid = "1241hd9bısdbf12893"
//
//                 let defaults = UserDefaults.standard
//                 self.memberId = defaults.string(forKey: "memberId") ?? ""
//                 self.memberName = defaults.string(forKey: "memberName") ?? ""
//                 self.memberSurname = defaults.string(forKey: "memberSurname") ?? ""
//                 self.memberUsername = defaults.string(forKey: "memberUsername") ?? ""
//
                 view.backgroundColor = .systemBackground //.white
                 
                 
                self.getMembers()
                 
                 //self.getUsers()
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
                     (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: Member.ID) in
                     var member: Member!
                     if(self.listStyleSelectedIndex == 1) {
                         member = self.filteredMembers[indexPath.item]
                     } else if(self.listStyleSelectedIndex == 0) {
                         // ?
                         member = self.filteredMembers.count > 0 ? self.filteredMembers[indexPath.item] : self.members[indexPath.item]
                     }
                     
                     var contentConfiguration = cell.defaultContentConfiguration()
                     contentConfiguration.text = member.fullname
                     contentConfiguration.secondaryText = member.username
                     
                     let systemImageName = member.isBookmarked ? "bookmark.fill" :  "bookmark"
                     
                     let customAccessory = UICellAccessory.CustomViewConfiguration(
                       customView: UIImageView(image: UIImage(systemName: systemImageName)),
                       placement: .trailing(displayed: .always))
                     
                     cell.accessories = [.customView(configuration: customAccessory),.disclosureIndicator(displayed: .always)]
                     cell.contentConfiguration = contentConfiguration
                 }

                 dataSource = DataSource(collectionView: collectionView) {
                     (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Member.ID) in
                     return collectionView.dequeueConfiguredReusableCell(
                         using: cellRegistration, for: indexPath, item: itemIdentifier)
                 }
                 
                 listStyleSegmentedControl.selectedSegmentIndex = listStyleSelectedIndex
                 listStyleSegmentedControl.addTarget(
                    self, action: #selector(didChangeListStyle(_:)), for: .valueChanged)
                 
                 navigationItem.titleView = listStyleSegmentedControl
                 
                              
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
        
        internal func updateMember(_ member: Member) {
                let index = self.members.indexOfMember(withId: member.id)
                self.members[index] = member
           }
        
        func pushDetailViewForMember(withId id:Member.ID){
            let member = member(withId: id)
            let viewController = MemberViewController(member: member, parent: self)
            navigationController?.pushViewController(viewController, animated: true)
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
                        print(members)
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
        
//        private func getCompanyUsers(){
//
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                let stringURL = "\(appDelegate.APIURL)/user/getCompanyUsersAsUserObj"
//                let params = [
//                    "company_id": self.company_id,
//                ]
//
//                guard let url = URL(string: stringURL) else { return }
//
//                var request = URLRequest(url: url)
//                request.httpMethod = "POST"
//                request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
//                request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
//
//                let session = URLSession.shared.dataTask(with: request) { data, response, error in
//
//                    guard let data = data else { return }
//
//                    if let error = error {
//                        print("there was an error: \(error.localizedDescription)")
//                    }
//
//                    do {
//                        let decoder = JSONDecoder()
//                        let companyUsers = try decoder.decode([User].self, from: data)
//                        DispatchQueue.main.async {
//                            self.users = companyUsers
//                            User.sampleData = self.users
//                            self.filteredUsers = []
//                            self.collectionView.reloadData()
//                            self.updateSnapshot(for: self.users)
//                        }
//                    } catch {
//                        print("Error Occured!")
//                    }
//
//                }
//
//                session.resume()
//            }
    }

    extension MemberListViewController: UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.dynamicSearchText = searchText
            if searchText.isEmpty {
                isSearching = false
                self.dynamicSearchText = ""
                if(listStyleSelectedIndex == 1){
                    let bookmarkedFilteredValues = self.members.filter({ $0.isBookmarked })
                    self.filteredMembers = bookmarkedFilteredValues
                    updateSnapshot(for: bookmarkedFilteredValues)
                } else {
                    self.filteredMembers = []
                    updateSnapshot(for: self.members)
                }
            } else {
                isSearching = true
                if(listStyleSelectedIndex == 1) {
                    let bookmarkedFilteredValues = self.filteredMembers.filter({ $0.fullname.lowercased().contains(searchText.lowercased()) })
                    // bookmarkedFilteredValues = bookmarkedFilteredValues.filter({ $0.isBookmarked })
                    self.filteredMembers = bookmarkedFilteredValues
                    updateSnapshot(for: bookmarkedFilteredValues)
                } else if(listStyleSelectedIndex == 0) {
                    let allFilteredMembers = Member.sampleData.filter({ $0.fullname.lowercased().contains(searchText.lowercased()) })
                    self.filteredMembers = allFilteredMembers
                    updateSnapshot(for: allFilteredMembers)
                }
            }
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            isSearching = false
            self.dynamicSearchText = ""
            if(listStyleSelectedIndex == 1){
                let bookmarkedFilteredValues = self.members.filter({ $0.isBookmarked })
                self.filteredMembers = bookmarkedFilteredValues
                updateSnapshot(for: bookmarkedFilteredValues)
            } else {
                self.filteredMembers = []
                updateSnapshot(for: Member.sampleData)
            }
        }
        
        @objc private func filterMembers(){
            print("filter members")
        }
        
        @objc private func bookmark(){
            print("bookmark is tapped")
        }
        
    }
