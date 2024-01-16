//
//  ErrorMessage.swift
//  CSID_App
//
//  Created by Vince Muller on 12/20/2023.
//

import Foundation

enum CAAlertTitle: String, Error {
    case iCloudError        = "iCloud Error"
    case foodUpdated        = "Food Updated"
    case foodFavorited      = "Food Favorited"
    case foodRemoved        = "Food Removed"
    case unableToRemove     = "Unable to Remove"
    case unableToAdd        = "Unable to Add"
    case unableToUpdate     = "Unable to Update"
    case unableToFavorite   = "Unable to Favorite"
    case invalidResponse    = "Servor Error"
    
}

enum CAAlertMessage: String, Error {
    case generaliCloudError = "Unable to retrieve iCloud details, please make sure you have a secure internet connection & are signed into your iCloud account."
    case fetchFoodsError    = "Not able to fetch your foods"
    case unableToRemove     = "This item is still being saved to your favorites, please try again"
    case invalidResponse    = "Invalid response from the server. Please try again."
    case foodUpdated        = "You have successfully updated your food"
    case foodFavorited      = "You have added this food to your favorites"
    case favoriteRemoved    = "You successfully removed this food from your favorites"
    case foodRemoved        = "You have successfully removed this item from your foods"
}
