//
//  CategorySearchVC.swift
//  CSID_App
//
//  Created by Vince Muller on 11/30/23.
//

import UIKit

class CategorySearchVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var passedPointer: OpaquePointer?
    var collectionView: UICollectionView!
    let searchController = UISearchController()
    
    var navBarHeight: CGFloat?
    var tabBarHeight: CGFloat?
    
    //Variable for filtered search results
    var passedUSDACategoryData: [USDAFoodDetails] = []
    var filteredUSDACategoryData: [USDAFoodDetails] = []
    
    let categories = Category()
    var category:   String = ""
    var wholeFoodsFilter = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 100
        tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 84
        
        filteredUSDACategoryData = passedUSDACategoryData
        
        configureViewController()
        configureSearchController()
        configureCollectionView()
    }
    
    func configureSearchController() {
        let searchBar                               = searchController.searchBar
        searchBar.delegate                          = self
        searchController.searchBar.placeholder      = "Search \(category)"
        navigationItem.searchController             = searchController
        navigationItem.hidesSearchBarWhenScrolling  = false
        searchController.searchBar.scopeButtonTitles    = ["Whole Foods", "All Foods", "Branded Foods"]
        searchController.searchBar.selectedScopeButtonIndex = 1
        searchController.scopeBarActivation                 = .onSearchActivation
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createOneColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
        
        collectionView.delegate         = self
        collectionView.dataSource       = self
        collectionView.backgroundColor  = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: navBarHeight!),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarHeight!),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUSDACategoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as! CollectionViewCell
        var brandOwner: String
        var brandName: String
        let index = categories.list.firstIndex(where: {$0 == filteredUSDACategoryData[indexPath.row].brandedFoodCategory})
        
        cell.backgroundColor                = nil
        cell.categoryIcon.backgroundColor   = categories.colors[index ?? 0]
        cell.image.image                    = UIImage(named: categories.list[index ?? 0])
        cell.layer.cornerRadius             = 0
        
        let description = filteredUSDACategoryData[indexPath.row].description.capitalized
        
        if filteredUSDACategoryData[indexPath.row].brandName=="" && filteredUSDACategoryData[indexPath.row].brandOwner=="" {
            cell.descriptionLabel.text = description
        } else if filteredUSDACategoryData[indexPath.row].brandName != "" && filteredUSDACategoryData[indexPath.row].brandOwner != "" {
            brandOwner = filteredUSDACategoryData[indexPath.row].brandOwner?.capitalized ?? ""
            brandName = filteredUSDACategoryData[indexPath.row].brandName?.capitalized ?? ""
            cell.descriptionLabel.text = "\(brandOwner) | \(brandName)\n\(description)"
        } else if filteredUSDACategoryData[indexPath.row].brandName != "" {
            brandName = filteredUSDACategoryData[indexPath.row].brandName?.capitalized ?? ""
            cell.descriptionLabel.text = "\(brandName)\n\(description)"
        } else {
            brandOwner = filteredUSDACategoryData[indexPath.row].brandOwner?.capitalized ?? ""
            cell.descriptionLabel.text = "\(brandOwner)\n\(description)"
        }
        
        cell.separatorLine.backgroundColor  = .label
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let foodDetailsVC = CSIDFoodDetailsVC()
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            cell.backgroundColor = .systemGray5
        }
        
        foodDetailsVC.passedData                = filteredUSDACategoryData[indexPath.row]
        foodDetailsVC.passedPointer             = passedPointer
        foodDetailsVC.modalPresentationStyle    = .popover
        foodDetailsVC.title                     = "CSIDAssist"
        
        self.present(foodDetailsVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            cell.backgroundColor = nil
        }
    }
    
}

extension CategorySearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        if selectedScope == 0 {
            wholeFoodsFilter = "AND wholeFood='yes'"
        } else if selectedScope == 2 {
            wholeFoodsFilter = "AND wholeFood='no'"
        } else {
            wholeFoodsFilter = ""
        }
        
        searchBarSearchButtonClicked(searchController.searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        var searchTerms = ""
        
        let filter = searchBar.text
        
        var searchComponents = filter!.lowercased().components(separatedBy: " ")
        searchComponents = searchComponents.filter{$0 != ""}
        
        var count = 0
        while count < searchComponents.count {
            searchTerms = searchTerms + "AND USDAFoodDetails.searchKeyWords LIKE '%\(searchComponents[count])%' "
            count = count + 1
        }
        
        
        let queryResult = CADatabaseQueryHelper.queryDatabaseCategorySearch(categorySearchTerm: category, searchTerm: searchTerms, wholeFoodsFilter: wholeFoodsFilter, databasePointer: passedPointer)
        filteredUSDACategoryData = queryResult
        
        collectionView.reloadData()
        collectionView.setCollectionViewLayout(UIHelper.createOneColumnFlowLayout(in: view), animated: false)
        
        guard filteredUSDACategoryData.count != 0 else {
            return
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredUSDACategoryData = passedUSDACategoryData
        collectionView.reloadData()
        collectionView.setCollectionViewLayout(UIHelper.createOneColumnFlowLayout(in: view), animated: false)
        searchController.searchBar.selectedScopeButtonIndex = 1
    }
    
}

