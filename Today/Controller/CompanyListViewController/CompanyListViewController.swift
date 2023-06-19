//
//  CompanyListViewController.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 31.05.2023.
//

import UIKit

class CompanyListViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Company.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Company.ID>
    
        var companies: [Company] = Company.sampleData
        var filteredCompanies: [Company] = []
        var dataSource: DataSource!
        var isSearching: Bool = false
        var listStyleSelectedIndex: Int = 0
        var dynamicSearchText: String = ""
        var companyFavs: [String] = [String]()
        var memberId: String = ""
        var memberFullName: String = ""
        var memberUsername: String = ""
    
        // search bar
        var searchController: UISearchController!
    
        let listStyleSegmentedControl = UISegmentedControl(items: ["all","bookmarked"])
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(self.filteredCompanies.count == 0){
            self.getMemberFavAsCompanyIds()
        }
    }
         override func viewDidLoad() {
             
             let defaults = UserDefaults.standard
             self.memberId = defaults.string(forKey: "memberId") ?? ""
             self.memberFullName = defaults.string(forKey: "memberFullName") ?? ""
             
//             self.getMemberFavAsCompanyIds()
             self.getCompanies()
             
             navigationItem.title = "Companies"
//             let filterBarButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(didPressFilterButton))
//             navigationItem.rightBarButtonItem = filterBarButton
             
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
                 (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: Company.ID) in
                 var company: Company!
                 if(self.listStyleSelectedIndex == 1) {
                     company = self.filteredCompanies[indexPath.item]
                 } else if(self.listStyleSelectedIndex == 0) {
                     // ?
                     company = self.filteredCompanies.count > 0 ?  self.filteredCompanies[indexPath.item] : self.companies[indexPath.item]
                 }
                 
                 var contentConfiguration = cell.defaultContentConfiguration()
                 contentConfiguration.text = company.name
                 contentConfiguration.secondaryText = company.type
                 
                 contentConfiguration.image = UIImage(systemName: "building.fill")
                 
                 let isCompanyInBookmarkedArray = self.companyFavs.contains(company.id!) ? true : false
                 let systemImageName = isCompanyInBookmarkedArray ? "bookmark.fill" :  "bookmark"
                 
                 let customAccessory = UICellAccessory.CustomViewConfiguration(
                   customView: UIImageView(image: UIImage(systemName: systemImageName)),
                   placement: .trailing(displayed: .always))
                 
                 cell.accessories = [.customView(configuration: customAccessory),.disclosureIndicator(displayed: .always)]
                 cell.contentConfiguration = contentConfiguration
             }

             dataSource = DataSource(collectionView: collectionView) {
                 (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Company.ID) in
                 return collectionView.dequeueConfiguredReusableCell(
                     using: cellRegistration, for: indexPath, item: itemIdentifier)
             }
             
             listStyleSegmentedControl.selectedSegmentIndex = listStyleSelectedIndex
             listStyleSegmentedControl.addTarget(
                self, action: #selector(didChangeListStyle(_:)), for: .valueChanged)
             
             navigationItem.titleView = listStyleSegmentedControl
             
                          
             updateSnapshot(for: Company.sampleData)
         }
    
    override func collectionView(
        _ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        let id = filteredCompanies.count > 0 ? filteredCompanies[indexPath.item].id : companies[indexPath.item].id // isSearching?
        pushDetailViewForCompany(withId: id)
        return false
    }
    
    func company(withId id: Company.ID) -> Company {
        let index = companies.indexOfCompany(withId: id)
        return companies[index]
    }
    internal func updateCompany(_ company: Company) {
            let index = self.companies.indexOfCompany(withId: company.id)
            self.companies[index] = company
       }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if (segue.identifier == "showCompanyDetail") {
          let companyVC = segue.destination as! CompanyViewController
          let object = sender as! [String: Any?]
           companyVC.company = object["company"] as! Company
           companyVC.isCompanyBookmarked = object["isCompanyBookmarked"] as! Bool
       }
        
    }
    @objc func didPressProfileButton (_ sender: UIBarButtonItem){
//        let viewController = ProfileViewController()
        
//        navigationController?.pushViewController(viewController, animated: true)
        performSegue(withIdentifier: "GoToProfilePage", sender: self)
        let backBarButtonItem = UIBarButtonItem(title: "Companies", style: .plain, target: nil, action: nil)
                navigationItem.backBarButtonItem = backBarButtonItem
    }
    func pushDetailViewForCompany(withId id:Company.ID){
        /*let company = company(withId: id)
        let viewController = CompanyViewController(company: company) // company: company, parent: self
        navigationController?.pushViewController(viewController, animated: true)*/
        let company = company(withId: id)
        let isCompanyInBookmarkedArray = self.companyFavs.contains(company.id!) ? true : false
        DispatchQueue.main.async {
            let sender: [String: Any?] = [ "company": company, "isCompanyBookmarked":  isCompanyInBookmarkedArray]
            self.performSegue(withIdentifier: "showCompanyDetail", sender: sender)
        }
     }

     private func listLayout() -> UICollectionViewCompositionalLayout {
         var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
         listConfiguration.showsSeparators = true
         listConfiguration.backgroundColor = .clear
         return UICollectionViewCompositionalLayout.list(using: listConfiguration)
     }
    
    func updateSnapshot(for pCompanies: [Company]){
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(pCompanies.map { $0.id })
        dataSource.apply(snapshot)
        collectionView.dataSource = dataSource
    }
    
    private func loadFetchedImage(for url: String){
        fetchedImageView.loadImage(url, "company")
    }
    
    private func getCompanies(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stringURL = "\(appDelegate.APIURL)/company" //"http://192.168.0.102:3001/company"
        
        guard let url = URL(string: stringURL) else { return }
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("there was an error: \(error.localizedDescription)")
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let companies = try decoder.decode([Company].self, from: data)
                DispatchQueue.main.async {
                    self.companies = companies
                    Company.sampleData = self.companies
                    self.filteredCompanies = []
                    self.collectionView.reloadData()
                    self.updateSnapshot(for: self.companies)
                }
            } catch {
                print("Error Occured!")
            }
            
        }
        session.resume()
    }
    
    private func getMemberFavAsCompanyIds(){
        
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let stringURL = "\(appDelegate.APIURL)/favourite/getMemberFavAsUserIds"
            let params = [
                "user_id": memberId,
                "fav_type": "company"
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
                    let companyFavs = try decoder.decode([String].self, from: data)
                    DispatchQueue.main.async {
                        self.companyFavs = companyFavs
                        appDelegate.memberCompanyFavs = self.companyFavs
                        self.collectionView.reloadData() // bundan emin değilim
                    }
                } catch {
                    print("Error Occured!")
                }
                
            }
            
            session.resume()
        }
    
}

extension CompanyListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var res = [Company]()
        self.dynamicSearchText = searchText
        if searchText.isEmpty {
            isSearching = false
            self.dynamicSearchText = ""
            if(listStyleSelectedIndex == 1){
                Task{
                    do {
                        res = try await getBookmarkedCompanies()
                    } catch {
                        print("Oops!")
                    }
                }
                self.filteredCompanies = res
                self.updateSnapshot(for: self.filteredCompanies) // DÖN BURAYAAA
            } else {
                self.filteredCompanies = []
                updateSnapshot(for: self.companies)
            }
        } else {
            isSearching = true
            if(listStyleSelectedIndex == 1) {
                let bookmarkedFilteredValues = self.filteredCompanies.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
                // bookmarkedFilteredValues = bookmarkedFilteredValues.filter({ $0.isBookmarked })
                self.filteredCompanies = bookmarkedFilteredValues
                updateSnapshot(for: bookmarkedFilteredValues)
            } else if(listStyleSelectedIndex == 0) {
                let allFilteredCompanies = Company.sampleData.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
                self.filteredCompanies = allFilteredCompanies
                updateSnapshot(for: allFilteredCompanies)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        var res = [Company]()
        isSearching = false
        self.dynamicSearchText = ""
        if(listStyleSelectedIndex == 1){
            Task{
                do {
                    res = try await getBookmarkedCompanies()
                } catch {
                    print("Oops!")
                }
            }
            self.filteredCompanies = res
            updateSnapshot(for: self.filteredCompanies)
        } else {
            self.filteredCompanies = []
            updateSnapshot(for: Company.sampleData)
        }
    }
}

extension CompanyListViewController {
        func getAllCompanies() async throws -> [Company] {

            let stringURL = "http://192.168.0.100:3001/company"
            
            
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
                    let companies = try decoder.decode([Company].self, from: data)
                    
                    if(self.dynamicSearchText != ""){
                        self.companies = companies
                        self.filteredCompanies = self.companies.filter({ $0.name.lowercased().contains(self.dynamicSearchText.lowercased()) })
                        self.collectionView.reloadData()
                        self.updateSnapshot(for: self.filteredCompanies)
                    } else {
                        self.companies = companies
                        self.filteredCompanies = []
                        self.collectionView.reloadData()
                        self.updateSnapshot(for: self.companies)
                    }
                    
                    return companies
                } catch {
                    throw GHError.invalidData
                }
        }
        func getBookmarkedCompanies() async throws -> [Company]{
            
            let endpoint = "http://192.168.0.100:3001/favourite/getBookmarkedUsers"
            let params = [
                "user_id": memberId,
                "fav_type": "company"
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
                let response = try decoder.decode([Company].self, from: data)
                
                self.filteredCompanies = response
                
                if(self.dynamicSearchText != ""){
                    self.filteredCompanies = self.filteredCompanies.filter({ $0.name.lowercased().contains( self.dynamicSearchText.lowercased() ) })
                }
                self.collectionView.reloadData()
                self.updateSnapshot(for: self.filteredCompanies)
                
                return response
            } catch {
                throw GHError.invalidData
            }
        }
    }
