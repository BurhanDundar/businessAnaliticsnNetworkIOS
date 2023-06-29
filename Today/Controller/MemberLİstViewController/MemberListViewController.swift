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
        
            var memberFavs: [String] = [String]()
            var memberId: String = ""
            var memberFullname: String = ""
            var memberUsername: String = ""
    
            // search bar
            var searchController: UISearchController!
            let listStyleSegmentedControl = UISegmentedControl(items: ["all","bookmarked"])
    
            override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                if(self.filteredMembers.count == 0){
                    self.getMemberFavAsMemberIds()
                }
            }
    
             override func viewDidLoad() {
                 self.showSpinner()
                 self.listStyleSegmentedControl.isEnabled = false
                 let defaults = UserDefaults.standard
                 self.memberId = defaults.string(forKey: "memberId") ?? ""
                 self.memberFullname = defaults.string(forKey: "memberFullName") ?? ""
                 
                 view.backgroundColor = .systemBackground //.white
                 
                 Member.sampleData = []
                self.getMembers()
                 
                 navigationItem.title = "Members"
                 
                 let profileBarButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill"), style: .plain, target: self, action: #selector(didPressProfileButton))
                 navigationItem.leftBarButtonItem = profileBarButton

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
                     
                     let isMemberInBookmarkedArray = self.memberFavs.contains(member.id!) ? true : false
                     let systemImageName = isMemberInBookmarkedArray ? "bookmark.fill" :  "bookmark"
                     
                     var customAccessory = UICellAccessory.CustomViewConfiguration(
                       customView: UIImageView(image: UIImage(systemName: systemImageName)),
                       placement: .trailing(displayed: .always))
                     
                     if(self.memberId == member.id) { // bu kullanıcı benim demek ki
                         customAccessory = UICellAccessory.CustomViewConfiguration(
                           customView: UIImageView(image: UIImage(systemName: "person.circle")),
                           placement: .trailing(displayed: .always))
                     }
                     
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
        
        func updateMember(_ member: Member) {
                let index = self.members.indexOfMember(withId: member.id)
                self.members[index] = member
           }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if (segue.identifier == "showMemberDetail") {
          let memberVC = segue.destination as! MemberViewController
          let object = sender as! [String: Any?]
           memberVC.member = object["member"] as! Member
           memberVC.isMemberBookmarked = object["isMemberBookmarked"] as! Bool
       }
        
    }
        
        func pushDetailViewForMember(withId id:Member.ID){
            
            let member = member(withId: id)
            let isMemberInBookmarkedArray = self.memberFavs.contains(member.id!) ? true : false
            DispatchQueue.main.async {
                let sender: [String: Any?] = [ "member": member, "isMemberBookmarked": isMemberInBookmarkedArray ]
                self.performSegue(withIdentifier: "showMemberDetail", sender: sender)
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
    
    private func getMemberFavAsMemberIds(){
        
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let stringURL = "\(appDelegate.APIURL)/favourite/getMemberFavAsUserIds"
            let params = [
                "user_id": memberId,
                "fav_type": "member"
            ]
        
            guard let url = URL(string: stringURL) else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            
            let session = URLSession.shared.dataTask(with: request) { data, response, error in
            
                guard let data = data else { return }
                
                if let error = error {
                    print("there was an error: \(error.localizedDescription)")
                }
                
                do {
                    let decoder = JSONDecoder()
                    let memberFavs = try decoder.decode([String].self, from: data)
                    DispatchQueue.main.async {
                        self.memberFavs = memberFavs
                        appDelegate.memberMemberFavs = self.memberFavs
                        self.collectionView.reloadData() // bundan emin değilim
                    }
                } catch {
                    print("Error Occured!")
                }
                
            }
            
            session.resume()
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
                        
                        self.removeSpinner()
                        self.listStyleSegmentedControl.isEnabled = true   
                    }
                } catch {
                    print("Error Occured!")
                }
                
            }
            session.resume()
        }
    }

    extension MemberListViewController: UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            var res = [Member]()
            self.dynamicSearchText = searchText
            if searchText.isEmpty {
                isSearching = false
                self.dynamicSearchText = ""
                if(listStyleSelectedIndex == 1){
                    Task{
                        do {
                            res = try await getBookmarkedMembers()
                            } catch {
                                print("Oops!")
                            }
                    }
                    self.filteredMembers = res
                    self.updateSnapshot(for: self.filteredMembers)
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
            var res = [Member]()
            isSearching = false
            self.dynamicSearchText = ""
            if(listStyleSelectedIndex == 1){
                Task{
                    do {
                        res = try await getBookmarkedMembers()
                    } catch {
                        print("Oops!")
                    }
                }
                self.filteredMembers = res
                self.updateSnapshot(for: self.filteredMembers)
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


extension MemberListViewController {
        func getAllMembers() async throws -> [Member] {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let stringURL = "\(appDelegate.APIURL)/member"
            
            guard let url = URL(string: stringURL) else {
                throw GHError.invalidURL
            }
            var request = URLRequest(url: url)
            let (data,response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw GHError.invalidResponse
            }
                
                do {
                    let decoder = JSONDecoder()
                    let members = try decoder.decode([Member].self, from: data)
                    
                    if(self.dynamicSearchText != ""){
                        self.members = members
                        self.filteredMembers = self.members.filter({ $0.fullname.lowercased().contains(self.dynamicSearchText.lowercased()) })
                        self.collectionView.reloadData()
                        self.updateSnapshot(for: self.filteredMembers)
                    } else {
                        self.members = members
                        self.filteredMembers = []
                        self.collectionView.reloadData()
                        self.updateSnapshot(for: self.members)
                    }
                    self.listStyleSegmentedControl.isEnabled = true
                    self.removeSpinner()
                    return members
                } catch {
                    throw GHError.invalidData
                }
        }
        func getBookmarkedMembers() async throws -> [Member]{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let endpoint = "\(appDelegate.APIURL)/favourite/getBookmarkedUsers"
            let params = [
                "user_id": memberId,
                "fav_type": "member"
            ]
            
            guard let url = URL(string: endpoint) else {
                throw GHError.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            
            let (data,response) = try await URLSession.shared.data(for: request)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw GHError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([Member].self, from: data)
                
                self.filteredMembers = response
                
                if(self.dynamicSearchText != ""){
                    self.filteredMembers = self.filteredMembers.filter({ $0.fullname.lowercased().contains( self.dynamicSearchText.lowercased() ) })
                }
                self.collectionView.reloadData()
                self.updateSnapshot(for: self.filteredMembers)
                self.listStyleSegmentedControl.isEnabled = true
                self.removeSpinner()
                return response
            } catch {
                throw GHError.invalidData
            }
        }
    }
