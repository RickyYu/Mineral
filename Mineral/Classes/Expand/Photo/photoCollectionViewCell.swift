//
//  photoCollectionViewCell.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/6.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit
import Photos
protocol PhotoCollectionViewCellDelegate: class {
    func eventSelectNumberChange(number: Int);
    
}
class photoCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var thumbnail: UIImageView!
	@IBOutlet weak var imageSelect: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    
	weak var delegate: PhotoCollectionViewController?
    weak var eventDelegate: PhotoCollectionViewCellDelegate?
	
	var representedAssetIdentifier: String?
	var model : PHAsset?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.thumbnail.contentMode = .ScaleAspectFill
		self.thumbnail.clipsToBounds = true
	}
    
    func updateSelected(select:Bool){
        self.selectButton.selected = select
        self.imageSelect.hidden = !select
        
        if select {
            self.selectButton.setImage(nil, forState: UIControlState.Normal)
        } else {
            self.selectButton.setImage(UIImage(named: "picture_unselect"), forState: UIControlState.Normal)
        }
    }
	
	@IBAction func eventImageSelect(sender: UIButton) {
		if sender.selected {
			sender.selected = false
			self.imageSelect.hidden = true
			sender.setImage(UIImage(named: "picture_unselect"), forState: UIControlState.Normal)
			if delegate != nil {
				if let index = PhotoImage.instance.selectedImage.indexOf(self.model!) {
					PhotoImage.instance.selectedImage.removeAtIndex(index)
				}
                
                if self.eventDelegate != nil {
                    self.eventDelegate!.eventSelectNumberChange(PhotoImage.instance.selectedImage.count)
                }
			}
		} else {
			
			if delegate != nil {
				if PhotoImage.instance.selectedImage.count >= PhotoPickerController.imageMaxSelectedNum - PhotoPickerController.alreadySelectedImageNum {
					self.showSelectErrorDialog() ;
					return;
				} else {
					PhotoImage.instance.selectedImage.append(self.model!)
                    
                    if self.eventDelegate != nil {
                        self.eventDelegate!.eventSelectNumberChange(PhotoImage.instance.selectedImage.count)
                    }
				}
			}
			
			sender.selected = true
            self.imageSelect.hidden = false
			sender.setImage(nil, forState: UIControlState.Normal)
			self.imageSelect.transform = CGAffineTransformMakeScale(0.8, 0.8)
			UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 6, options: [UIViewAnimationOptions.CurveEaseIn], animations: { () -> Void in
					self.imageSelect.transform = CGAffineTransformMakeScale(1.0, 1.0)
				}, completion: nil)
		}
	}
	
	private func showSelectErrorDialog() {
		if self.delegate != nil {
            let less = PhotoPickerController.imageMaxSelectedNum - PhotoPickerController.alreadySelectedImageNum
            
            let range = PhotoPickerConfig.ErrorImageMaxSelect.rangeOfString("#")
            var error = PhotoPickerConfig.ErrorImageMaxSelect
            error.replaceRange(range!, with: String(less))
            
			let alert = UIAlertController.init(title: nil, message: error, preferredStyle: UIAlertControllerStyle.Alert)
			let confirmAction = UIAlertAction(title: PhotoPickerConfig.ButtonConfirmTitle, style: .Default, handler: nil)
			alert.addAction(confirmAction)
			self.delegate?.presentViewController(alert, animated: true, completion: nil)
		}
	}
}
