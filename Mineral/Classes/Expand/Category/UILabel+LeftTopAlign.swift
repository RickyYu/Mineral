//
//  UILabel+LeftTopAlign.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2016/12/19.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//

import UIKit

extension UILabel
{
    func textLeftToAlign(){
            self.textColor = UIColor.blackColor()
            self.backgroundColor = UIColor.whiteColor()
            self.numberOfLines = 0
            self.textAlignment = NSTextAlignment.Left
            self.adjustsFontSizeToFitWidth = true
            self.font = UIFont.systemFontOfSize(13)
            let text:String = self.text!//获取label的text
            let attributes = [NSFontAttributeName: self.font!]//计算label的字体
            self.frame = CGRectMake(self.frame.origin.x+5,self.frame.origin.y, CGRectGetWidth(self.frame), labelSize(text, attributes: attributes).height)
        }
        
        func labelSize(text:String ,attributes : [String : AnyObject]) -> CGRect{
            var size = CGRect();
            let size2 = CGSize(width: SCREEN_WIDTH-10, height: 0);//设置label的最大宽度
            size = text.boundingRectWithSize(size2, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes , context: nil);
            return size
        }
}
