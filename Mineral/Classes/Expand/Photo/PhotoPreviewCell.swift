//
//  PhotoPreviewCell.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/8.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit
import Photos

protocol PhotoPreviewCellDelegate: class{
    func onImageSingleTap()
}

class PhotoPreviewCell: UICollectionViewCell, UIScrollViewDelegate {
	
	var model: PHAsset?
	private var scrollView: UIScrollView?
	private var imageContainerView = UIView()
	private var imageView = UIImageView()
    
    weak var delegate: PhotoPreviewCellDelegate?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.configView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.configView()
	}
	
	func configView() {
		self.scrollView = UIScrollView(frame: self.bounds)
		self.scrollView!.bouncesZoom = true
		self.scrollView!.maximumZoomScale = 2.5
		self.scrollView!.multipleTouchEnabled = true
		self.scrollView!.delegate = self
		self.scrollView!.scrollsToTop = false
		self.scrollView!.showsHorizontalScrollIndicator = false
		self.scrollView!.showsVerticalScrollIndicator = false
		self.scrollView!.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		self.scrollView!.delaysContentTouches = false
		self.scrollView!.canCancelContentTouches = true
		self.scrollView!.alwaysBounceVertical = false
		self.addSubview(self.scrollView!)
		
		self.imageContainerView.clipsToBounds = true
		self.scrollView!.addSubview(self.imageContainerView)
		
		self.imageView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
		self.imageView.clipsToBounds = true
		self.imageContainerView.addSubview(self.imageView)
		
		let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(PhotoPreviewCell.singleTap(_:)))
		let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(PhotoPreviewCell.doubleTap(_:)))
		
		doubleTap.numberOfTapsRequired = 2
		singleTap.requireGestureRecognizerToFail(doubleTap)
		
		self.addGestureRecognizer(singleTap)
		self.addGestureRecognizer(doubleTap)
	}
    
    
	func renderModel(asset: PHAsset) {
		PhotoImageManager.sharedManager.getPhotoByMaxSize(asset, size: self.bounds.width) { (image, info) -> Void in
			self.imageView.image = image
			self.resizeImageView()
		}
	}
	
	func resizeImageView() {
		self.imageContainerView.frame = CGRectMake(0, 0, self.frame.width, self.imageContainerView.bounds.height)
		let image = self.imageView.image!
        
        
		if image.size.height / image.size.width > self.bounds.height / self.bounds.width {
			
			let height = floor(image.size.height / (image.size.width / self.bounds.width))
			var originFrame = self.imageContainerView.frame
			originFrame.size.height = height
			self.imageContainerView.frame = originFrame
		} else {
			var height = image.size.height / image.size.width * self.frame.width
			if height < 1 || isnan(height) {
				height = self.frame.height
			}
			height = floor(height)
			var originFrame = self.imageContainerView.frame
            originFrame.size.height = height
			self.imageContainerView.frame = originFrame
			self.imageContainerView.center = CGPointMake(self.imageContainerView.center.x, self.bounds.height / 2)
		}
		
		if self.imageContainerView.frame.height > self.frame.height && self.imageContainerView.frame.height - self.frame.height <= 1 {
			
			var originFrame = self.imageContainerView.frame
			originFrame.size.height = self.frame.height
			self.imageContainerView.frame = originFrame
		}
		
		self.scrollView?.contentSize = CGSizeMake(self.frame.width, max(self.imageContainerView.frame.height, self.frame.height))
		self.scrollView?.scrollRectToVisible(self.bounds, animated: false)
		self.scrollView?.alwaysBounceVertical = self.imageContainerView.frame.height > self.frame.height
		self.imageView.frame = self.imageContainerView.bounds
        
	}
	
	func singleTap(tap:UITapGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.onImageSingleTap()
        }
	}
	
    func doubleTap(tap:UITapGestureRecognizer) {
        if (self.scrollView!.zoomScale > 1.0) {
            // 状态还原
            self.scrollView!.setZoomScale(1.0, animated: true)
        } else {
            let touchPoint = tap.locationInView(self.imageView)
            let newZoomScale = self.scrollView!.maximumZoomScale
            let xsize = self.frame.size.width / newZoomScale
            let ysize = self.frame.size.height / newZoomScale
            self.scrollView!.zoomToRect(CGRectMake(touchPoint.x - xsize/2, touchPoint.y-ysize/2, xsize, ysize), animated: true)
        }
	}
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageContainerView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        let offsetX = (scrollView.frame.width > scrollView.contentSize.width) ? (scrollView.frame.width - scrollView.contentSize.width) * 0.5 : 0.0;
        let offsetY = (scrollView.frame.height > scrollView.contentSize.height) ? (scrollView.frame.height - scrollView.contentSize.height) * 0.5 : 0.0;
        self.imageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    }
}
