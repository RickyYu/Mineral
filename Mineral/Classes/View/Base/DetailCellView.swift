//
//  DetailCellView.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2016/12/7.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//

import UIKit
import SnapKit

class DetailCellView: UIView {
    
    var lineView = UIView()
    var label = UILabel()

    var rightLabel =  UILabel()
    var leftImg  = UIImageView()
    var rightImg  = UIImageView()
    var centerLabel = UILabel()
    var rightCheckBtn = UIButton()
    var textView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        label.font = UIFont.boldSystemFontOfSize(13)
        label.frame = CGRectMake(28, 5, 100, 35)
        label.textColor = UIColor.grayColor()


        lineView.frame = CGRectMake(3, 42, SCREEN_WIDTH-6, 2)
        lineView.backgroundColor = UIColor.lightGrayColor()
        
        self.addSubview(label)

        self.addSubview(lineView)
 
    }
    
    func setLabelName(name:String) {
        label.text = name
    }
    
    func setLeftImage(imageName:String){
        leftImg  = UIImageView()
        leftImg.image = UIImage(named: imageName)
        leftImg.frame = CGRectMake(5, 10, 30, 20)
        self.addSubview(leftImg)
    }
    
    func setRightImage(imageName:String){
        rightImg  = UIImageView()
        rightImg.image = UIImage(named: "right_arrow")
        rightImg.frame = CGRectMake(SCREEN_WIDTH-40, 10, 20, 20)
        self.addSubview(rightImg)
    }

    
    func setRRightLabel(name:String){

        rightLabel.text = name
        rightLabel.font = UIFont.boldSystemFontOfSize(13)
        rightLabel.frame = CGRectMake(SCREEN_WIDTH-100, 5, 120, 35)
        rightLabel.textColor = UIColor.grayColor()
        rightLabel.textAlignment = .Right
        self.addSubview(rightLabel)
     
    }
    



    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DetailCellView {
    
    func addOnClickListener(target: AnyObject, action: Selector) {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = 1
        userInteractionEnabled = true
        addGestureRecognizer(gr)
    }
    
}