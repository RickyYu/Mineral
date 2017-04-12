//
//  iPhoneVersion.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2016/11/23.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//

import Foundation

import UIKit

public enum iPhoneVersion {
    case iPhone4
    case iPhone5
    case iPhone6
    case iPhone6Plus
    //case iPhone7
    //case iPhone7Plus
    case iPhoneOther
    
    public static func getIPhone4() -> (width:CGFloat, height:CGFloat) {
        return (320, 480)
    }
    
    public static func getIPhone5() -> (width:CGFloat, height:CGFloat) {
        return (320, 568)
    }
    
    public static func getIPhone6() -> (width:CGFloat, height:CGFloat) {
        return (375, 667)
    }
    
    public static func getIPhone6Plus() -> (width:CGFloat, height:CGFloat) {
        return (414, 736)
    }
}