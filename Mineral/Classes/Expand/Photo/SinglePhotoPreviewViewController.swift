//
//  SinglePhotoPreviewViewController.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/12.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit
import Photos

class SinglePhotoPreviewViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,PhotoPreviewCellDelegate {
    
    var selectImages:[PhotoImageModel]?
    
    private var collectionView: UICollectionView?
    private let cellIdentifier = "cellIdentifier"
    var currentPage: Int = 0
    var sourceDelegate: PhotoViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "back", style: .Plain, target: self, action: nil)
        
        self.configNavigationBar()
        self.configCollectionView()
    }
    
    private func configNavigationBar(){
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: #selector(SinglePhotoPreviewViewController.eventRemoveImage))
    }
    
    func eventRemoveImage(){
        let element = self.selectImages?.removeAtIndex(self.currentPage)
        self.updatePageTitle()
        self.sourceDelegate?.removeElement(element?.data?.localIdentifier)
        
        if self.selectImages?.count > 0{
            self.collectionView?.reloadData()
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.setContentOffset(CGPointMake(CGFloat(self.currentPage) * self.view.bounds.width, 0), animated: false)
        self.updatePageTitle()
    }
    
    private func updatePageTitle(){
        self.title =  String(self.currentPage+1) + "/" + String(self.selectImages!.count)
    }
    
    func configCollectionView(){
        self.automaticallyAdjustsScrollViewInsets = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(self.view.frame.width,self.view.frame.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
        self.collectionView!.pagingEnabled = true
        self.collectionView!.scrollsToTop = false
        self.collectionView!.showsHorizontalScrollIndicator = false
        self.collectionView!.contentOffset = CGPointMake(0, 0)
        self.collectionView!.contentSize = CGSizeMake(self.view.bounds.width * CGFloat(self.selectImages!.count), self.view.bounds.height)
        
        self.view.addSubview(self.collectionView!)
        self.collectionView!.registerClass(PhotoPreviewCell.self, forCellWithReuseIdentifier: self.cellIdentifier)
    }
    
    // MARK: -  collectionView dataSource delagate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectImages!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! PhotoPreviewCell
        cell.delegate = self
        if let asset = self.selectImages?[indexPath.row] {
            cell.renderModel(asset.data!)
        }
        
        return cell
    }
    
    // MARK: -  Photo Preview Cell Delegate
    func onImageSingleTap() {
        let status = !UIApplication.sharedApplication().statusBarHidden
        UIApplication.sharedApplication().setStatusBarHidden(status, withAnimation: .Slide)
        self.navigationController?.setNavigationBarHidden(status, animated: true)
    }
    
    // MARK: -  scroll page
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        self.currentPage = Int(offset.x / self.view.bounds.width)
        self.updatePageTitle()
    }
    
}
