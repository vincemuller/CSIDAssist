//
//  SucroseIngredientClass.swift
//  CSID_App
//
//  Created by Vince Muller on 12/28/23.
//

import UIKit

class SucroseCheck {
    var sucrIngredients: [String] = [
        "barbados sugar",
        "barley malt syrup",
        "beet sugar",
        "brown sugar",
        "buttered syrup",
        "cane juice",
        "cane juice crystals",
        "cane sugar",
        "cane syrup",
        "caramel",
        "carob syrup",
        "castor sugar",
        "coconut palm sugar",
        "coconut sugar",
        "confectioner's sugar",
        "cehydrated cane juice",
        "cemerara sugar",
        "evaporated cane juice",
        "free-flowing brown sugars",
        "golden sugar",
        "golden syrup",
        "icing sugar",
        "invert sugar",
        "maple syrup",
        "molasses",
        "muscovado",
        "palm sugar",
        "panocha",
        "powdered sugar",
        "raw sugar",
        "refiner's syrup",
        "saccharose",
        "sorghum Syrup",
        "sucrose",
        "sugar",
        ", syrup",
        "sweet sorghum",
        "treacle",
        "turbinado sugar",
        "yellow sugar",
    ]
    var otherSugarIngredients: [String] = [
        "agave nectar",
        "barley malt",
        "corn sweetener",
        "corn syrup",
        "corn syrup solids",
        "date sugar",
        "dextrin",
        "dextrose",
        "fructose",
        "fruit juice",
        "fruit juice concentrate",
        "glucose",
        "glucose solids",
        "grape sugar",
        "hfcs (high-fructose corn syrup)",
        "honey",
        "malt syrup",
        "maltodextrin",
        "maltol",
        "maltose",
        "mannose",
        "rice syrup"
    ]
    
    func getSucroseIngredients(productIngredients: String) -> [String] {
        var returnedSugarIngredients: [String] = []
        
        for x in sucrIngredients {
            if productIngredients.contains(x) {
                returnedSugarIngredients.append(x)
            }
        }
        
        return returnedSugarIngredients
    }
    
    func getOtherSugarIngredients(productIngredients: String) -> [String] {
        var returnedOtherSugarIngredients: [String] = []
        
        for x in otherSugarIngredients {
            if productIngredients.contains(x) {
                returnedOtherSugarIngredients.append(x)
            }
        }
        
        return returnedOtherSugarIngredients
    }
}
