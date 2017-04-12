//
//  ImageModel.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/11.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import Foundation
import Photos

struct ImageModel {
    var fetchResult: PHFetchResult
    var label: String?
    var assetType: PHAssetCollectionSubtype
    
    
    init(result: PHFetchResult,label: String?, assetType: PHAssetCollectionSubtype){
        self.fetchResult = result
        self.label = label
        self.assetType = assetType
    }
}