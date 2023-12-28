//
//  UIHelper.swift
//
//  Created by Vince Muller on 11/2/23.
//

import UIKit

struct UIHelper {
    
    static func createTwoColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width                   = view.bounds.width
        let padding: CGFloat        = 5
        let minimumSpacing: CGFloat = 10
        let availableWidth          = width - (padding * 2) - (minimumSpacing * 1)
        let itemWidth               = availableWidth / 2
        
        let flowLayout                  = UICollectionViewFlowLayout()
        flowLayout.sectionInset         = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.minimumLineSpacing   = 10
        flowLayout.itemSize             = CGSize(width: itemWidth, height: itemWidth/1.5)
        
        return flowLayout
    }
    
    static func createOneColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width               = view.bounds.width
        let padding: CGFloat    = 5
        let availableWidth      = width - padding
        let itemWidth           = availableWidth
        
        let flowLayout          = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        flowLayout.itemSize     = CGSize(width: itemWidth, height: 64.0)
        flowLayout.minimumLineSpacing = 0
        
        return flowLayout
    }
    
    static func createOverLappingFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width               = view.bounds.width-20
        let padding: CGFloat    = 5
        let availableWidth      = width - padding
        let itemWidth           = availableWidth
        
        let flowLayout          = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        flowLayout.itemSize     = CGSize(width: itemWidth, height: 190)
        flowLayout.minimumLineSpacing = -150
        
        return flowLayout
        
    }
}
