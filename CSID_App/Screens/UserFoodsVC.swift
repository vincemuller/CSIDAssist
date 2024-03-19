//
//  UserFoodsVC.swift
//  CSID_App
//
//  Created by Vince Muller on 12/31/23.
//

import UIKit


class UserFoodsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UpdateUserFoodsVC {

    var collectionView: UICollectionView!
    let searchController = UISearchController()
    
    var navBarHeight: CGFloat?
    var tabBarHeight: CGFloat?
    
    //Variable for filtered search results
    var passedUserFoods: [UserFoodItem] = []
    var category:   String = ""
    
    //Category colors and labels
    let categories = Category()
    let emptyUserFoods = EmptyCollectionView(text: "You have no added foods :(")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 100
        tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 84
        
        configureViewController()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserFoods()
    }
    
    func getUserFoods() {
        passedUserFoods = PersistenceManager.getUserFoods()
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
        userFoodDetailsVC.delegate = self
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell {
            cell.backgroundColor = .systemGray5
        }
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
        
        collectionView.reloadData()
        return true
    }

    func updateUserFood() {
        
    }
    
    func removeUserFoods() {
        getUserFoods()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
            self.presentGFAlertOnMain(title: "Food Removed!", message: "You have successfully removed your food item", buttonTitle: "Ok")
        })
    }
}
