//
//  CADatabaseHelper.swift
//  CSID_App
//
//  Created by Vince Muller on 11/23/23.
//

import Foundation
import SQLite3

class CADatabaseHelper {
    static func getDatabasePointer(databaseName: String) -> OpaquePointer? {
        var databasePointer: OpaquePointer?
        
        let bundlePath = Bundle.main.resourceURL?.appendingPathComponent(databaseName).path
        
        if sqlite3_open(bundlePath, &databasePointer) ==  SQLITE_OK {
            print("Successfully Opened Database")
        } else {
            print("Could Not Open Database!")
        }
        return databasePointer
    }
    
}
