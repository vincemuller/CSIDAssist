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
        "dehydrated cane juice",
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
        "syrup",
        "sweet sorghum",
        "treacle",
        "turbinado sugar",
        "yellow sugar"
    ]
    var otherSugarIngredients: [String] = [
        "sugar alcohol",
        "agave nectar",
        "barley malt",
        "corn sweetener",
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
        "high fructose corn syrup",
        "honey",
        "malt syrup",
        "maltodextrin",
        "maltol",
        "maltose",
        "mannose",
        "rice syrup",
        "corn syrup",
        "erythritol",
        "maltitol",
        "mannitol",
        "sorbitol",
        "xylitol",
        "hydrogenated starch hydrolysates",
        "isomalt",
        "monk fruit extract",
        "monk fruit"
    ]
    
    var replacedSucrIngredients: [String] = [
        "barbadossgr",
        "barleymaltsyrup",
        "beetsgr",
        "brownsgr",
        "butteredsyrp",
        "cnejc",
        "canejccrystals",
        "canesgr",
        "canesyrp",
        "caramel",
        "carobsyrp",
        "castorsgr",
        "coconutpalmsgr",
        "coconutsgr",
        "confectioner's sugar",
        "dehydratedcanejce",
        "cemerarasgr",
        "evaporatedcanejce",
        "free-flowingbrownsugars",
        "goldensgr",
        "goldensyrp",
        "icingsgr",
        "invertsgr",
        "maplesyrp",
        "molasses",
        "muscovado",
        "palmsgr",
        "panocha",
        "powderedsgr",
        "rawsgr",
        "refiner'ssyrp",
        "saccharose",
        "sorghumsyrp",
        "sucrose",
        "sugar",
        "syrup",
        "sweet sorghum",
        "treacle",
        "turbinadosgr",
        "yellowsgr",
    ]
    var replacedOtherSugarIngredients: [String] = [
        "sgralcl",
        "agavenctr",
        "barleymlt",
        "cornsweetener",
        "cornsyrpsolids",
        "datesgr",
        "dextrin",
        "dextrose",
        "fructose",
        "frtjce",
        "fruitjcecnctrte",
        "glucose",
        "glucsslds",
        "grapesgr",
        "hfcs (high-fruct cs)",
        "highfructsecrnsyrp",
        "honey",
        "maltsyrp",
        "maltodxtrn",
        "maltol",
        "maltose",
        "mannose",
        "ricesyrp",
        "cornsyp",
        "erythritol",
        "maltitol",
        "mannitol",
        "sorbitol",
        "xylitol",
        "hydrogenated starch hydrolysates",
        "isomalt",
        "mnkfrutxtrct",
        "mnkfrt",
    ]
    
    
    func makingIngredientsUnique(productIngredients: String) -> String {
        var replacedProductIngredients = productIngredients
        var x: Int = 0
        
        while x < sucrIngredients.count {
            replacedProductIngredients = replacedProductIngredients.replacingOccurrences(of: sucrIngredients[x], with: replacedSucrIngredients[x])
            x = x + 1
        }
        
        x = 0
        
        while x < otherSugarIngredients.count {
            replacedProductIngredients = replacedProductIngredients.replacingOccurrences(of: otherSugarIngredients[x], with: replacedOtherSugarIngredients[x])
            x = x + 1
        }
        
        return replacedProductIngredients
    }
    
    func getSucroseIngredients(productIngredients: String) -> [String] {
        
        var returnedSugarIngredients: [String] = []
        
        var x: Int = 0
        while x < replacedSucrIngredients.count {
            if productIngredients.contains(replacedSucrIngredients[x]) {
                returnedSugarIngredients.append(sucrIngredients[x])
            }
            x = x + 1
        }
        
        return returnedSugarIngredients
    }
    
    func getOtherSugarIngredients(productIngredients: String) -> [String] {
        
        var returnedOtherSugarIngredients: [String] = []
        
        var x: Int = 0
        while x < replacedOtherSugarIngredients.count {
            if productIngredients.contains(replacedOtherSugarIngredients[x]) {
                returnedOtherSugarIngredients.append(otherSugarIngredients[x])
            }
            x = x + 1
        }
        
        return returnedOtherSugarIngredients
    }
}
