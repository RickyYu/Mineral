//
//  PhotoPreviewBottomBarView.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/9.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit

protocol PhotoPreviewBottomBarViewDelegate:class{
    func onDoneButtonClicked()
}

class PhotoPreviewBottomBarView: UIView {
    
    var doneNumberAnimationLayer: UIView?
    var labelTextView: UILabel?
    var buttonDone: UIButton?
    var doneNumberContainer: UIView?
    
    weak var delegate: PhotoPreviewBottomBarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configView()
    }
    
    private func configView(){
        self.backgroundColor = PhotoPickerConfig.PreviewBarBackgroundColor
        
        // button
        self.buttonDone = UIButton(type: .Custom)
        
        let toolbarHeight = bounds.height
        let buttonWidth: CGFloat = 40
        let buttonHeight: CGFloat = 40
        let padding:CGFloat = 5
        let width = self.bounds.width
        
        buttonDone!.frame = CGRectMake(width - buttonWidth - padding, (toolbarHeight - buttonHeight) / 2, buttonWidth, buttonHeight)
        buttonDone!.setTitle(PhotoPickerConfig.ButtonDone, forState: .Normal)
        buttonDone!.titleLabel?.font = UIFont.systemFontOfSize(16.0)
        buttonDone!.setTitleColor(PhotoPickerConfig.GreenTinColor, forState: .Normal)
        buttonDone!.addTarget(self, action: #selector(PhotoPreviewBottomBarView.eventDoneClicked), forControlEvents: .TouchUpInside)
        buttonDone!.enabled = true
        buttonDone!.setTitleColor(UIColor.blackColor(), forState: .Disabled)
        self.addSubview(self.buttonDone!)
        
        // done number
        let labelWidth:CGFloat = 20
        let labelX = CGRectGetMinX(buttonDone!.frame) - labelWidth
        let labelY = (toolbarHeight - labelWidth) / 2
        
        self.doneNumberContainer = UIView(frame: CGRectMake(labelX, labelY, labelWidth, labelWidth))
        let labelRect = CGRectMake(0, 0, labelWidth, labelWidth)
        self.doneNumberAnimationLayer = UIView.init(frame: labelRect)
        self.doneNumberAnimationLayer!.backgroundColor = PhotoPickerConfig.GreenTinColor
        self.doneNumberAnimationLayer!.layer.cornerRadius = labelWidth / 2
        doneNumberContainer!.addSubview(self.doneNumberAnimationLayer!)
        
        self.labelTextView = UILabel(frame: labelRect)
        self.labelTextView!.textAlignment = .Center
        self.labelTextView!.backgroundColor = UIColor.clearColor()
        self.labelTextView!.textColor = UIColor.whiteColor()
        doneNumberContainer!.addSubview(self.labelTextView!)
        
        self.addSubview(self.doneNumberContainer!)
    }
    
    // MARK: -  Event delegate
    func eventDoneClicked(){
        if let delegate = self.delegate{
            delegate.onDoneButtonClicked()
        }
    }
    
    func changeNumber(number:Int,animation:Bool){
        self.labelTextView?.text = String(number)
        if number > 0 {
            self.buttonDone?.enabled = true
            self.doneNumberContainer?.hidden = false
            if animation {
                self.doneNumberAnimationLayer!.transform = CGAffineTransformMakeScale(0.5, 0.5)
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    self.doneNumberAnimationLayer!.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    }, completion: nil)
            }
            
        } else {
            self.buttonDone?.enabled  = false
            self.doneNumberContainer?.hidden = true
        }
    }

}
