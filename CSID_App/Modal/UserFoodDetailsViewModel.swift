//
//  UserFoodDetailsViewModel.swift
//  CSID_App
//
//  Created by Vince Muller on 1/5/24.
//

import UIKit
import CloudKit

struct UserFoodItem {
    
    var userFoodItem:   YourFoodItem!
    var sugarTypes:     String      = ""
    
    let findSugars                  = SucroseCheck()
    
    var sugarIngr:      [String]    = []
    var otherIngr:      [String]    = []
    
    var foodItemRecordID:   CKRecord.ID?
    var title:              String  = ""
    let brandCategoryLabel: String  = "Your Foods"
    
    var portionSize:        String  = ""
    
    var totalCarbs:     Float?
    var netCarbs:       Float?
    
    var totalSugars:    Float?
    var totalFiber:     Float?
    var totalStarchs:   Float?
    var addedSugars:    Float?
}

