//
//  ErrorMessage.swift
//  CSID_App
//
//  Created by Vince Muller on 12/20/2023.
//

import Foundation

enum CAError: String {
    case invalidUserID      = "Unable to retrieve iCloud details, please make sure you are signed into your iCloud account and try again."
    case unableToRemove     = "This item is still being saved to your favorites, please try again"
    case invalidResponse    = "Invalid response from the server. Please try again."
}
