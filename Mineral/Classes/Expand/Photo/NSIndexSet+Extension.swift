//
//  NSIndexSet+Extension.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/7.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import Foundation

extension NSIndexSet {

    func aapl_indexPathsFromIndexesWithSection(section:Int) -> [NSIndexPath] {
        var indexPaths = [NSIndexPath]()
        self.enumerateIndexesUsingBlock { (idx, stop) -> Void in
            indexPaths.append(NSIndexPath.init(forItem: idx, inSection: section))
        }
        return indexPaths;
    }
}