//
//  ErrorMessage.swift
//  CSID_App
//
//  Created by Vince Muller on 12/20/2023.
//

import Foundation

enum CAAlertTitle: String, Error {
    case foodAdded          = "Food Added"
    case unableToAdd        = "Unable to Add"
    case foodFavorited      = "Food Favorited"
    case unableToFavorite   = "Unable to Favorite"
    case favoriteRemoved    = "Favorite Removed"
    case favoriteNotRemoved = "Unable to Remove Favorite"
    case foodDeleted        = "Food Deleted"
    case foodUpdated        = "Food Updated"
    case unableToUpdate     = "Unable to Update"
    case unableToDelete     = "Unable to Delete"
    case alreadyInFavs      = "Already in Favorites"
    
}

enum CAAlertMessage: String, Error {
    case foodAdded          = "You have successfully created and added this food to your foods"
    case unableToAdd        = "Your food did not get added, please try again"
    case foodFavorited      = "You have added this food to your favorites"
    case unableToFavorite   = "Unfortunately your food was not favorited, please try again"
    case favoriteRemoved    = "You have successfully removed this food from your favorites"
    case favoriteNotRemoved = "Unfortunately your favorite was not able to be removed, please try again"
    case foodDeleted        = "You have successfully deleted your food item"
    case foodUpdated        = "You have successfully updated your food item"
    case unableToUpdate     = "Unfortunately your food was not able to be updated, please try again"
    case unableToDelete     = "Unfortunately your food was not able to be deleted, please try again"
    case alreadyInFavs      = "This food is already in your favorites"
}
