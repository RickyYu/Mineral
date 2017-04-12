//
//  AlbumToolbarView.swift
//  PhotoPicker
//
//  Created by liangqi on 16/3/8.
//  Copyright © 2016年 dailyios. All rights reserved.
//

import UIKit

protocol AlbumToolbarViewDelegate: class{
    func onFinishedButtonClicked()
}

class AlbumToolbarView: UIView {
    
    var doneNumberAnimationLayer: UIView?
    var labelTextView: UILabel?
    var buttonDone: UIButton?
    var doneNumberContainer: UIView?
    
    weak var delegate: AlbumToolbarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView(){
        self.backgroundColor = UIColor.whiteColor()
        let bounds = self.bounds
        let width = bounds.width
        let toolbarHeight = bounds.height
        let buttonWidth: CGFloat = 40
        let buttonHeight: CGFloat = 40
        let padding:CGFloat = 5
        
        // button
        self.buttonDone = UIButton(type: .Custom)
        buttonDone!.frame = CGRectMake(width - buttonWidth - padding, (toolbarHeight - buttonHeight) / 2, buttonWidth, buttonHeight)
        buttonDone!.setTitle(PhotoPickerConfig.ButtonDone, forState: .Normal)
        buttonDone!.titleLabel?.font = UIFont.systemFontOfSize(16.0)
        buttonDone!.setTitleColor(UIColor.blackColor(), forState: .Normal)
        buttonDone!.addTarget(self, action: #selector(AlbumToolbarView.eventDoneClicked), forControlEvents: .TouchUpInside)
        buttonDone!.enabled = true
        buttonDone!.setTitleColor(UIColor.grayColor(), forState: .Disabled)
        
        self.addSubview(self.buttonDone!)
        
        // done number
        let labelWidth:CGFloat = 20
        let labelX = CGRectGetMinX(buttonDone!.frame) - labelWidth
        let labelY = (toolbarHeight - labelWidth) / 2
        
        self.doneNumberContainer = UIView(frame: CGRectMake(labelX, labelY, labelWidth, labelWidth))
        let labelRect = CGRectMake(0, 0, labelWidth, labelWidth)
        self.doneNumberAnimationLayer = UIView.init(frame: labelRect)
        self.doneNumberAnimationLayer!.backgroundColor = UIColor.init(red: 7/255, green: 179/255, blue: 20/255, alpha: 1)
        self.doneNumberAnimationLayer!.layer.cornerRadius = labelWidth / 2
        doneNumberContainer!.addSubview(self.doneNumberAnimationLayer!)
        
        self.labelTextView = UILabel(frame: labelRect)
        self.labelTextView!.textAlignment = .Center
        self.labelTextView!.backgroundColor = UIColor.clearColor()
        self.labelTextView!.textColor = UIColor.whiteColor()
        doneNumberContainer!.addSubview(self.labelTextView!)
        
        
        doneNumberContainer?.hidden = true
        
        self.addSubview(self.doneNumberContainer!)
        
        // 添加分割线
        let divider = UIView(frame: CGRectMake(0, 0, width, 1))
        divider.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.15)
        self.addSubview(divider)
    }
    
    // MARK: -  toolbar delegate
    func eventDoneClicked(){
        if let delegate = self.delegate {
            delegate.onFinishedButtonClicked()
        }
    }
    
    func changeNumber(number:Int){
        self.labelTextView?.text = String(number)
        if number > 0 {
            self.buttonDone?.enabled = true
            self.doneNumberContainer?.hidden = false
            self.doneNumberAnimationLayer!.transform = CGAffineTransformMakeScale(0.5, 0.5)
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.doneNumberAnimationLayer!.transform = CGAffineTransformMakeScale(1.0, 1.0)
                }, completion: nil)
        } else {
            self.buttonDone?.enabled  = false
            self.doneNumberContainer?.hidden = true
        }
    }
    
}
