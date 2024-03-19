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
    
    var navBarHeight: CGFloat?
    var tabBarHeight: CGFloat?
    
    //Category colors and labels
    let categories = Category()
    var wholeFoodsFilter = ""
    
    
    //Variable for filtered search results
    var filteredUSDAFoodData: [USDAFoodDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 100
        tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 84
        
        if let dbPointer = CADatabaseHelper.getDatabasePointer(databaseName: "CSIDAssistFoodDatabase.db") {
            pointer = dbPointer
        } else {
        }
        let queryPrimer = CADatabaseQueryHelper.queryDatabaseCategorySearch(categorySearchTerm: "", searchTerm: "", wholeFoodsFilter: "", databasePointer: pointer)
        
        configureViewController()
        configureSearchController()
        configureCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func configureSearchController() {
        let searchBar                                   = searchController.searchBar
        searchBar.delegate                              = self
        searchController.searchBar.placeholder          = "Whole foods, packaged meals, and more"
        navigationItem.searchController                 = searchController
        navigationItem.hidesSearchBarWhenScrolling      = false
        searchController.searchBar.scopeButtonTitles    = ["Whole Foods", "All Foods", "Branded Foods"]
        searchController.searchBar.selectedScopeButtonIndex = 1
        searchController.scopeBarActivation                 = .onSearchActivation
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
        collectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: CategoriesCollectionViewCell.reuseID)
        
        collectionView.delegate         = self
        collectionView.dataSource       = self
        collectionView.backgroundColor  = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: navBarHeight!),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarHeight!+5)),
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
        
        var brandOwner: String
        var brandName: String
        
        if searchInProgress == false {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.reuseID, for: indexPath) as! CategoriesCollectionViewCell
            cell.backgroundColor                = categories.colors[indexPath.row]
            cell.categoryLabel.text             = categories.list[indexPath.row]
            cell.categoryIcon.image             = UIImage(named: categories.list[indexPath.row])
            
            return cell
        } else {
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as! CollectionViewCell
            let index = categories.list.firstIndex(where: {$0 == filteredUSDAFoodData[indexPath.row].brandedFoodCategory})
            
            
            cell.backgroundColor                = nil
            cell.categoryIcon.backgroundColor   = categories.colors[index ?? 0]
            cell.image.image                    = UIImage(named: filteredUSDAFoodData[indexPath.row].brandedFoodCategory)
            
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
        let foodDetailsVC                       = CSIDFoodDetailsVC()
        let wholeFoodDetailsVC                  = WholeFoodDetailsVC()
        let categorySearchVC                    = CategorySearchVC()
        let userFoodsVC                         = UserFoodsVC()
        var queryResult: [USDAFoodDetails]      = []
        var queriedUserFoods: [UserFoodItem]    = []
        
        if searchInProgress == true && filteredUSDAFoodData[indexPath.row].wholeFood != "yes" {
            foodDetailsVC.passedData                = filteredUSDAFoodData[indexPath.row]
            foodDetailsVC.passedPointer             = pointer
            foodDetailsVC.modalPresentationStyle    = .popover
            foodDetailsVC.title                     = "CSIDAssist"
            self.present(foodDetailsVC, animated: true)
        } else if searchInProgress == true && filteredUSDAFoodData[indexPath.row].wholeFood == "yes" {
            wholeFoodDetailsVC.passedData                = filteredUSDAFoodData[indexPath.row]
            wholeFoodDetailsVC.passedPointer             = pointer
            wholeFoodDetailsVC.modalPresentationStyle    = .popover
            wholeFoodDetailsVC.title                     = "CSIDAssist"
            self.present(wholeFoodDetailsVC, animated: true)
        }
        else {
            //let queryResult: [USDAFoodDetails] = []
            let selection   = categories.list[indexPath.row]
            if selection != "Your Foods" {
                queryResult = CADatabaseQueryHelper.queryDatabaseCategorySearch(categorySearchTerm: selection, searchTerm: "", wholeFoodsFilter: "", databasePointer: pointer)
                categorySearchVC.category                 = selection
                categorySearchVC.passedUSDACategoryData   = queryResult
                categorySearchVC.passedPointer            = pointer
                navigationController?.pushViewController(categorySearchVC, animated: true)
            } else {
                navigationController?.pushViewController(userFoodsVC, animated: true)
            }
            
        }
    }
}

extension SearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        if selectedScope == 0 {
            wholeFoodsFilter = "USDAFoodDetails.wholeFood='yes' AND"
        } else if selectedScope == 2 {
            wholeFoodsFilter = "USDAFoodDetails.wholeFood='no' AND"
        } else {
            wholeFoodsFilter = ""
        }
        
        guard let searchComponents = searchController.searchBar.text, searchComponents.count > 1 else { return }
        searchBarSearchButtonClicked(searchController.searchBar)
    }
    
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
                searchTerms = "\(wholeFoodsFilter) USDAFoodDetails.searchKeyWords LIKE '%\(searchComponents[count])%' "
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
        searchController.searchBar.selectedScopeButtonIndex = 1
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = true
    }
    
}
