//
//  PhotoImageManager.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/8.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit
import Photos

private let instance = PhotoImageManager() ;

class PhotoImageManager: PHCachingImageManager {
    // singleton class
    static let sharedManager = PhotoImageManager()
    private override init() {super.init()}
    
    func getPhotoByMaxSize(asset: PHObject, size: CGFloat, completion: (UIImage?, [NSObject : AnyObject]?)->Void){
        
        let maxSize = size > PhotoPickerConfig.PreviewImageMaxFetchMaxWidth ? PhotoPickerConfig.PreviewImageMaxFetchMaxWidth : size
        if let asset = asset as? PHAsset {
            
            let factor = CGFloat(asset.pixelHeight)/CGFloat(asset.pixelWidth)
            let scale = UIScreen.mainScreen().scale
            let pixcelWidth = maxSize * scale
            let pixcelHeight = CGFloat(pixcelWidth) * factor
            
            PhotoImageManager.sharedManager.requestImageForAsset(asset, targetSize: CGSizeMake(pixcelWidth, pixcelHeight), contentMode: .AspectFit, options: nil, resultHandler: { (image, info) -> Void in
                
                if let info = info as? [String:AnyObject] {
                    let canceled = info[PHImageCancelledKey] as? Bool
                    let error = info[PHImageErrorKey] as? NSError
                    
                    if canceled == nil && error == nil && image != nil {
                        completion(image,info)
                    }
                    
                    // download from iCloud
                    let isCloud = info[PHImageResultIsInCloudKey] as? Bool
                    if isCloud != nil && image == nil {
                        let options = PHImageRequestOptions()
                        options.networkAccessAllowed = true
                        PhotoImageManager.sharedManager.requestImageDataForAsset(asset, options: options, resultHandler: { (data, dataUTI, oritation, info) -> Void in
                            
                            if let data = data {
                                let resultImage = UIImage(data: data, scale: 0.1)
                                completion(resultImage,info)
                            }
                        })
                    }
                }
            })
        }
    }


}
