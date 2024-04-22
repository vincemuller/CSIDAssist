//
//  SucroseIngredientClass.swift
//  CSID_App
//
//  Created by Vince Muller on 12/28/23.
//

import UIKit

class SucroseCheck {
    var sucrIngredients: [String] = [
        "organic free-flowing brown sugars",
        "organic dehydrated cane juice",
        "organic evaporated cane juice",
        "organic confectioner's sugar",
        "organic cane juice crystals",
        "organic coconut palm sugar",
        "free-flowing brown sugars",
        "organic barley malt syrup",
        "organic refiner's syrup",
        "organic turbinado sugar",
        "organic barbados sugar",
        "organic buttered syrup",
        "organic cemerara sugar",
        "organic powdered sugar",
        "dehydrated cane juice",
        "evaporated cane juice",
        "organic coconut sugar",
        "organic sorghum Syrup",
        "organic sweet sorghum",
        "confectioner's sugar",
        "organic castor sugar",
        "organic golden sugar",
        "organic golden syrup",
        "organic invert sugar",
        "organic yellow sugar",
        "cane juice crystals",
        "organic brown sugar",
        "organic carob syrup",
        "organic icing sugar",
        "organic maple syrup",
        "coconut palm sugar",
        "organic beet sugar",
        "organic cane juice",
        "organic cane sugar",
        "organic cane syrup",
        "organic palm sugar",
        "organic saccharose",
        "barley malt syrup",
        "organic muscovado",
        "organic raw sugar",
        "organic molasses",
        "refiner's syrup",
        "turbinado sugar",
        "organic caramel",
        "organic panocha",
        "organic sucrose",
        "organic treacle",
        "buttered syrup",
        "cemerara sugar",
        "powdered sugar",
       "barbados sugar",
        "coconut sugar",
        "sorghum Syrup",
        "sweet sorghum",
        "organic sugar",
        "organic syrup",
        "castor sugar",
        "golden sugar",
        "golden syrup",
        "invert sugar",
        "yellow sugar",
        "brown sugar",
        "carob syrup",
        "icing sugar",
        "maple syrup",
        "beet sugar",
        "cane juice",
        "cane sugar",
        "cane syrup",
        "palm sugar",
        "saccharose",
        "muscovado",
        "raw sugar",
        "molasses",
        "caramel",
        "panocha",
        "sucrose",
        "treacle",
        "sugar",
        "syrup"
    ]
    
    var otherSugarIngredients: [String] = [
        "sugar alcohol",
        "agave nectar",
        "agave syrup",
        "barley malt",
        "brown rice syrup",
        "brown rice syrup solids",
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
        "monk fruit",
        "organic sugar alcohol",
        "organic agave nectar",
        "organic agave syrup",
        "organic barley malt",
        "organic brown rice syrup",
        "organic brown rice syrup solids",
        "organic corn sweetener",
        "organic corn syrup solids",
        "organic date sugar",
        "organic dextrin",
        "organic dextrose",
        "organic fructose",
        "organic fruit juice",
        "organic fruit juice concentrate",
        "organic glucose",
        "organic glucose solids",
        "organic grape sugar",
        "organic hfcs (high-fructose corn syrup)",
        "organic high fructose corn syrup",
        "organic honey",
        "organic malt syrup",
        "organic maltodextrin",
        "organic maltol",
        "organic maltose",
        "organic mannose",
        "organic rice syrup",
        "organic corn syrup",
        "organic erythritol",
        "organic maltitol",
        "organic mannitol",
        "organic sorbitol",
        "organic xylitol",
        "organic hydrogenated starch hydrolysates",
        "organic isomalt",
        "organic monk fruit extract",
        "organic monk fruit"
    ]
    
    var replacedOtherSugarIngredients: [String] = [
    ]
    
    
    //Sugar = "$sugar&" | "$sugar," | ", sugar," | ", sugar&"
    func getSucroseIngredientsEnhanced(productIngredients: String) -> [String] {
        var prodIngredients = productIngredients.replacingOccurrences(of: "\n", with: ", ")
        var returnedSugarIngredients: [String] = []
        prodIngredients = "$" + prodIngredients.lowercased() + "&"
        
        var x: Int = 0
        while x < sucrIngredients.count {
            let firstCheck = "$" + sucrIngredients[x].lowercased() + "&" // "$sugar&"
            let secondCheck = "$" + sucrIngredients[x].lowercased() + "," // "$sugar,"
            let thirdCheck = ", " + sucrIngredients[x].lowercased() + "," // ", sugar,"
            let fourthCheck = ", " + sucrIngredients[x].lowercased() + "&" // ", sugar&"
            let fifthCheck = "[" + sucrIngredients[x].lowercased() + "," // "[sugar,"
            let sixthCheck = ", " + sucrIngredients[x].lowercased() + "]" // ", sugar]"
            let seventhCheck = "(" + sucrIngredients[x].lowercased() + "," // "(sugar,"
            let eighthCheck = ", " + sucrIngredients[x].lowercased() + ")" // ", sugar)"
            let ninthCheck = "{" + sucrIngredients[x].lowercased() + "," // "{sugar,"
            let tenthCheck = ", " + sucrIngredients[x].lowercased() + "}" // ", sugar)"
            
            //Sugar detection checks
            if (prodIngredients.contains(firstCheck) ||
                prodIngredients.contains(secondCheck) ||
                prodIngredients.contains(thirdCheck) ||
                prodIngredients.contains(fourthCheck) ||
                prodIngredients.contains(fifthCheck) ||
                prodIngredients.contains(sixthCheck) ||
                prodIngredients.contains(seventhCheck) ||
                prodIngredients.contains(eighthCheck) ||
                prodIngredients.contains(ninthCheck) ||
                prodIngredients.contains(tenthCheck)
                )
                
            {
                returnedSugarIngredients.append(sucrIngredients[x])
            }
            x = x + 1
        }
        return returnedSugarIngredients
    }
    
    func getOtherSugarIngredients(productIngredients: String) -> [String] {
        var prodIngredients = productIngredients.replacingOccurrences(of: "\n", with: ", ")
        print(prodIngredients)
        var returnedOtherSugarIngredients: [String] = []
        prodIngredients = "$" + prodIngredients.lowercased() + "&"
        
        var x: Int = 0
        while x < otherSugarIngredients.count {
            let firstCheck = "$" + otherSugarIngredients[x].lowercased() + "&" // "$dextrose&"
            let secondCheck = "$" + otherSugarIngredients[x].lowercased() + "," // "$dextrose,"
            let thirdCheck = ", " + otherSugarIngredients[x].lowercased() + "," // ", dextrose,"
            let fourthCheck = ", " + otherSugarIngredients[x].lowercased() + "&" // ", dextrose&"
            let fifthCheck = "[" + otherSugarIngredients[x].lowercased() + "," // "[dextrose,"
            let sixthCheck = ", " + otherSugarIngredients[x].lowercased() + "]" // ", dextrose]"
            let seventhCheck = "(" + otherSugarIngredients[x].lowercased() + "," // "(dextrose,"
            let eighthCheck = ", " + otherSugarIngredients[x].lowercased() + ")" // ", dextrose)"
            let ninthCheck = "{" + otherSugarIngredients[x].lowercased() + "," // "{dextrose,"
            let tenthCheck = ", " + otherSugarIngredients[x].lowercased() + "}" // ", dextrose)"
            
            //Other sugar ingredient detection checks
            if (prodIngredients.contains(firstCheck) ||
                prodIngredients.contains(secondCheck) ||
                prodIngredients.contains(thirdCheck) ||
                prodIngredients.contains(fourthCheck) ||
                prodIngredients.contains(fifthCheck) ||
                prodIngredients.contains(sixthCheck) ||
                prodIngredients.contains(seventhCheck) ||
                prodIngredients.contains(eighthCheck) ||
                prodIngredients.contains(ninthCheck) ||
                prodIngredients.contains(tenthCheck)
                )
                
            {
                returnedOtherSugarIngredients.append(otherSugarIngredients[x])
            }
            x = x + 1
        }
        return returnedOtherSugarIngredients
    }
}
