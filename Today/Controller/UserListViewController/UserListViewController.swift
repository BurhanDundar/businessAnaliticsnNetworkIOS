/*
 See LICENSE folder for this sample’s licensing information.
 */

// filtre sisteminden pek emin değilim

import UIKit

class UserListViewController: UICollectionViewController {
        
        typealias DataSource = UICollectionViewDiffableDataSource<Int, User.ID>
        typealias Snapshot = NSDiffableDataSourceSnapshot<Int, User.ID>
    
        var company_id: String?
        var isFollowingUsers: Bool?
        var specialFilterUsers: [User] = [User]()
        
        var users: [User] = User.sampleData
        var filteredUsers: [User] = []
        var dataSource: DataSource!
        var isSearching: Bool = false
        var listStyleSelectedIndex: Int = 0
        var dynamicSearchText: String = ""
        var isUserInBookmarkedArray: Bool = false
    
        var memberId: String = ""
        var memberFullName: String = ""
        var memberUsername: String = ""
        var userFavs: [String] = [String]()
        var searchController: UISearchController!
    
        let listStyleSegmentedControl = UISegmentedControl(items: ["all","bookmarked"])
    
         override func viewDidLoad() {
             let defaults = UserDefaults.standard
             self.memberId = defaults.string(forKey: "memberId") ?? ""
             self.memberFullName = defaults.string(forKey: "memberFullName") ?? ""
             
                          
             view.backgroundColor = .systemBackground //.white
             
             //self.getUsers()
             navigationItem.title = "Members"
             let filterBarButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(didPressFilterButton))
             navigationItem.rightBarButtonItem = filterBarButton
                 let profileBarButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill"), style: .plain, target: self, action: #selector(didPressProfileButton))
                 navigationItem.leftBarButtonItem = profileBarButton
             
             DispatchQueue.main.async {
                 let appDelegate = UIApplication.shared.delegate as! AppDelegate
                 self.specialFilterUsers = appDelegate.UserSpecialFilterUsers as [User]
                 if self.filteredUsers.count == 0 {
                     if self.company_id != nil {
                         User.sampleData = []
                         self.getCompanyUsers()
                     } else if self.specialFilterUsers.count > 0 {
                         User.sampleData = []
                         self.loadFilteredUsers()
                     } else {
                         User.sampleData = []
                         self.getUsers()
                     }
                 }
             }
             
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
                 if(self.listStyleSelectedIndex == 1) {
                     user = self.filteredUsers[indexPath.item]
                 } else if(self.listStyleSelectedIndex == 0) {
                     user = self.filteredUsers.count > 0 ? self.filteredUsers[indexPath.item] : self.users[indexPath.item]
                 }
                 
                 var contentConfiguration = cell.defaultContentConfiguration()
                 contentConfiguration.text = user.full_name
                 contentConfiguration.secondaryText = user.title
                 
                 self.isUserInBookmarkedArray = self.userFavs.contains(user.id!) ? true : false
                 let systemImageName = self.isUserInBookmarkedArray ? "bookmark.fill" :  "bookmark"
                 
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
             
                          
             updateSnapshot(for: self.users)
         }
    
    override func collectionView(
        _ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        let id = filteredUsers.count > 0 ? filteredUsers[indexPath.item].id : users[indexPath.item].id // isSearching?
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
    
    func pushDetailViewForUser(withId id:User.ID){
        let user = user(withId: id)
        self.isUserInBookmarkedArray = self.userFavs.contains(user.id!) ? true : false
        let viewController = UserViewController(user: user, isUserBookmarked: self.isUserInBookmarkedArray)
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
    
    private func getUsers(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stringURL = "\(appDelegate.APIURL)/user"
        
        guard let url = URL(string: stringURL) else { return }
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("there was an error: \(error.localizedDescription)")
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let users = try decoder.decode([User].self, from: data)
                DispatchQueue.main.async {
                    self.users = users
                    User.sampleData = self.users
                    self.filteredUsers = []
                    self.collectionView.reloadData()
                    self.updateSnapshot(for: self.users)
                }
            } catch {
                print("Error Occured!")
            }
            
        }
        session.resume()
    }
    
    private func getCompanyUsers(){
        
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let stringURL = "\(appDelegate.APIURL)/user/getCompanyUsersAsUserObj"
            let params = [
                "company_id": self.company_id,
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
                    let companyUsers = try decoder.decode([User].self, from: data)
                    DispatchQueue.main.async {
                        self.users = companyUsers
                        User.sampleData = self.users
                        self.filteredUsers = []
                        self.collectionView.reloadData()
                        self.updateSnapshot(for: self.users)
                    }
                } catch {
                    print("Error Occured!")
                }
                
            }
            
            session.resume()
        }
    
    private func getMemberFavAsUserIds(){
        
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let stringURL = "\(appDelegate.APIURL)/favourite/getMemberFavAsUserIds"
            let params = [
                "user_id": memberId,
                "fav_type": "user"
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
                    let userFavs = try decoder.decode([String].self, from: data)
                    DispatchQueue.main.async {
                        self.userFavs = userFavs
                        appDelegate.memberUserFavs = self.userFavs
                        self.collectionView.reloadData() // bundan emin değilim
                    }
                } catch {
                    print("Error Occured!")
                }
                
            }
            
            session.resume()
        }
    
    func loadFilteredUsers(){
        self.users = self.specialFilterUsers
        User.sampleData = self.specialFilterUsers
        self.filteredUsers = [] //self.specialFilterUsers
        self.collectionView.reloadData()
        self.updateSnapshot(for: self.specialFilterUsers)
    }
}

extension UserListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            var res = [User]()
            self.dynamicSearchText = searchText
            if searchText.isEmpty {
                self.isSearching = false
                self.dynamicSearchText = ""
                if(self.listStyleSelectedIndex == 1){
                    Task{
                        do {
                            res = try await getBookmarkedUsers()
                            } catch {
                                print("Oops!")
                            }
                    }
                    self.filteredUsers = res
                    self.updateSnapshot(for: self.filteredUsers) // DÖN BURAYAAA
                } else {
                    self.filteredUsers = []
                    self.updateSnapshot(for: self.users)
                }
            } else {
                self.isSearching = true
                if(self.listStyleSelectedIndex == 1) {
                    let bookmarkedFilteredValues = self.filteredUsers.filter({ $0.full_name.lowercased().contains(searchText.lowercased()) })
                    self.filteredUsers = bookmarkedFilteredValues
                    self.updateSnapshot(for: bookmarkedFilteredValues)
                } else if(self.listStyleSelectedIndex == 0) {
                    let allFilteredUsers = User.sampleData.filter({ $0.full_name.lowercased().contains(searchText.lowercased()) })
                    self.filteredUsers = allFilteredUsers
                    self.updateSnapshot(for: allFilteredUsers)
                }
            }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        var res = [User]()
            self.isSearching = false
            self.dynamicSearchText = ""
            if(self.listStyleSelectedIndex == 1){
                Task{
                    do {
                        res = try await getBookmarkedUsers()
                    } catch {
                        print("Oops!")
                    }
                }
                self.filteredUsers = res
                updateSnapshot(for: self.filteredUsers)
            } else {
                self.filteredUsers = []
                self.updateSnapshot(for: User.sampleData)
            }
    }
    
    
    
    
    @objc private func filterMembers(){
        print("filter members")
    }
    
    @objc private func bookmark(){
        print("bookmark is tapped")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(self.filteredUsers.count == 0){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.specialFilterUsers = appDelegate.UserSpecialFilterUsers as [User]
            if(self.specialFilterUsers.count > 0){
                User.sampleData = []
                self.loadFilteredUsers()
                
                let clearFilter = UIBarButtonItem(image: UIImage(systemName: "arrow.counterclockwise"), style: .plain, target: self, action: #selector(clearFilter))
                navigationItem.leftBarButtonItem = clearFilter
            }
            self.getMemberFavAsUserIds()
        }
    }
    
    @objc private func clearFilter(_ sender: Any){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.UserSpecialFilterUsers = []
        self.specialFilterUsers = []
        User.sampleData = []
        self.filteredUsers = []
        self.getUsers()
        let profileBarButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill"), style: .plain, target: self, action: #selector(didPressProfileButton))
        navigationItem.leftBarButtonItem = profileBarButton
    }
    
    
}
    enum GHError: Error {
        case invalidURL
        case invalidResponse
        case invalidData
    }

    
    
extension UserListViewController {
        func getAllUsers() async throws -> [User] {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let stringURL = "\(appDelegate.APIURL)/user"
                        
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
                    let users = try decoder.decode([User].self, from: data)
                    
                    if(self.dynamicSearchText != ""){
                        self.users = users
                        self.filteredUsers = self.users.filter({ $0.full_name.lowercased().contains(self.dynamicSearchText.lowercased()) })
                        self.collectionView.reloadData()
                        self.updateSnapshot(for: self.filteredUsers)
                    } else {
                        self.users = users
                        self.filteredUsers = []
                        self.collectionView.reloadData()
                        self.updateSnapshot(for: self.users)
                    }
                    return users // burda ne dönmeli emin değilim bakarsın sonra
                } catch {
                    throw GHError.invalidData
                }
        }
        func getBookmarkedUsers() async throws -> [User]{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let endpoint = "\(appDelegate.APIURL)/favourite/getBookmarkedUsers"
            let params = [
                "user_id": memberId,
                "fav_type": "user"
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
                let response = try decoder.decode([User].self, from: data)
                self.filteredUsers = response
                
                if(self.dynamicSearchText != ""){
                    self.filteredUsers = self.filteredUsers.filter({ $0.full_name.lowercased().contains( self.dynamicSearchText.lowercased() ) })
                }
                self.collectionView.reloadData()
                self.updateSnapshot(for: self.filteredUsers)
                return response
            } catch {
                throw GHError.invalidData
            }
        }
    }
