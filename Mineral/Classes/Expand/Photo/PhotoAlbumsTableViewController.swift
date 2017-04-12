//
//  PhotoAlbumsTableViewController.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/5.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit
import Photos

class PhotoAlbumsTableViewController: UITableViewController,PHPhotoLibraryChangeObserver{
    
    // 自定义需要加载的相册
    var customSmartCollections = [
        PHAssetCollectionSubtype.SmartAlbumUserLibrary, // All Photos
        PHAssetCollectionSubtype.SmartAlbumRecentlyAdded // Rencent Added
    ]
    
    // tableCellIndetifier 
    let albumTableViewCellItentifier = "PhotoAlbumTableViewCell"
    var albums = [ImageModel]()
    let imageManager = PHImageManager.defaultManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 9.0以上添加截屏图片
        if #available(iOS 9.0, *) {
            customSmartCollections.append(.SmartAlbumScreenshots)
        }
        
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
        
        self.setupTableView()
        self.configNavigationBar()
        self.loadAlbums(false)

    }

    
    deinit{
        PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
    }
    
    func photoLibraryDidChange(changeInstance: PHChange) {
        self.loadAlbums(true)
    }
    
    private func setupTableView(){
        self.tableView.registerNib(UINib.init(nibName: self.albumTableViewCellItentifier, bundle: nil), forCellReuseIdentifier: self.albumTableViewCellItentifier)
        
        // 自定义 separatorLine样式
        self.tableView.rowHeight = PhotoPickerConfig.AlbumTableViewCellHeight
        self.tableView.separatorColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.15)
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        // 去除tableView多余空格线
        self.tableView.tableFooterView = UIView.init(frame: CGRectZero)
    }
    
    private func loadAlbums(replace: Bool){
        
        if replace {
            self.albums.removeAll()
        }
        
        // 加载Smart Albumns All Photos
        let smartAlbums = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .AlbumRegular, options: nil)
        
        for i in 0 ..< smartAlbums.count  {
            if let smartAlbumnItem = smartAlbums[i] as? PHAssetCollection {
                if customSmartCollections.contains(smartAlbumnItem.assetCollectionSubtype){
                    self.filterFetchResult(smartAlbumnItem)
                }
            }
        }
        
        // 用户相册
        let topUserLibarayList = PHCollectionList.fetchTopLevelUserCollectionsWithOptions(nil)
        for i in 0 ..< topUserLibarayList.count {
            if let topUserAlbumItem = topUserLibarayList[i] as? PHAssetCollection {
                self.filterFetchResult(topUserAlbumItem)
            }
        }
        
        self.tableView.reloadData()
    }
    
    private func filterFetchResult(collection: PHAssetCollection){
        let fetchResult = PHAsset.fetchAssetsInAssetCollection(collection, options: PhotoFetchOptions.shareInstance)
        if fetchResult.count > 0 {
            let model = ImageModel(result: fetchResult, label: collection.localizedTitle, assetType: collection.assetCollectionSubtype)
            self.albums.append(model)
        }
    }
    
    private func configNavigationBar(){
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(PhotoAlbumsTableViewController.eventViewControllerDismiss))
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    func eventViewControllerDismiss(){
        PhotoImage.instance.selectedImage.removeAll()
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.albumTableViewCellItentifier, forIndexPath: indexPath) as! PhotoAlbumTableViewCell
        
        let model = self.albums[indexPath.row]
        
        cell.renderData(model.fetchResult, label: model.label)
        cell.accessoryType = .DisclosureIndicator
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.showDetailPageModel(self.albums[indexPath.row])
        
    }
    
    private func showDetailPageModel(model: ImageModel){
        let layout = PhotoCollectionViewController.configCustomCollectionLayout()
        let controller = PhotoCollectionViewController(collectionViewLayout: layout)
    
        controller.fetchResult = model.fetchResult
        self.navigationController?.showViewController(controller, sender: nil)
    }
    

}
