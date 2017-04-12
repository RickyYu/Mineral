//
//  BaseModel.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2016/11/23.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//

import Foundation

class BaseModel: NSObject {
    
    func getClassAllPropertys() -> [String] {
        var result = [String]()
        let count = UnsafeMutablePointer<UInt32>.alloc(0)
        let buff = class_copyPropertyList(object_getClass(self), count)
        let countInt = Int(count[0])
        
        for i in 0..<countInt {
            let temp = buff[i]
            let tempPro = property_getName(temp)
            let proper = String(UTF8String: tempPro)
            result.append(proper!)
        }
        return result
    }

}