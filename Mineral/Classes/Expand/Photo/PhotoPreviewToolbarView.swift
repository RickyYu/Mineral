//
//  PhotoPreviewToolbarView.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/9.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit

protocol PhotoPreviewToolbarViewDelegate: class {
    func onToolbarBackArrowClicked();
    func onSelected(select:Bool)
}

class PhotoPreviewToolbarView: UIView {
    
    weak var delegate: PhotoPreviewToolbarViewDelegate?
    weak var sourceDelegate: PhotoPreviewViewController?
    
    private var checkboxBg: UIImageView?
    private var checkbox: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configView()
    }
    
    private func configView(){
        self.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        
        // back arrow buttton
        let backArrow = UIButton(frame: CGRectMake(5,5,40,40))
        let backArrowImage = UIImage(named: "arrow_back")
        backArrow.setImage(backArrowImage, forState: UIControlState.Normal)
        backArrow.addTarget(self, action: #selector(PhotoPreviewToolbarView.eventBackArrow), forControlEvents: .TouchUpInside)
        self.addSubview(backArrow)
        
        // right checkbox
        let padding: CGFloat = 10
        let checkboxWidth: CGFloat = 30
        let checkboxHeight = checkboxWidth
        let checkboxPositionX = self.bounds.width - checkboxWidth - padding
        let checkboxPositionY = (self.bounds.height - checkboxHeight) / 2
        
        self.checkbox = UIButton(type: .Custom)
        checkbox!.frame = CGRectMake(checkboxPositionX,checkboxPositionY,checkboxWidth,checkboxHeight)
        checkbox!.addTarget(self, action: #selector(PhotoPreviewToolbarView.eventCheckbox(_:)), forControlEvents: .TouchUpInside)
        
        let checkboxFront = UIImageView(image: UIImage(named: "picture_unselect"))
        checkboxFront.contentMode = .ScaleAspectFill
        checkboxFront.frame = checkbox!.bounds
        checkbox!.addSubview(checkboxFront)
        
        self.checkboxBg = UIImageView(image: UIImage(named: "picture_select"))
        checkboxBg!.contentMode = .ScaleAspectFill
        checkboxBg!.frame = checkbox!.bounds
        checkboxBg!.hidden = true
        
        self.checkbox!.addSubview(checkboxBg!)
        
        self.addSubview(checkbox!)
    }
    
    // MARK: -  Event
    func eventBackArrow(){
        if let delegate = self.delegate {
            delegate.onToolbarBackArrowClicked()
        }
    }
    
    func setSelect(select:Bool){
        self.checkboxBg!.hidden = !select
        self.checkbox!.selected = select
    }
    
    func eventCheckbox(sender: UIButton){
        if sender.selected {
            sender.selected = false
            self.checkboxBg!.hidden = true
            if let delegate = self.delegate {
                delegate.onSelected(false)
            }
        } else {
            if let _ = self.sourceDelegate {
                if PhotoImage.instance.selectedImage.count >= PhotoPickerController.imageMaxSelectedNum - PhotoPickerController.alreadySelectedImageNum {
                    return self.showSelectErrorDialog()
                }
            }
            sender.selected = true
            self.checkboxBg!.hidden = false
            self.checkboxBg!.transform = CGAffineTransformMakeScale(0.8, 0.8)
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 8, options: [UIViewAnimationOptions.CurveEaseIn], animations: { () -> Void in
                self.checkboxBg!.transform = CGAffineTransformMakeScale(1, 1)
                }, completion: nil)
            
            if let delegate = self.delegate {
                delegate.onSelected(true)
            }
        }
    }
    
    private func showSelectErrorDialog() {
        if self.sourceDelegate != nil {
            let less = PhotoPickerController.imageMaxSelectedNum - PhotoPickerController.alreadySelectedImageNum
            
            let range = PhotoPickerConfig.ErrorImageMaxSelect.rangeOfString("#")
            var error = PhotoPickerConfig.ErrorImageMaxSelect
            error.replaceRange(range!, with: String(less))
            
            let alert = UIAlertController.init(title: nil, message: error, preferredStyle: UIAlertControllerStyle.Alert)
            let confirmAction = UIAlertAction(title: PhotoPickerConfig.ButtonConfirmTitle, style: .Default, handler: nil)
            alert.addAction(confirmAction)
            self.sourceDelegate?.presentViewController(alert, animated: true, completion: nil)
        }
    }

}
