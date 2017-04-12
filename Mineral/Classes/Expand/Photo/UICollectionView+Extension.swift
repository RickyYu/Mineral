//
//  UICollectionView+Extension.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/10.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func aapl_indexPathsForElementsInRect(rect: CGRect) -> [NSIndexPath]? {
        let allLayoutAttributes = self.collectionViewLayout.layoutAttributesForElementsInRect(rect)
        if allLayoutAttributes == nil || allLayoutAttributes!.count == 0 {
            return nil
        }
        var indexPaths = [NSIndexPath]()
        for layoutAttributes in allLayoutAttributes! {
            let indexPath = layoutAttributes.indexPath
            indexPaths.append(indexPath)
        }
        return indexPaths;
    }
}