//
//  CategorySearchVC.swift
//  CSID_App
//
//  Created by Vince Muller on 11/30/23.
//

import UIKit

class FavoritesVC: UIViewController, FavoriteArtefactsDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var passedPointer: OpaquePointer?
    var collectionView: UICollectionView!
    let searchController = UISearchController()
    
    var navBarHeight: CGFloat?
    var tabBarHeight: CGFloat?
    
    var filteredUSDAData: [USDAFoodDetails] = []
    var category:   String = ""
    let emptyFavorites = EmptyCollectionView(text: "You have no favorited foods :(")
    
    //Category colors and labels
    let categories = Category()
    
    var userFavs: [USDAFoodDetails] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 100
        tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 84
        
        if let dbPointer = CADatabaseHelper.getDatabasePointer(databaseName: "CSIDAssistFoodDatabase.db") {
            passedPointer = dbPointer
        } else {
        }
        configureViewController()
        configureSearchController()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getUserFavs()
        collectionView.backgroundView   = {filteredUSDAData.count == 0 ? emptyFavorites : nil}()
        collectionView.reloadData()
    }
    
    func getUserFavs() {
        userFavs = PersistenceManager.getUserFavs()
        filteredUSDAData = userFavs
    }
    
    func configureSearchController() {
        let searchBar                               = searchController.searchBar
        searchBar.delegate                          = self
        searchController.searchBar.placeholder      = "Search \(category)"
        navigationItem.searchController             = searchController
        navigationItem.hidesSearchBarWhenScrolling  = false
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createOneColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
        
        collectionView.delegate             = self
        collectionView.dataSource           = self
        collectionView.backgroundColor      = .systemBackground
        collectionView.backgroundView       = {filteredUSDAData.count == 0 ? emptyFavorites : nil}()
        collectionView.alwaysBounceVertical = true
        collectionView.bounces              = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: navBarHeight!),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarHeight!+5)),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUSDAData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as! CollectionViewCell
        let index = categories.list.firstIndex(where: {$0 == filteredUSDAData[indexPath.row].brandedFoodCategory})
        
        var brandOwner: String
        var brandName: String
        
        cell.backgroundColor                = nil
        cell.categoryIcon.backgroundColor   = categories.colors[index ?? 0]
        cell.image.image                    = UIImage(named: filteredUSDAData[indexPath.row].brandedFoodCategory)
        cell.layer.cornerRadius             = 0
        
        let description = filteredUSDAData[indexPath.row].description.capitalized
        
        if filteredUSDAData[indexPath.row].brandName=="" && filteredUSDAData[indexPath.row].brandOwner=="" {
            cell.descriptionLabel.text = description
        } else if filteredUSDAData[indexPath.row].brandName != "" && filteredUSDAData[indexPath.row].brandOwner != "" {
            brandOwner = filteredUSDAData[indexPath.row].brandOwner?.capitalized ?? ""
            brandName = filteredUSDAData[indexPath.row].brandName?.capitalized ?? ""
            cell.descriptionLabel.text = "\(brandOwner) | \(brandName)\n\(description)"
        } else if filteredUSDAData[indexPath.row].brandName != "" {
            brandName = filteredUSDAData[indexPath.row].brandName?.capitalized ?? ""
            cell.descriptionLabel.text = "\(brandName)\n\(description)"
        } else {
            brandOwner = filteredUSDAData[indexPath.row].brandOwner?.capitalized ?? ""
            cell.descriptionLabel.text = "\(brandOwner)\n\(description)"
        }
        
        cell.separatorLine.backgroundColor  = .label
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let foodDetailsVC           = CSIDFoodDetailsVC()
        let wholeFoodDetailsVC      = WholeFoodDetailsVC()
        foodDetailsVC.delegate      = self
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            cell.backgroundColor = .systemGray5
        }
        
        if filteredUSDAData[indexPath.row].wholeFood == "yes" {
            wholeFoodDetailsVC.passedData               = filteredUSDAData[indexPath.row]
            wholeFoodDetailsVC.passedPointer            = passedPointer
            wholeFoodDetailsVC.modalPresentationStyle   = .popover
            wholeFoodDetailsVC.title                    = "CSIDAssist"
            self.present(wholeFoodDetailsVC, animated: true)
        } else {
            foodDetailsVC.passedData                = filteredUSDAData[indexPath.row]
            foodDetailsVC.passedPointer             = passedPointer
            foodDetailsVC.modalPresentationStyle    = .popover
            foodDetailsVC.title                     = "CSIDAssist"
            
            self.present(foodDetailsVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            cell.backgroundColor = nil
        }
    }
    
}

extension FavoritesVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTerms = searchBar.text, searchTerms.count > 0 else {
            return
        }
        filteredUSDAData = userFavs.filter( { $0.searchKeyWords.lowercased().contains(searchTerms.lowercased()) } )

        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredUSDAData = userFavs
        collectionView.reloadData()
    }
    
    func updateFavoritesCollectionView() {
        getUserFavs()
        collectionView.backgroundView   = {filteredUSDAData.count == 0 ? emptyFavorites : nil}()
        collectionView.reloadData()
    }
    
}

