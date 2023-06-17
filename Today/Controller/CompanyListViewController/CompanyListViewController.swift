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
         override func viewDidLoad() {
             self.getCompanies()
             navigationItem.title = "Companies"
             let filterBarButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(didPressFilterButton))
             navigationItem.rightBarButtonItem = filterBarButton
             
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
                 
                 
                 let systemImageName = company.isBookmarked ? "bookmark.fill" :  "bookmark"
                 
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
          let object = sender as! [String: Company?]
           companyVC.company = object["company"] as! Company
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
        DispatchQueue.main.async {
            let sender: [String: Company?] = [ "company": company ]
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
    
}

extension CompanyListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.dynamicSearchText = searchText
        if searchText.isEmpty {
            isSearching = false
            self.dynamicSearchText = ""
            if(listStyleSelectedIndex == 1){
                let bookmarkedFilteredValues = self.companies.filter({ $0.isBookmarked })
                self.filteredCompanies = bookmarkedFilteredValues
                updateSnapshot(for: bookmarkedFilteredValues)
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
        isSearching = false
        self.dynamicSearchText = ""
        if(listStyleSelectedIndex == 1){
            let bookmarkedFilteredValues = self.companies.filter({ $0.isBookmarked })
            self.filteredCompanies = bookmarkedFilteredValues
            updateSnapshot(for: bookmarkedFilteredValues)
        } else {
            self.filteredCompanies = []
            updateSnapshot(for: Company.sampleData)
        }
    }
    
    @objc private func filterMembers(){
        print("filter members")
    }
    
    @objc private func bookmark(){
        print("bookmark is tapped")
    }
    
}
