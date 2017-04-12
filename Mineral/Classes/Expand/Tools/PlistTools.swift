//
//  PlistTools.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2016/11/23.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//

import Foundation
class PlistTools {
    //网络请求地址
    static let URL_PLIST: String = "url"
    
    ///读取plist资源文件
    class func loadPlist(plistName: String) -> NSMutableDictionary {
        let diaryList:String = NSBundle.mainBundle().pathForResource(plistName, ofType:"plist")!
        return NSMutableDictionary(contentsOfFile:diaryList)!
    }
    ///读取key对应common资源文件的StringValue
    class func loadStringValue(key: String) -> String {
        return self.loadPlist(self.URL_PLIST).objectForKey(key) as! String
    }
    ///读取key对应common资源文件的NSArrayValue
    class func loadNSArrayValue(key: String) -> NSArray {
        return self.loadPlist(self.URL_PLIST).objectForKey(key) as! NSArray
    }
    ///读取key对应common资源文件的BoolValue
    class func loadBoolValue(key: String) -> Bool {
        return self.loadPlist(self.URL_PLIST).objectForKey(key) as! Bool
    }
}