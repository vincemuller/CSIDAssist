//
//  PersistanceManager.swift
//  CSID_App
//
//  Created by Vince Muller on 3/10/24.
//

import Foundation

enum FavoriteActionType {
    case add, remove
}

enum CreateActionType {
    case create, modify, delete
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let firstLaunchIcloudRetrieve = "firstLaunch"
        static let favorites = "favorites"
        static let userFoods = "userFoods"
    }
    
    static func getUserLaunchDetails() -> Bool {
        var firstLaunch = defaults.bool(forKey:"firstLaunch")
        print(firstLaunch)
        firstLaunch.toggle()
        print(firstLaunch)
        
        guard firstLaunch == true else {
            return firstLaunch
        }
        
        defaults.set(true, forKey: Keys.firstLaunchIcloudRetrieve)
        return firstLaunch
    }
    
    static func updateWith(favorite: USDAFoodDetails, actionType: FavoriteActionType, completed: @escaping (Error?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                var retrievedFavorites = favorites
                switch actionType {
                case .add:
                    guard !retrievedFavorites.contains(where: { $0.fdicID == favorite.fdicID }) else {
                        print("already in favorites!")
                        return
                    }
                    retrievedFavorites.append(favorite)
                case .remove:
                    retrievedFavorites.removeAll { $0.fdicID == favorite.fdicID }
                }
                
                completed(save(favorites: retrievedFavorites))
                
            case .failure(let error):
                completed(error)
                print(error)
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[USDAFoodDetails], Error>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([USDAFoodDetails].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            print("Unable to favorite!, check PersistenceManager")
            completed(.failure(error))
        }
    }
    
    static func getUserFavs() -> [USDAFoodDetails] {
        var userFavs: [USDAFoodDetails] = []
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                userFavs = favorites
            case .failure(let error):
                print(error)
            }
        }
        return userFavs
    }
    
    static func save(favorites: [USDAFoodDetails]) -> Error? {
        
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            print("Unable to favorite from save func in PersistenceManager")
            return error
        }
    }
    
    static func retrieveUserFoods(completed: @escaping (Result<[UserFoodItem], Error>) -> Void) {
        guard let userFoodData = defaults.object(forKey: Keys.userFoods) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let userFoods = try decoder.decode([UserFoodItem].self, from: userFoodData)
            completed(.success(userFoods))
        } catch {
            print("Unable to retrieve favs from PersistenceManager in retrievUserFoods func")
            completed(.failure(error))
        }
    }
    
    static func getUserFoods() -> [UserFoodItem] {
        var userFoods: [UserFoodItem] = []
        PersistenceManager.retrieveUserFoods(completed: { result in
            switch result {
            case .success(let foods):
                userFoods = foods
            case .failure(let error):
                print("\(error) This failure is coming from getUserFoods func in PersistenceManager")
            }
        })
        return userFoods
    }
    
    static func createUserFood(userFoods: [UserFoodItem]) -> Error? {
        do {
            let encoder = JSONEncoder()
            let encodedUserFoods = try encoder.encode(userFoods)
            defaults.setValue(encodedUserFoods, forKey: Keys.userFoods)
            return nil
        } catch {
            print("Unable to create new food, check createUserFood in PersistenceManager")
            return error
        }
    }
    
    static func updateUserFoodWith(userFood: UserFoodItem, updatedUserFood: UserFoodItem?, actionType: CreateActionType, completed: @escaping (Error?) -> Void) {
        retrieveUserFoods { result in
            switch result {
            case .success(let userFoods):
                var retrievedUserFoods = userFoods
                switch actionType {
                case .create:
                    guard !retrievedUserFoods.contains(where: { $0.description == userFood.description }) else {
                        print("This food already exists! Persistence Manager")
                        return
                    }
                    retrievedUserFoods.append(userFood)
                case .delete:
                    retrievedUserFoods.removeAll { $0.description == userFood.description }
                case .modify:
                    retrievedUserFoods.removeAll {$0.description == userFood.description}
                    retrievedUserFoods.append(updatedUserFood ?? userFood)
                }
                
                completed(createUserFood(userFoods: retrievedUserFoods))
                
            case .failure(let error):
                completed(error)
                print("\(error) coming from updateUserFoodWith in PersistenceManager")
            }
        }
    }
}
