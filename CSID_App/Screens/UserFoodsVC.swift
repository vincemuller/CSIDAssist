//
//  UserFoodsVC.swift
//  CSID_App
//
//  Created by Vince Muller on 12/31/23.
//

import UIKit
import CloudKit

class UserFoodsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var collectionView: UICollectionView!
    let searchController = UISearchController()
    
    var navBarHeight: CGFloat?
    var tabBarHeight: CGFloat?
    
    //Variable for filtered search results
    var passedUserFoods: [YourFoodItem] = []
    var filteredUserFoods: [YourFoodItem] = []
    var category:   String = ""
    var recordID:   CKRecord.ID?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 100
        tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 84
        
        configureViewController()
        configureCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        filteredUserFoods = passedUserFoods
        collectionView.reloadData()
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
        return passedUserFoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as! CollectionViewCell
        
        cell.backgroundColor                = nil
        cell.categoryLabel.text             = nil
        cell.categoryIcon.backgroundColor   = .systemMint
        cell.layer.cornerRadius             = 0
        
        cell.descriptionLabel.text = passedUserFoods[indexPath.row].description.capitalized
        
        cell.separatorLine.backgroundColor  = .label
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userFoodDetailsVC = UserFoodDetails()
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            cell.backgroundColor = .systemGray5
        }
        
        userFoodDetailsVC.passedData                = filteredUserFoods[indexPath.row]
        userFoodDetailsVC.modalPresentationStyle    = .popover
        userFoodDetailsVC.title                     = "CSIDAssist"
        
        self.present(userFoodDetailsVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            cell.backgroundColor = nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        let userFoodItem = passedUserFoods[indexPath.row]
        passedUserFoods.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
        
        ckRecordDeletion(id: userFoodItem.recordID)
        collectionView.reloadData()
        return true
    }
    
    func ckRecordDeletion(id: CKRecord.ID) {
        let container = CKContainer.default()
        let database = container.privateCloudDatabase
        
        database.delete(withRecordID: id) { id, error in
            if let error = error {
                self.presentGFAlertOnMain(title: "Unable to Remove", message: error.localizedDescription, buttonTitle: "Ok")
                return
            }
            self.presentGFAlertOnMain(title: "Successfully Removed", message: "You successfully removed your food item", buttonTitle: "Ok")
        }
    }

}
