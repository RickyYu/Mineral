 //
//  PhotoCollectionViewController.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/6.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "photoCollectionViewCell"

protocol PhotoCollectionViewControllerDelegate:class {
    func onPreviewPageBack()
}

class PhotoCollectionViewController: UICollectionViewController, PHPhotoLibraryChangeObserver,PhotoCollectionViewCellDelegate,PhotoCollectionViewControllerDelegate,AlbumToolbarViewDelegate {
	
    let imageManager = PHCachingImageManager()
	private let toolbarHeight: CGFloat = 44.0
	
	var assetGridThumbnailSize: CGSize?
	var fetchResult: PHFetchResult?
	var previousPreheatRect: CGRect?
    var toolbar: AlbumToolbarView?
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        let originFrame = self.collectionView!.frame
        self.collectionView!.frame = CGRectMake(originFrame.origin.x, originFrame.origin.y, originFrame.size.width, originFrame.height - self.toolbarHeight)
        
		self.resetCacheAssets()
        
		PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
		
		self.collectionView?.contentInset = UIEdgeInsetsMake(
            PhotoPickerConfig.MinimumInteritemSpacing,
            PhotoPickerConfig.MinimumInteritemSpacing,
            PhotoPickerConfig.MinimumInteritemSpacing,
            PhotoPickerConfig.MinimumInteritemSpacing
        )
		
		self.collectionView!.registerNib(UINib.init(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
		
		self.configBackground()
        self.configBottomToolBar()
        self.configNavigationBar()
	}
    
	private func configBottomToolBar() {
        if self.toolbar != nil {return}
		let width = UIScreen.mainScreen().bounds.width
        let positionX = UIScreen.mainScreen().bounds.height - self.toolbarHeight
        self.toolbar = AlbumToolbarView(frame: CGRectMake(0,positionX,width,self.toolbarHeight))
        self.toolbar?.delegate = self
		self.view.addSubview(self.toolbar!)
        
        if PhotoImage.instance.selectedImage.count > 0 {
            self.toolbar?.changeNumber(PhotoImage.instance.selectedImage.count)
        }
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBarHidden = false
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        
        if assetGridThumbnailSize == nil {
            let scale = UIScreen.mainScreen().scale
            let cellSize = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
            let size = cellSize.width * scale
            assetGridThumbnailSize = CGSizeMake(size, size)
        }
	}
    
    // MARK: - AlbumToolbarViewDelegate
    func onFinishedButtonClicked() {
        if let nav = self.navigationController as? PhotoPickerController {
            nav.imageSelectFinish()
        }
    }
    
    private func configNavigationBar(){
        let cancelButton = UIBarButtonItem.init(barButtonSystemItem: .Cancel, target: self, action: #selector(PhotoCollectionViewController.eventCancel))
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    // MARK: -  cancel
    func eventCancel(){
        PhotoImage.instance.selectedImage.removeAll()
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		self.updateCacheAssets()
	}
	
	// MARK: -   image caches
	private func resetCacheAssets() {
		self.imageManager.stopCachingImagesForAllAssets()
		self.previousPreheatRect = CGRectZero
	}
	
	func updateCacheAssets() {
		let isViewVisible = self.isViewLoaded() && self.view.window != nil;
		if !isViewVisible { return; }
		
		// The preheat window is twice the height of the visible rect.
		var preheatRect = self.collectionView?.bounds
		if preheatRect != nil {
			preheatRect = CGRectInset(preheatRect!, 0, -0.5 * CGRectGetHeight(preheatRect!)) ;
			
			let delta = abs(CGRectGetMidY(preheatRect!) - CGRectGetMidY(self.previousPreheatRect!))
			
			if (delta > CGRectGetHeight(self.collectionView!.bounds) / 3.0) {
				
				var addedIndexPaths = [NSIndexPath]()
				var removedIndexPaths = [NSIndexPath]()
				self.computeDifferenceBetweenRect(self.previousPreheatRect!, newRect: preheatRect!, removedHandler: { (removedRect) -> Void in
						// somde code
						let indexPaths = self.collectionView!.aapl_indexPathsForElementsInRect(removedRect)
						if indexPaths != nil {
							removedIndexPaths.appendContentsOf(indexPaths!)
						}
					}, addedHandler: { (addedRect) -> Void in
						
						let indexPaths = self.collectionView!.aapl_indexPathsForElementsInRect(addedRect)
						if indexPaths != nil {
							addedIndexPaths.appendContentsOf(indexPaths!)
						}
					})
				
				let assetsToStartCaching = self.assetsAtIndexPaths(addedIndexPaths)
				let assetsToStopCaching = self.assetsAtIndexPaths(removedIndexPaths)
				
				if assetsToStartCaching != nil {
					self.imageManager.startCachingImagesForAssets(assetsToStartCaching!, targetSize: self.assetGridThumbnailSize!, contentMode: .AspectFill, options: nil)
				}
				
				if assetsToStopCaching != nil {
					self.imageManager.stopCachingImagesForAssets(assetsToStopCaching!, targetSize: self.assetGridThumbnailSize!, contentMode: .AspectFill, options: nil)
				}
				
				self.previousPreheatRect = preheatRect;
			}
		}
	}
    
    // MARK: -  PhotoCollectionViewCellDelegate
    func eventSelectNumberChange(number: Int) {
        if let toolbar = self.toolbar {
            toolbar.changeNumber(number)
        }
    }
    
	override func scrollViewDidScroll(scrollView: UIScrollView) {
		self.updateCacheAssets()
	}
	
	func assetsAtIndexPaths(indexPaths: [NSIndexPath]) -> [PHAsset]? {
		if indexPaths.count == 0 { return nil; }
		var assets = [PHAsset]()
		for indexPath in indexPaths {
			if let asset = self.fetchResult![indexPath.item] as? PHAsset {
				assets.append(asset)
			}
		}
		return assets;
	}
	
	func computeDifferenceBetweenRect(oldRect: CGRect, newRect: CGRect, removedHandler: (CGRect) -> Void, addedHandler: (CGRect) -> Void) {
		
		if CGRectIntersectsRect(newRect, oldRect) {
			let oldMaxY = CGRectGetMaxY(oldRect)
			let oldMinY = CGRectGetMaxX(oldRect)
			let newMaxY = CGRectGetMaxY(newRect) ;
			let newMinY = CGRectGetMinY(newRect) ;
			
			if newMaxY > oldMaxY {
				let rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY))
				addedHandler(rectToAdd)
			}
			
			if oldMinY > newMinY {
				let rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY))
				addedHandler(rectToAdd)
			}
			
			if newMaxY < oldMaxY {
				let rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY))
				removedHandler(rectToRemove)
			}
			
			if oldMinY < newMinY {
				let rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY))
				removedHandler(rectToRemove)
			}
		} else {
			addedHandler(newRect) ;
			removedHandler(oldRect) ;
		}
	}
	
	deinit {
		PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
	}
	
	func photoLibraryDidChange(changeInstance: PHChange) {
		if let collectionChanges = changeInstance.changeDetailsForFetchResult(self.fetchResult!) {
			
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
					
					self.fetchResult = collectionChanges.fetchResultAfterChanges
					let collectionView = self.collectionView!;
					
					if !(collectionChanges.hasIncrementalChanges || collectionChanges.hasMoves) {
						collectionView.reloadData()
					} else {
						collectionView.performBatchUpdates({ () -> Void in
								if let removedIndexes = collectionChanges.removedIndexes {
									
									if removedIndexes.count > 0 {
										collectionView.deleteItemsAtIndexPaths(removedIndexes.aapl_indexPathsFromIndexesWithSection(0))
									}
								}
								
								if let insertedIndexes = collectionChanges.insertedIndexes {
									if insertedIndexes.count > 0 {
										collectionView.insertItemsAtIndexPaths(insertedIndexes.aapl_indexPathsFromIndexesWithSection(0))
									}
								}
							}, completion: nil)
					}
					
					self.resetCacheAssets()
				})
		}
	}
	
	private func configBackground() {
		self.collectionView?.backgroundColor = UIColor.whiteColor()
	}
	
	override init(collectionViewLayout layout: UICollectionViewLayout) {
		super.init(collectionViewLayout: layout)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	class func configCustomCollectionLayout() -> UICollectionViewFlowLayout {
		let collectionLayout = UICollectionViewFlowLayout()
		
		let width = UIScreen.mainScreen().bounds.width - PhotoPickerConfig.MinimumInteritemSpacing * 2
		collectionLayout.minimumInteritemSpacing = PhotoPickerConfig.MinimumInteritemSpacing
		
		let cellToUsableWidth = width - (PhotoPickerConfig.ColNumber - 1) * PhotoPickerConfig.MinimumInteritemSpacing
		let size = cellToUsableWidth / PhotoPickerConfig.ColNumber
		collectionLayout.itemSize = CGSizeMake(size, size)
		collectionLayout.minimumLineSpacing = PhotoPickerConfig.MinimumInteritemSpacing
		return collectionLayout
	}
	
	// MARK: -  UICollectionView delegate
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.fetchResult != nil ? self.fetchResult!.count : 0
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! photoCollectionViewCell
		
		cell.delegate = self;
        cell.eventDelegate = self
		
		if let asset = self.fetchResult![indexPath.row] as? PHAsset {
			cell.model = asset
			cell.representedAssetIdentifier = asset.localIdentifier
			self.imageManager.requestImageForAsset(asset, targetSize: self.assetGridThumbnailSize!, contentMode: .AspectFill, options: nil) { (image, info) -> Void in
				if cell.representedAssetIdentifier == asset.localIdentifier {
					cell.thumbnail.image = image
				}
			}
            cell.updateSelected(PhotoImage.instance.selectedImage.indexOf(asset) != nil)
		}
		return cell
	}
	
	// MARK: UICollectionViewDelegate
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let previewController = PhotoPreviewViewController(nibName: nil, bundle: nil)
        previewController.allSelectImage = self.fetchResult
        previewController.currentPage = indexPath.row
        previewController.fromDelegate = self
        self.navigationController?.showViewController(previewController, sender: nil)
	}
    
    func onPreviewPageBack() {
        self.collectionView?.reloadData()
        self.eventSelectNumberChange(PhotoImage.instance.selectedImage.count)
    }
}
