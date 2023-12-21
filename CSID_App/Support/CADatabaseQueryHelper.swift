//
//  CADatabaseQueryHelper.swift
//  CSID_App
//
//  Created by Vince Muller on 11/27/23.
//

import UIKit
import SQLite3

class CADatabaseQueryHelper {

    static func queryDatabaseGeneralSearch(searchTerms: String, databasePointer: OpaquePointer?) -> [USDAFoodDetails] {
        
        var filteredUSDAFoodData: [USDAFoodDetails] = []
        var queryStatement: OpaquePointer?
        let queryStatementString = """
            SELECT searchKeyWords, fdicID, brandOwner, brandName, brandedFoodCategory, description, servingSize, servingSizeUnit, ingredients FROM USDAFoodDetails
            WHERE \(searchTerms)
            ORDER BY length(description)
            LIMIT 1000;
            """
        if sqlite3_prepare_v2(
          databasePointer,
          queryStatementString,
          -1,
          &queryStatement,
          nil
        ) == SQLITE_OK {
            
            var brandOwner: String
            var brandName: String
            var brandCategory: String
            var descr: String
            var ingredients: String
            
          while (sqlite3_step(queryStatement) == SQLITE_ROW) {
              
              let searchKeyWords = String(cString: sqlite3_column_text(queryStatement, 0))
            
              let fdicID = Int(sqlite3_column_int(queryStatement, 1))
              
              if let queryResultBrandOwner = sqlite3_column_text(queryStatement, 2) {
                  brandOwner    = String(cString: queryResultBrandOwner)
              } else {
                  brandOwner    = ""
              }
              
              if let queryResultBrandName = sqlite3_column_text(queryStatement, 3) {
                  brandName     = String(cString: queryResultBrandName)
              } else {
                  brandName     = ""
              }
              
              if let queryResultBrandedCategory = sqlite3_column_text(queryStatement, 4) {
                  brandCategory = String(cString: queryResultBrandedCategory)
              } else {
                  brandCategory = ""
              }
              
              if let queryResultDescription = sqlite3_column_text(queryStatement, 5) {
                  descr   = String(cString: queryResultDescription)
              } else {
                  descr   = ""
              }
              
              let servingSize = Float(sqlite3_column_double(queryStatement, 6))
              
              let servingSizeUnit = String(cString: sqlite3_column_text(queryStatement, 7))
              
              
              if let queryResultIngredients = sqlite3_column_text(queryStatement, 8) {
                  ingredients   = String(cString: queryResultIngredients)
              } else {
                  ingredients   = ""
              }
              
              
              let tempUSDAData  = [USDAFoodDetails(searchKeyWords: searchKeyWords, fdicID: fdicID, brandOwner: brandOwner, brandName: brandName, brandedFoodCategory: brandCategory, description: descr, servingSize: servingSize, servingSizeUnit: servingSizeUnit, ingredients: ingredients)]
              
              filteredUSDAFoodData.append(contentsOf: tempUSDAData)
            }
        } else {
            let errorMessage    = String(cString: sqlite3_errmsg(databasePointer))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        return filteredUSDAFoodData
    }
    
    
    static func queryDatabaseCategorySearch(categorySearchTerm: String, searchTerm: String, databasePointer: OpaquePointer?) -> [USDAFoodDetails] {
        
        var filteredUSDAFoodData: [USDAFoodDetails] = []
        var queryStatement: OpaquePointer?
        let queryStatementString = """
            SELECT searchKeyWords, fdicID, brandOwner, brandName, brandedFoodCategory, description, servingSize, servingSizeUnit, ingredients FROM USDAFoodDetails
            WHERE brandedFoodCategory LIKE '\(categorySearchTerm)'
            \(searchTerm)
            ORDER BY length(description)
            LIMIT 1000;
            """
        if sqlite3_prepare_v2(
          databasePointer,
          queryStatementString,
          -1,
          &queryStatement,
          nil
        ) == SQLITE_OK {
            
            var brandOwner: String
            var brandName: String
            var brandCategory: String
            var descr: String
            var ingredients: String
            
          while (sqlite3_step(queryStatement) == SQLITE_ROW) {
              
              let searchKeyWords = String(cString: sqlite3_column_text(queryStatement, 0))
            
              let fdicID = Int(sqlite3_column_int(queryStatement, 1))
              
              if let queryResultBrandOwner = sqlite3_column_text(queryStatement, 2) {
                  brandOwner    = String(cString: queryResultBrandOwner)
              } else {
                  brandOwner    = ""
              }
              
              if let queryResultBrandName = sqlite3_column_text(queryStatement, 3) {
                  brandName     = String(cString: queryResultBrandName)
              } else {
                  brandName     = ""
              }
              
              if let queryResultBrandedCategory = sqlite3_column_text(queryStatement, 4) {
                  brandCategory = String(cString: queryResultBrandedCategory)
              } else {
                  brandCategory = ""
              }
              
              if let queryResultDescription = sqlite3_column_text(queryStatement, 5) {
                  descr   = String(cString: queryResultDescription)
              } else {
                  descr   = ""
              }
              
              let servingSize = Float(sqlite3_column_double(queryStatement, 6))
              
              let servingSizeUnit = String(cString: sqlite3_column_text(queryStatement, 7))
              
              
              if let queryResultIngredients = sqlite3_column_text(queryStatement, 8) {
                  ingredients   = String(cString: queryResultIngredients)
              } else {
                  ingredients   = ""
              }
              
              let tempUSDAData  = [USDAFoodDetails(searchKeyWords: searchKeyWords, fdicID: fdicID, brandOwner: brandOwner, brandName: brandName, brandedFoodCategory: brandCategory, description: descr, servingSize: servingSize, servingSizeUnit: servingSizeUnit, ingredients: ingredients)]
              
              filteredUSDAFoodData.append(contentsOf: tempUSDAData)
            }
        } else {
            let errorMessage    = String(cString: sqlite3_errmsg(databasePointer))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        return filteredUSDAFoodData
    }
    
    static func queryDatabaseNutrientData(fdicID: Int, databasePointer: OpaquePointer?) -> USDANutrientData {
        
        var queryStatement:     OpaquePointer?
        var nutrientData:       USDANutrientData?
        var carbs:              String = "N/A"
        var netCarbs:           String = "N/A"
        var totalSugars:        String = "N/A"
        var totalStarches:      String = "N/A"
        var totalSugarAlcohols: String = "N/A"
        var fiber:              String = "N/A"
        var protein:            String = "N/A"
        var totalFat:           String = "N/A"
        var sodium:             String = "N/A"
        
        let queryStatementString = """
            SELECT carbs, totalSugars, totalSugarAlcohols, fiber, protein, totalFat, sodium FROM USDAFoodNutData
            WHERE fdicID=\(fdicID);
            """
        if sqlite3_prepare_v2(
          databasePointer,
          queryStatementString,
          -1,
          &queryStatement,
          nil
        ) == SQLITE_OK {
        if sqlite3_step(queryStatement) == SQLITE_ROW {
            if let queryResultCarbs = sqlite3_column_text(queryStatement, 0) {
                carbs    = String(cString: queryResultCarbs)
            } else {
                carbs    = "N/A"
            }
            if let queryResultTotalSugars = sqlite3_column_text(queryStatement, 1) {
                totalSugars = String(cString: queryResultTotalSugars)
            } else {
                totalSugars = "N/A"
            }
            if let queryResultTotalSugarAlcohols = sqlite3_column_text(queryStatement, 2) {
                totalSugarAlcohols = String(cString: queryResultTotalSugarAlcohols)
            } else {
                totalSugarAlcohols = "N/A"
            }
            if let queryResultFiber = sqlite3_column_text(queryStatement, 3) {
                fiber = String(cString: queryResultFiber)
            } else {
                fiber = "N/A"
            }
            if let queryResultProtein = sqlite3_column_text(queryStatement, 4) {
                protein = String(cString: queryResultProtein)
            } else {
                protein = "N/A"
            }
            if let queryResultTotalFat = sqlite3_column_text(queryStatement, 5) {
                totalFat = String(cString: queryResultTotalFat)
            } else {
                totalFat = "N/A"
            }
            if let queryResultSodium = sqlite3_column_text(queryStatement, 6) {
                sodium = String(cString: queryResultSodium)
            } else {
                sodium = "N/A"
            }
              }
            
          } else {
              let errorMessage    = String(cString: sqlite3_errmsg(databasePointer))
              print("\nQuery is not prepared \(errorMessage)")
          }
          sqlite3_finalize(queryStatement)
        
        //Calculating nut data
        //Net Carbs
        if carbs == "N/A" {
            netCarbs = "N/A"
        } else if fiber == "N/A" {
            netCarbs = (Float(carbs)!).description
        } else if totalSugarAlcohols == "N/A" {
            netCarbs = (max((Float(carbs)!)-(Float(fiber)!), 0)).description
        } else {
            netCarbs = (max((Float(carbs)!)-(Float(fiber)!)-(Float(totalSugarAlcohols)!), 0)).description
        }
        
        //Total Starches
        if carbs == "N/A" || totalSugars == "N/A" {
            totalStarches   = "N/A"
        } else if fiber == "N/A" {
            totalStarches   = (max((Float(carbs)!)-(Float(totalSugars)!), 0)).description
        } else {
            totalStarches   = (max((Float(carbs)!)-(Float(fiber)!)-(Float(totalSugars)!), 0)).description
        }
        
        carbs       = (carbs != "N/A" ? ((Float(carbs)!).description) : "N/A")
        totalSugars = (totalSugars != "N/A" ? ((Float(totalSugars)!).description) : "N/A")
        fiber       = (fiber != "N/A" ? ((Float(fiber)!).description) : "N/A")
        
        nutrientData = USDANutrientData(carbs: carbs, fiber: fiber, netCarbs: netCarbs, totalSugars: totalSugars, totalStarches: totalStarches, totalSugarAlcohols: totalSugarAlcohols, protein: protein, totalFat: totalFat, sodium: sodium)
        
        return nutrientData!
    }
    
    static func queryDatabaseFavorites(searchTerms: String, databasePointer: OpaquePointer?) -> [USDAFoodDetails] {
        
        var filteredUSDAFoodData: [USDAFoodDetails] = []
        var queryStatement: OpaquePointer?
        let queryStatementString = """
            SELECT searchKeyWords, fdicID, brandOwner, brandName, brandedFoodCategory, description, servingSize, servingSizeUnit, ingredients FROM USDAFoodDetails
            WHERE \(searchTerms)
            ORDER BY length(description);
            """
        if sqlite3_prepare_v2(
          databasePointer,
          queryStatementString,
          -1,
          &queryStatement,
          nil
        ) == SQLITE_OK {
            
            var brandOwner: String
            var brandName: String
            var brandCategory: String
            var descr: String
            var ingredients: String
            
          while (sqlite3_step(queryStatement) == SQLITE_ROW) {
              
              let searchKeyWords = String(cString: sqlite3_column_text(queryStatement, 0))
            
              let fdicID = Int(sqlite3_column_int(queryStatement, 1))
              
              if let queryResultBrandOwner = sqlite3_column_text(queryStatement, 2) {
                  brandOwner    = String(cString: queryResultBrandOwner)
              } else {
                  brandOwner    = ""
              }
              
              if let queryResultBrandName = sqlite3_column_text(queryStatement, 3) {
                  brandName     = String(cString: queryResultBrandName)
              } else {
                  brandName     = ""
              }
              
              if let queryResultBrandedCategory = sqlite3_column_text(queryStatement, 4) {
                  brandCategory = String(cString: queryResultBrandedCategory)
              } else {
                  brandCategory = ""
              }
              
              if let queryResultDescription = sqlite3_column_text(queryStatement, 5) {
                  descr   = String(cString: queryResultDescription)
              } else {
                  descr   = ""
              }
              
              let servingSize = Float(sqlite3_column_double(queryStatement, 6))
              
              let servingSizeUnit = String(cString: sqlite3_column_text(queryStatement, 7))
              
              
              if let queryResultIngredients = sqlite3_column_text(queryStatement, 8) {
                  ingredients   = String(cString: queryResultIngredients)
              } else {
                  ingredients   = ""
              }
              
              
              let tempUSDAData  = [USDAFoodDetails(searchKeyWords: searchKeyWords, fdicID: fdicID, brandOwner: brandOwner, brandName: brandName, brandedFoodCategory: brandCategory, description: descr, servingSize: servingSize, servingSizeUnit: servingSizeUnit, ingredients: ingredients)]
              
              filteredUSDAFoodData.append(contentsOf: tempUSDAData)
            }
        } else {
            let errorMessage    = String(cString: sqlite3_errmsg(databasePointer))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(queryStatement)
        return filteredUSDAFoodData
    }

}
