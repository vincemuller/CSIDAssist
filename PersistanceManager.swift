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
        static let firstLaunchIcloudRetrieve = "retrieveIcloud"
        static let favorites = "favorites"
        static let userFoods = "userFoods"
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
                    print("favorite worked!")
                    retrievedFavorites.append(favorite)
                case .remove:
                    retrievedFavorites.removeAll { $0.fdicID == favorite.fdicID }
                    print("removed worked")
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
            print("retrieved!")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([USDAFoodDetails].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            print("Unable to favorite!")
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
            print("save was successful")
            return nil
        } catch {
            print("Unable to favorite from save func")
            return error
        }
    }
    
    static func retrieveUserFoods(completed: @escaping (Result<[UserFoodItem], Error>) -> Void) {
        guard let userFoodData = defaults.object(forKey: Keys.userFoods) as? Data else {
            completed(.success([]))
            print("User Foods Retrieved!")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let userFoods = try decoder.decode([UserFoodItem].self, from: userFoodData)
            completed(.success(userFoods))
        } catch {
            print("Unable to favorite!")
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
                print(error)
            }
        })
        return userFoods
    }
    
    static func createUserFood(userFoods: [UserFoodItem]) -> Error? {
        do {
            let encoder = JSONEncoder()
            let encodedUserFoods = try encoder.encode(userFoods)
            defaults.setValue(encodedUserFoods, forKey: Keys.userFoods)
            print("User food created!")
            return nil
        } catch {
            print("Unable to create new food!")
            return error
        }
    }
    
    static func updateUserFoodWith(userFood: UserFoodItem, actionType: CreateActionType, completed: @escaping (Error?) -> Void) {
        retrieveUserFoods { result in
            switch result {
            case .success(let userFoods):
                var retrievedUserFoods = userFoods
                switch actionType {
                case .create:
                    guard !retrievedUserFoods.contains(where: { $0.description == userFood.description }) else {
                        print("already in favorites!")
                        return
                    }
                    print("favorite worked!")
                    retrievedUserFoods.append(userFood)
                case .delete:
                    retrievedUserFoods.removeAll { $0.description == userFood.description }
                    print("removed worked")
                case .modify:
                    retrievedUserFoods.removeAll {$0.description == userFood.description}
                    retrievedUserFoods.append(userFood)
                }
                
                completed(createUserFood(userFoods: retrievedUserFoods))
                
            case .failure(let error):
                completed(error)
                print(error)
            }
        }
    }
}
