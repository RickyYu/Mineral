//
//  AppTools.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2016/11/23.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

///自定义帮助类
public class AppTools {
    ///获取当前设备的屏幕高度
    static let CURRENT_HEIGHT = UIScreen.mainScreen().bounds.height
    ///获取当前设备的屏幕宽度
    static let CURRENT_WIDTH = UIScreen.mainScreen().bounds.width
    
    class func string2JSON(string: String) -> JSON {
        let nsData = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        return JSON(data: nsData!)
    }
    
    class func JSON2String(json: JSON) -> String {
        if json == nil {
            return ""
        }
        return String(json)
        
    }
    
    class func anyObject2String(ao: AnyObject) -> String{
        if !(ao is String.Type) {
            return String(ao)
        }
        return ao as! String
    }
    
    ///获取请求地址-隐患排查
    class func getServiceURLWithYh(key: String) -> String {
        let url = PlistTools.loadStringValue("BASE_URL_YH")
        let key = PlistTools.loadStringValue(key)
        return (url + key)
    }
    
    ///获取请求地址-档案
    class func getServiceURLWithDa(key: String) -> String {
        let url = PlistTools.loadStringValue("BASE_URL_DA")
        let key = PlistTools.loadStringValue(key)
        return (url + key)
    }
    
    ///内容为空
    class func isEmpty(text: String) -> Bool {
        return text.isEmpty
    }
    ///内容不为空
    class func isNotEmpty(text: String) -> Bool {
        return !isEmpty(text)
    }
    ///获取本地数据存储对象
    class func getNSUserDefaults() -> NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    ///是否存在本地数据key对象
    class func isExisNSUserDefaultsKey(key: String) -> Bool{
        return (self.loadNSUserDefaultsValue(key) != nil)
    }
    
    ///获取本地数据存储对象key对应的Value
    class func loadNSUserDefaultsValue(key: String) -> AnyObject? {
        return self.getNSUserDefaults().objectForKey(key)
    }
    
    class func loadNSUserDefaultsClassValue(key: String) -> AnyObject? {
        let modelData:NSData = self.loadNSUserDefaultsValue(key) as! NSData
        let myModel = NSKeyedUnarchiver.unarchiveObjectWithData(modelData)
        return myModel
    }
    
    class func setNSUserDefaultsClassValue(key: String, _ value: AnyObject) {
        let modelData:NSData = NSKeyedArchiver.archivedDataWithRootObject(value)
        AppTools.setNSUserDefaultsValue(key, modelData)
    }
    
    ///保存数据到本地存储(键值对方式)
    class func setNSUserDefaultsValue(key: String, _ value: AnyObject) {
        self.getNSUserDefaults().setObject(value, forKey: key)
    }

    
    ///删除本地存储数据
    class func removeNSUserDefaultsKey(key: String) {
        self.getNSUserDefaults().removeObjectForKey(key)
    }
    
    ///是否iPhone4
    class func isIPhone4() -> Bool {
        return self.CURRENT_HEIGHT == iPhoneVersion.getIPhone4().height
    }
    ///是否iPhone5
    class func isIPhone5() -> Bool {
        return self.CURRENT_HEIGHT == iPhoneVersion.getIPhone5().height
    }
    ///是否iPhone6
    class func isIPhone6() -> Bool {
        return self.CURRENT_HEIGHT == iPhoneVersion.getIPhone6().height
    }
    ///是否iPhone6Plus
    class func isIPhone6Plus() -> Bool {
        return self.CURRENT_HEIGHT == iPhoneVersion.getIPhone6Plus().height
    }
    ///获取当前设备的型号
    class func getCurrentiPhone() -> iPhoneVersion {
        if isIPhone6Plus() {
            return iPhoneVersion.iPhone6Plus
        }
        if isIPhone6() {
            return iPhoneVersion.iPhone6
        }
        if isIPhone5() {
            return iPhoneVersion.iPhone5
        }
        if isIPhone4() {
            return iPhoneVersion.iPhone4
        }
        return iPhoneVersion.iPhoneOther
    }
    
    ///获取设备型号版本
    class func getCurrentEquipment() -> String {
        let name = UnsafeMutablePointer<utsname>.alloc(1)
        uname(name)
        let machine = withUnsafePointer(&name.memory.machine, { (ptr) -> String? in
            let int8Ptr = unsafeBitCast(ptr, UnsafePointer<CChar>.self)
            return String.fromCString(int8Ptr)
        })
        name.dealloc(1)
        if let deviceString = machine {
            switch deviceString {
            //iPhone
            case "iPhone1,1":
                return "iPhone 1G"
            case "iPhone1,2":
                return "iPhone 3G"
            case "iPhone2,1":
                return "iPhone 3GS"
            case "iPhone3,1", "iPhone3,2":
                return "iPhone 4"
            case "iPhone4,1": return "iPhone 4S"
            case "iPhone5,1", "iPhone5,2":
                return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":
                return "iPhone 5C"
            case "iPhone6,1", "iPhone6,2":
                return "iPhone 5S"
            case "iPhone7,1":
                return "iPhone 6 Plus"
            case "iPhone7,2":
                return "iPhone 6"
            case "iPhone8,1":
                return "iPhone 6s"
            case "iPhone8,2":
                return "iPhone 6s Plus"
            default:
                return deviceString
            }
        } else {
            return ""
        }
    }
    
    //随机数生成器函数
    class func createRandomMan(start: Int, end: Int) ->() ->Int! {
        //根据参数初始化可选值数组
        var nums = [Int]();
        for i in start...end{
            nums.append(i)
        }
        
        func randomMan() -> Int! {
            if !nums.isEmpty {
                //随机返回一个数，同时从数组里删除
                let index = Int(arc4random_uniform(UInt32(nums.count)))
                return nums.removeAtIndex(index)
            }
            else {
                //所有值都随机完则返回nil
                return nil
            }
        }
        
        return randomMan
    }
}

