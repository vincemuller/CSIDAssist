//
//  SceneDelegate.swift
//  CSID_App
//
//  Created by Vince Muller on 9/13/23.
//

import UIKit
import CloudKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = TabBarVC()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        fetchICloudUserRecordID()
        Task.init {
            do {
                guard userID != "" else {
                    print("Not able to retrieve user id")
                    return
                }
                userFavorites = try await queryAllFavs()
            } catch {
                userID = ""
                userFavorites = []
                print("Fetching failed with error \(error)")
            }
        }
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func fetchICloudUserRecordID() {
        CKContainer.default().fetchUserRecordID { returnedID, returnedError in
            userID = returnedID?.recordName ?? ""
        }
    }
    
    func queryAllFavs() async throws -> [Int] {
        var userFavs:   [Int] = []
        let privateDB = CKContainer.default().privateCloudDatabase
        let predicate = NSPredicate(format: "userID = %@", userID)
        let query = CKQuery(recordType: "UserFavorites", predicate: predicate)
        let testResults = try await privateDB.records(matching: query)
        for t in testResults.matchResults {
            let a = try t.1.get()
            let i = a.value(forKey: "fdicID") as! Int
            userFavs.append(i)
        }
        return userFavs
    }

}

