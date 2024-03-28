//
//  FoodDetailsViewModel.swift
//  CSID_App
//
//  Created by Vince Muller on 3/22/24.
//

import Foundation

class FoodDetailsViewModel {
    private let findSugars = SucroseCheck()
    
    func userFavoriteCheck(fdicID: Int) -> Bool {
        let userFavs    = PersistenceManager.getUserFavs()
        let check       = userFavs.contains(where: { $0.fdicID == fdicID })
        return check
    }
    
    func getNutrientData(fdicID: Int) -> USDANutrientData {
        let rawData = CADatabaseQueryHelper.queryDatabaseNutrientData(fdicID: fdicID, databasePointer: databasePointer)
        
        return rawData
    }
    
    func getAdjustor(servingSize: Float, customPortion: String) -> Float {
        let cP: Float           = Float(customPortion) ?? 1
        let adjustor:   Float   = cP/servingSize
        
        return adjustor
    }
    
    func customPortionAdjustment(nutrientData: USDANutrientData, adjustor: Float) -> USDANutrientData {
        var adjustedCarbs: String       = "N/A"
        var adjustedNetCarbs: String    = "N/A"
        var adjustedStarches: String    = "N/A"
        var adjustedTotalSugars: String = "N/A"
        
        if nutrientData.carbs != "N/A" {
            let aC:  Float  = (Float(nutrientData.carbs)!*adjustor)
            adjustedCarbs   = String(format: "%.1f", aC)
        }
        
        if nutrientData.netCarbs != "N/A" {
            let aNC:  Float    = (Float(nutrientData.netCarbs)!*adjustor)
            adjustedNetCarbs   = String(format: "%.1f", aNC)
        }
            
        if nutrientData.totalStarches != "N/A" {
            let aS:  Float     = (Float(nutrientData.totalStarches)!*adjustor)
            adjustedStarches   = String(format: "%.1f", aS)
        }
        
        if nutrientData.totalSugars != "N/A" {
            let aTS:  Float     = (Float(nutrientData.totalSugars)!*adjustor)
            adjustedTotalSugars = String(format: "%.1f", aTS)
        }
        
        let adjustedNutrientData = USDANutrientData(carbs: adjustedCarbs, fiber: "", netCarbs: adjustedNetCarbs, totalSugars: adjustedTotalSugars, totalStarches: adjustedStarches, totalSugarAlcohols: "", protein: "", totalFat: "", sodium: "")
        
        return adjustedNutrientData
    }
    
    
    func getSucroseSugars(productIngredients: String) -> String {
        let uniqueIngredients = findSugars.makingIngredientsUnique(originalIngredients: productIngredients)
        var sucroseSugars = findSugars.getSucroseIngredients(productIngredients: uniqueIngredients)
        
        if sucroseSugars.isEmpty {
            let sI = "No sucrose detected. As always, check the ingredients"
            return sI
        }
        
        sucroseSugars = sucroseSugars.map({$0.capitalized})
        let sI        = "•\(sucroseSugars.joined(separator: "  •"))"
        
        return sI
    }
    
    func getOtherSugars(productIngredients: String) -> String {
        let uniqueIngredients = findSugars.makingIngredientsUnique(originalIngredients: productIngredients)
        var otherSugars = findSugars.getOtherSugarIngredients(productIngredients: uniqueIngredients)
        
        if otherSugars.isEmpty {
            let oI = "No other sugars detected. As always, check the ingredients"
            return oI
        }
        
        otherSugars = otherSugars.map({$0.capitalized})
        let oI = "•\(otherSugars.joined(separator: "  •"))"
        
        return oI
    }
}
