//
//  FollowingCompaniesListViewController.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 13.06.2023.
//

import UIKit

class FollowingCompaniesListViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Company.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Company.ID>
    
        var companies: [Company]! // = Company.sampleData
        var filteredCompanies: [Company] = []
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
             super.viewDidLoad()
             Company.sampleData = self.companies
             navigationItem.title = "Companies"

             lazy var searchController: UISearchController = {
                 let searchController = UISearchController(searchResultsController: nil)
                 // searchController.dimsBackgroundDuringPresentation = false
                 searchController.hidesNavigationBarDuringPresentation = false
                 searchController.searchBar.delegate = self
                 return searchController
             }()
             
             
             
             navigationItem.searchController = searchController

             let listLayout = listLayout()
             collectionView.collectionViewLayout = listLayout
             
             let cellRegistration = UICollectionView.CellRegistration {
                 (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: Company.ID) in
                 var company: Company!
                 company = self.filteredCompanies.count > 0 ?  self.filteredCompanies[indexPath.item] : self.companies[indexPath.item]
                 
                 var contentConfiguration = cell.defaultContentConfiguration()
                 contentConfiguration.text = company.name
                 contentConfiguration.secondaryText = company.type
                 
                 contentConfiguration.image = UIImage(systemName: "building.fill")
                 cell.contentConfiguration = contentConfiguration
             }

             dataSource = DataSource(collectionView: collectionView) {
                 (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Company.ID) in
                 return collectionView.dequeueConfiguredReusableCell(
                     using: cellRegistration, for: indexPath, item: itemIdentifier)
             }
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
    
    func updateCompany(_ company: Company) {
            let index = self.companies.indexOfCompany(withId: company.id)
            self.companies[index] = company
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if (segue.identifier == "ShowFollowingCompanyDetail") {
          let followingCompanyVC = segue.destination as! FollowingCompanyViewController
          let object = sender as! [String: Company?]
           followingCompanyVC.company = object["company"] as! Company
       }
        
    }
    
    func pushDetailViewForCompany(withId id:Company.ID){
        let company = company(withId: id)
        DispatchQueue.main.async {
            let sender: [String: Company?] = [ "company": company ]
            self.performSegue(withIdentifier: "ShowFollowingCompanyDetail", sender: sender)
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
        fetchedImageView.loadImage(url)
    }
}

extension FollowingCompaniesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.dynamicSearchText = searchText
        if searchText.isEmpty {
            isSearching = false
            self.dynamicSearchText = ""
            self.filteredCompanies = []
            updateSnapshot(for: self.companies)
        } else {
            isSearching = true
            let allFilteredCompanies = Company.sampleData.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
            self.filteredCompanies = allFilteredCompanies
            updateSnapshot(for: allFilteredCompanies)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        self.dynamicSearchText = ""
        self.filteredCompanies = []
        updateSnapshot(for: Company.sampleData)
    }
}

