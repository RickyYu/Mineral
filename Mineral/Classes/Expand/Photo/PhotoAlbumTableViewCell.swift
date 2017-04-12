//
//  PhotoAlbumTableViewCell.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/6.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit
import Photos

class PhotoAlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumNumber: UILabel!
    
    let imageSize: CGFloat = 80
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsetsZero
        let bgView = UIView()
        bgView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
        self.selectedBackgroundView = bgView
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func renderData(result:PHFetchResult, label: String?){
        self.albumTitle.text = label
        self.albumNumber.text = String(result.count)
        
        if result.count > 0 {
            if let firstImageAsset = result[0] as? PHAsset {
                let retinaMultiplier = UIScreen.mainScreen().scale
                let realSize = self.imageSize * retinaMultiplier
                let size = CGSizeMake(realSize, realSize)
                
                let imageOptions = PHImageRequestOptions()
                imageOptions.resizeMode = .Exact
                
                PHImageManager.defaultManager().requestImageForAsset(firstImageAsset, targetSize: size, contentMode: .AspectFill, options: imageOptions, resultHandler: { (image, info) -> Void in
                    self.albumCover.image = image
                })
            }
        }
    }
    

}
