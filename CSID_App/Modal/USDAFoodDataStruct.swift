//
//  CSIDFoodData_Struct.swift
//  CSID_App
//
//  Created by Vince Muller on 10/2/23.
//

import UIKit

struct YourFoodItem: Codable {
    var category:       String
    var description:    String
    var portionSize:    String
    var ingredients:    String
    var totalCarbs:     Float
    var totalFiber:     Float
    var totalSugars:    Float
    var addedSugars:    Float
}

struct USDAFoodDetails: Codable {
    var searchKeyWords:         String
    var fdicID:                 Int
    var brandOwner:             String?
    var brandName:              String?
    var brandedFoodCategory:    String
    var description:            String
    var servingSize:            Float
    var servingSizeUnit:        String
    var ingredients:            String
}

struct USDANutrientData: Codable {
    var carbs:              String
    var fiber:              String
    var netCarbs:           String
    var totalSugars:        String
    var totalStarches:      String
    var totalSugarAlcohols: String
    var protein:            String
    var totalFat:           String
    var sodium:             String
}

