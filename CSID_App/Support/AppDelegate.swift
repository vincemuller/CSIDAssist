//
//  AppDelegate.swift
//  CSID_App
//
//  Created by Vince Muller on 9/13/23.
//

import UIKit
import CloudKit

@main

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
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


