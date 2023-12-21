//
//  FavoritesVC.swift
//  CSID_App
//
//  Created by Vince Muller on 9/13/23.
//

import UIKit
import SQLite3
import CloudKit

class SearchVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var pointer:    OpaquePointer?
    var searchInProgress = false
    var collectionView: UICollectionView!
    let searchController = UISearchController()
    
    //Category colors and labels
    let categories = Category()
    
    //Variable for filtered search results
    var filteredUSDAFoodData: [USDAFoodDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let dbPointer = CADatabaseHelper.getDatabasePointer(databaseName: "CSIDAssistFoodDatabase.db") {
            pointer = dbPointer
        } else {
            print("Something went wrong!")
        }
        
        let queryPrimer = CADatabaseQueryHelper.queryDatabaseCategorySearch(categorySearchTerm: "", searchTerm: "", databasePointer: pointer)
        
        configureViewController()
        configureSearchController()
        configureCollectionView()
    }
    
    func configureSearchController() {
        let searchBar                               = searchController.searchBar
        searchBar.delegate                          = self
        searchController.searchBar.placeholder      = "Whole foods, packaged meals, and more"
        navigationItem.searchController             = searchController
        navigationItem.hidesSearchBarWhenScrolling  = false
        searchBar.scopeButtonTitles                 = ["USDA Foods", "Your Foods"]
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)

        collectionView.delegate         = self
        collectionView.dataSource       = self
        collectionView.backgroundColor  = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100 ),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchInProgress == false {
            return categories.list.count
        } else {
            return filteredUSDAFoodData.count 
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as! CollectionViewCell
        var brandOwner: String
        var brandName: String
        
        if searchInProgress == false {
            cell.backgroundColor                = categories.colors[indexPath.row]
            cell.categoryLabel.text             = categories.list[indexPath.row]
            cell.categoryIcon.backgroundColor   = nil
            cell.descriptionLabel.text          = nil

            cell.separatorLine.backgroundColor  = nil
            cell.layer.cornerRadius             = 10
            
            return cell
        } else {
            cell.backgroundColor                = nil
            cell.categoryLabel.text             = nil
            cell.categoryIcon.backgroundColor   = .systemMint
            cell.layer.cornerRadius             = 0
            
            let description = filteredUSDAFoodData[indexPath.row].description.capitalized 
            
            if filteredUSDAFoodData[indexPath.row].brandName=="" && filteredUSDAFoodData[indexPath.row].brandOwner=="" {
                cell.descriptionLabel.text = description
            } else if filteredUSDAFoodData[indexPath.row].brandName != "" && filteredUSDAFoodData[indexPath.row].brandOwner != "" {
                brandOwner = filteredUSDAFoodData[indexPath.row].brandOwner?.capitalized ?? ""
                brandName = filteredUSDAFoodData[indexPath.row].brandName?.capitalized ?? ""
                cell.descriptionLabel.text = "\(brandOwner) | \(brandName)\n\(description)"
            } else if filteredUSDAFoodData[indexPath.row].brandName != "" {
                brandName = filteredUSDAFoodData[indexPath.row].brandName?.capitalized ?? ""
                cell.descriptionLabel.text = "\(brandName)\n\(description)"
            } else {
                brandOwner = filteredUSDAFoodData[indexPath.row].brandOwner?.capitalized ?? ""
                cell.descriptionLabel.text = "\(brandOwner)\n\(description)"
            }
 
            cell.separatorLine.backgroundColor  = .label
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let foodDetailsVC       = CSIDFoodDetailsVC()
        let categorySearchVC    = CategorySearchVC()
        
        if searchInProgress == true {
            foodDetailsVC.passedData                = filteredUSDAFoodData[indexPath.row]
            foodDetailsVC.passedPointer             = pointer
            foodDetailsVC.modalPresentationStyle    = .popover
            foodDetailsVC.title                     = "CSIDAssist"
            self.present(foodDetailsVC, animated: true)
        } else {
            //let queryResult: [USDAFoodDetails] = []
            let selection   = categories.list[indexPath.row]
            let queryResult = CADatabaseQueryHelper.queryDatabaseCategorySearch(categorySearchTerm: selection, searchTerm: "", databasePointer: pointer)
            categorySearchVC.category                 = selection
            categorySearchVC.passedUSDACategoryData   = queryResult
            categorySearchVC.passedPointer            = pointer
            navigationController?.pushViewController(categorySearchVC, animated: true)
            
        }
    }
    
}

extension SearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        var searchTerms = ""
        
        let filter = searchBar.text
        
        searchInProgress = true
        filteredUSDAFoodData = []
        
        var searchComponents = filter!.lowercased().components(separatedBy: " ")
        searchComponents = searchComponents.filter{$0 != ""}
        
        var count = 0
        while count < searchComponents.count {
            if count==0 {
                searchTerms = "USDAFoodDetails.searchKeyWords LIKE '%\(searchComponents[count])%' "
            } else {
                searchTerms = searchTerms + "AND USDAFoodDetails.searchKeyWords LIKE '%\(searchComponents[count])%'"
            }
            count = count + 1
        }
        
        let queryResult = CADatabaseQueryHelper.queryDatabaseGeneralSearch(searchTerms: searchTerms, databasePointer: pointer)
        filteredUSDAFoodData = queryResult
        
        collectionView.reloadData()
        collectionView.setCollectionViewLayout(UIHelper.createOneColumnFlowLayout(in: view), animated: false)
        
        guard filteredUSDAFoodData.count != 0 else {
            return
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchInProgress = false
        searchController.searchBar.showsCancelButton = false
        collectionView.reloadData()
        collectionView.setCollectionViewLayout(UIHelper.createTwoColumnFlowLayout(in: view), animated: false)
        searchBar.showsScopeBar = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = true
        searchBar.showsScopeBar                      = true
    }
    
}
