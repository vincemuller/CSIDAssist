//
//  UserFoodsVC.swift
//  CSID_App
//
//  Created by Vince Muller on 12/31/23.
//

import UIKit
import CloudKit


class UserFoodsVC: UIViewController, RemoveUserFoodDelegate, UpdateUserFoodDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    var collectionView: UICollectionView!
    let searchController = UISearchController()
    
    var navBarHeight: CGFloat?
    var tabBarHeight: CGFloat?
    
    //Variable for filtered search results
    var passedUserFoods: [YourFoodItem] = []
    var category:   String = ""
    var recordID:   CKRecord.ID?
    
    //Category colors and labels
    let categories = Category()
    let emptyUserFoods = EmptyCollectionView(text: "You have no added foods :(")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task.init {
            do {
                guard userID != "" else {
                    self.presentGFAlertOnMain(title: CAAlertTitle.iCloudError.rawValue, message: CAAlertMessage.fetchFoodsError.rawValue, buttonTitle: "Ok")
                    return
                }
                let queriedUserFoods = try await self.queryUserFoods()
                passedUserFoods = queriedUserFoods
                collectionView.backgroundView = {passedUserFoods.count == 0 ? emptyUserFoods : nil}()
                collectionView.reloadData()
            } catch {
                self.presentGFAlertOnMain(title: CAAlertTitle.iCloudError.rawValue, message: CAAlertMessage.fetchFoodsError.rawValue, buttonTitle: "Ok")
            }
        }
        
        navBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 100
        tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 84
        
        configureViewController()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.backgroundView = {passedUserFoods.count == 0 ? emptyUserFoods : nil}()
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
        
        cell.layer.cornerRadius             = 0
        cell.backgroundColor                = nil
        cell.categoryIcon.backgroundColor   = categories.colors[0]
        cell.image.image                    = UIImage(named: "Your Foods")
        
        cell.descriptionLabel.text = passedUserFoods[indexPath.row].description.capitalized
        
        cell.separatorLine.backgroundColor  = .label
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userFoodDetailsVC = UserFoodDetails()
        
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            cell.backgroundColor = .systemGray5
        }
        userFoodDetailsVC.removeDelegate            = self
        userFoodDetailsVC.updateDelegate            = self
        userFoodDetailsVC.passedData                = passedUserFoods[indexPath.row]
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
                self.presentGFAlertOnMain(title: CAAlertTitle.unableToRemove.rawValue, message: error.localizedDescription, buttonTitle: "Ok")
                return
            }
            self.presentGFAlertOnMain(title: CAAlertTitle.foodRemoved.rawValue, message: CAAlertMessage.foodRemoved.rawValue, buttonTitle: "Ok")
        }
    }
    
    func removeUserFood() {
        self.dismiss(animated: true) {
            Task.init {
                do {
                    guard userID != "" else {
                        self.presentGFAlertOnMain(title: CAAlertTitle.iCloudError.rawValue, message: CAAlertMessage.fetchFoodsError.rawValue, buttonTitle: "Ok")
                        return
                    }
                    let queriedUserFoods = try await self.queryUserFoods()
                    self.passedUserFoods = queriedUserFoods
                    self.presentGFAlertOnMain(title: CAAlertTitle.foodRemoved.rawValue, message: CAAlertMessage.foodRemoved.rawValue, buttonTitle: "Ok")
                    self.collectionView.backgroundView = {self.passedUserFoods.count == 0 ? self.emptyUserFoods : nil}()
                    self.collectionView.reloadData()
                } catch {
                    self.presentGFAlertOnMain(title: CAAlertTitle.iCloudError.rawValue, message: CAAlertMessage.fetchFoodsError.rawValue, buttonTitle: "Ok")
                }
            }
        }
    }
    
    func queryUserFoods() async throws -> [YourFoodItem] {
        var userFoods:   [YourFoodItem] = []
        let privateDB = CKContainer.default().privateCloudDatabase
        let predicate = NSPredicate(format: "userID = %@", userID)
        let query = CKQuery(recordType: "UserFoods", predicate: predicate)
        let testResults = try await privateDB.records(matching: query)

        for t in testResults.matchResults {
            let a = try t.1.get()
            let description     = a.value(forKey: "description") as! String
            let ingredients     = a.value(forKey: "ingredients") as! String
            let portionSize     = a.value(forKey: "portionSize") as! String
            let totalCarbs      = a.value(forKey: "totalCarbs") as! Float
            let totalFiber      = a.value(forKey: "totalFiber") as! Float
            let totalSugars     = a.value(forKey: "totalSugars") as! Float
            let addedSugars     = a.value(forKey: "addedSugars") as! Float
            let x = YourFoodItem(recordID: a.recordID, category: "Your Foods", description: description, portionSize: portionSize, ingredients: ingredients, totalCarbs: totalCarbs, totalFiber: totalFiber, totalSugars: totalSugars, addedSugars: addedSugars)
            userFoods.append(x)
        }
        return userFoods
    }
    
    func updateUserFoods() {
        Task.init {
            do {
                guard userID != "" else {
                    self.presentGFAlertOnMain(title: CAAlertTitle.iCloudError.rawValue, message: CAAlertMessage.fetchFoodsError.rawValue, buttonTitle: "Ok")
                    return
                }
                let queriedUserFoods = try await self.queryUserFoods()
                self.passedUserFoods = queriedUserFoods
                collectionView.reloadData()
            } catch {
                self.presentGFAlertOnMain(title: CAAlertTitle.iCloudError.rawValue, message: CAAlertMessage.fetchFoodsError.rawValue, buttonTitle: "Ok")
            }
        }
    }
    

}
