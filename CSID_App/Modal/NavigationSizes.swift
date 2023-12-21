//
//  NavigationSizes.swift
//  CSID_App
//
//  Created by Vince Muller on 11/2/23.
//

import Foundation

struct NavSize: {
    let navBar: Float = navigationController?.navigationBar.frame.height
    let tabBar: Float = tabBarController?.tabBar.frame.height
}
