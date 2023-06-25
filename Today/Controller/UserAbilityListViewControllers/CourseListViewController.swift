//
//  CourseListViewController.swift
//  Today
//
//  Created by Yapı Kredi Teknoloji A.Ş. on 4.06.2023.
//

import UIKit

class CourseListViewController: UICollectionViewController {
        
        typealias DataSource = UICollectionViewDiffableDataSource<Int, Course.ID>
        typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Course.ID>
        
        var courses: [Course] = Course.sampleData
        var filteredCourses: [Course] = []
        var dataSource: DataSource!
        var isSearching: Bool = false
        var dynamicSearchText: String = ""
    
        // search bar
        var searchController: UISearchController!
    
         override func viewDidLoad() {
             
             let appDelegate = UIApplication.shared.delegate as! AppDelegate
             Course.sampleData = appDelegate.userCourses as [Course]
             self.courses = Course.sampleData
             
             
             view.backgroundColor = .systemBackground
             navigationItem.title = "User Courses"
             
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
                 (cell: UICollectionViewListCell, indexPath: IndexPath, itemIdentifier: Course.ID) in
                 var course: Course!
                course = self.filteredCourses.count > 0 ? self.filteredCourses[indexPath.item] : self.courses[indexPath.item]
                 
                 var contentConfiguration = cell.defaultContentConfiguration()
                 contentConfiguration.text = course.title
                 contentConfiguration.secondaryText = course.company_name ?? ""
                 cell.contentConfiguration = contentConfiguration
             }

             dataSource = DataSource(collectionView: collectionView) {
                 (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Course.ID) in
                 return collectionView.dequeueConfiguredReusableCell(
                     using: cellRegistration, for: indexPath, item: itemIdentifier)
             }
                          
             updateSnapshot(for: Course.sampleData)
         }
    
    func course(withId id: Course.ID) -> Course {
        let index = courses.indexOfCourse(withId: id)
        return courses[index]
    }

     private func listLayout() -> UICollectionViewCompositionalLayout {
         var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
         listConfiguration.showsSeparators = true
         listConfiguration.backgroundColor = .clear
         return UICollectionViewCompositionalLayout.list(using: listConfiguration)
     }
    
    func updateSnapshot(for pCourses: [Course]){
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(pCourses.map { $0.id })
        dataSource.apply(snapshot)
        collectionView.dataSource = dataSource
    }
}

extension CourseListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.dynamicSearchText = searchText
        if searchText.isEmpty {
            isSearching = false
            self.dynamicSearchText = ""
            self.filteredCourses = []
            updateSnapshot(for: self.courses)
        } else {
            isSearching = true
            let allFilteredCourses = Course.sampleData.filter({ $0.title.lowercased().contains(searchText.lowercased()) })
            self.filteredCourses = allFilteredCourses
            updateSnapshot(for: allFilteredCourses)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        self.dynamicSearchText = ""
        self.filteredCourses = []
        updateSnapshot(for: Course.sampleData)
    }
    
    @objc private func filterMembers(){
        print("filter members")
    }
}
