//
//  PhotoPickerController.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/5.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit
import Photos

enum PageType{
    case List
    case RecentAlbum
    case AllAlbum
}

protocol PhotoPickerControllerDelegate: class{
    func onImageSelectFinished(images: [PHAsset])
}

class PhotoPickerController: UINavigationController {
    
    // the select image max number
    static var imageMaxSelectedNum = 9
    
    // already select total
    static var alreadySelectedImageNum = 0
    
    
    weak var imageSelectDelegate: PhotoPickerControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(type:PageType){
        let rootViewController = PhotoAlbumsTableViewController(style:.Plain)
        // clear cache
        PhotoImage.instance.selectedImage.removeAll()
        super.init(rootViewController: rootViewController)
        
        if type == .RecentAlbum || type == .AllAlbum {
            let currentType = type == .RecentAlbum ? PHAssetCollectionSubtype.SmartAlbumRecentlyAdded : PHAssetCollectionSubtype.SmartAlbumUserLibrary
            let results = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype:currentType, options: nil)
            if results.count > 0 {
                if let model = self.getModel(results[0] as! PHAssetCollection) {
                    if model.count > 0 {
                        let layout = PhotoCollectionViewController.configCustomCollectionLayout()
                        let controller = PhotoCollectionViewController(collectionViewLayout: layout)
                        controller.fetchResult = model
                        self.pushViewController(controller, animated: false)
                    }
                }
            }
        }
    }
    
    
    private func getModel(collection: PHAssetCollection) -> PHFetchResult?{
        let fetchResult = PHAsset.fetchAssetsInAssetCollection(collection, options: PhotoFetchOptions.shareInstance)
        if fetchResult.count > 0 {
            return fetchResult
        }
        return nil
    }
   
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func imageSelectFinish(){
        if self.imageSelectDelegate != nil {
            self.dismissViewControllerAnimated(true, completion: nil)
            self.imageSelectDelegate?.onImageSelectFinished(PhotoImage.instance.selectedImage)
        }
    }

}