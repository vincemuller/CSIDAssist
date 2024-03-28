//
//  WholeFoodDetailsViewModel.swift
//  CSID_App
//
//  Created by Vince Muller on 3/22/24.
//

import Foundation


class WholeFoodDetailsViewModel {
    private let findSugars = SucroseCheck()
    
    func userFavoriteCheck(fdicID: Int) -> Bool {
        let userFavs    = PersistenceManager.getUserFavs()
        let check       = userFavs.contains(where: { $0.fdicID == fdicID })
        return check
    }
    
    func getNutrientData(fdicID: Int) -> WholeFoodNutrientData {
        let rawData = CADatabaseQueryHelper.queryDatabaseWholeFoodNutrientData(fdicID: fdicID, databasePointer: databasePointer)
        
        return rawData
    }
    
    func getAdjustor(servingSize: Float, customPortion: String) -> Float {
        let cP: Float           = Float(customPortion) ?? 1
        let adjustor:   Float   = cP/servingSize
        
        return adjustor
    }
    
    func customPortionAdjustment(nutrientData: WholeFoodNutrientData, adjustor: Float) -> WholeFoodNutrientData {
        var adjustedCarbs: String       = "N/A"
        var adjustedStarches: String    = "N/A"
        var adjustedTotalSugars: String = "N/A"
        var adjustedSucrose: String     = "N/A"
        var adjustedFructose: String    = "N/A"
        var adjustedGlucose: String     = "N/A"
        var adjustedLactose: String     = "N/A"
        var adjustedMaltose: String     = "N/A"
        
        if nutrientData.carbs != "N/A" {
            let aC:  Float      = (Float(nutrientData.carbs)!*adjustor)
            adjustedCarbs   = String(format: "%.1f", aC)
        }
            
        if nutrientData.totalStarches != "N/A" {
            let aS:  Float      = (Float(nutrientData.totalStarches)!*adjustor)
            adjustedStarches   = String(format: "%.1f", aS)
        }
        
        if nutrientData.totalSugars != "N/A" {
            let aTS:  Float         = (Float(nutrientData.totalSugars)!*adjustor)
            adjustedTotalSugars = String(format: "%.1f", aTS)
        }
        
        if nutrientData.sucrose != "N/A" {
            let aSucr: Float   = Float(nutrientData.sucrose)!*adjustor
            adjustedSucrose    = String(format: "%.1f", aSucr)
        }
        
        if nutrientData.fructose != "N/A" {
            let aF: Float       = Float(nutrientData.fructose)!*adjustor
            adjustedFructose    = String(format: "%.1f", aF)
        }
        
        if nutrientData.glucose != "N/A" {
            let aG: Float   = Float(nutrientData.glucose)!*adjustor
            adjustedGlucose = String(format: "%.1f", aG)
        }
        
        if nutrientData.lactose != "N/A" {
            let aL: Float   = Float(nutrientData.lactose)!*adjustor
            adjustedLactose = String(format: "%.1f", aL)
        }
        
        if nutrientData.maltose != "N/A" {
            let aM: Float   = Float(nutrientData.maltose)!*adjustor
            adjustedMaltose = String(format: "%.1f", aM)
        }
        
        let adjustedNutrientData = WholeFoodNutrientData(carbs: adjustedCarbs, totalSugars: adjustedTotalSugars, totalStarches: adjustedStarches, sucrose: adjustedSucrose, fructose: adjustedFructose, glucose: adjustedGlucose, lactose: adjustedLactose, maltose: adjustedMaltose)
        
        return adjustedNutrientData
    }
}
