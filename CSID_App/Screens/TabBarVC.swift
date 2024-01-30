//
//  TabBarVC.swift
//  CSID_App
//
//  Created by Vince Muller on 9/14/23.

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createTabbar()
        configureNavigationBar()
    }
    
    func createSearchNC() -> UINavigationController {
        let searchVC        = SearchVC()
        searchVC.title      = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createAddNewFoodNC() -> UINavigationController {
        let addNewFoodVC    = AddNewFoodVC()
        addNewFoodVC.title  = "New Food"
        let config          = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 22))
        let addNewSymbol    = UIImage(systemName: "plus", withConfiguration: config)
        addNewFoodVC.tabBarItem = UITabBarItem(title: "New Food",
                                               image: addNewSymbol,
                                               tag: 1)
        
        return UINavigationController(rootViewController: addNewFoodVC)
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoritesVC         = FavoritesVC()
        favoritesVC.title       = "Favorites"
        favoritesVC.tabBarItem  = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        
        return UINavigationController(rootViewController: favoritesVC)
    }
    
    func createContactUs() -> UINavigationController {
        let aboutUsVC         = AboutUsVC()
        aboutUsVC.title       = "About CSID Assist"
        let config            = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 22))
        let addNewSymbol      = UIImage(systemName: "info.circle", withConfiguration: config)
        aboutUsVC.tabBarItem  = UITabBarItem(title: "About Us", image: addNewSymbol, tag: 3)
        
        return UINavigationController(rootViewController: aboutUsVC)
    }
    
    func createTabbar() {
        UITabBar.appearance().tintColor         = .systemGreen
        UITabBar.appearance().backgroundImage   = UIImage()
        UITabBar.appearance().shadowImage       = UIImage()

        self.viewControllers = [createSearchNC(), createAddNewFoodNC(), createFavoritesNC(), createContactUs()]
    }
    
    func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        self.navigationController?.navigationBar.isTranslucent = true  // pass "true" for fixing iOS 15.0 black bg issue
        self.navigationController?.navigationBar.tintColor = UIColor.white // We need to set tintcolor for iOS 15.0
        appearance.shadowColor = .clear    //removing navigationbar 1 px bottom border.
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    

}
