//
//  Area.swift
//  yhintegrationES
//
//  Created by 安生科技 on 16/9/26.
//  Copyright © 2016年 安生科技. All rights reserved.
//

import Foundation

class Area:BaseModel {
    /// 一级区域
    var firstarea: [[String: String]] = []
    /// 二级区域
    var secondarea: [[String: String]] = []
    /// 三级区域
    var thirdarea: [[String: String]] = []
    /// 四级区域
    var foutharea: [[String: String]] = []
    
    override init() {
        super.init()
    }
    
    func getLayerNum() -> Int {
        var num = 0
        if !self.firstarea.isEmpty {
            num += 1
        }
        if !self.secondarea.isEmpty {
            num += 1
        }
        if !self.thirdarea.isEmpty {
            num += 1
        }
        if !self.foutharea.isEmpty {
            num += 1
        }
        return num
    }
    
    func getCode2CN(code: String) -> String{
        for area in self.firstarea {
            if area["code"] == code {
                return area["name"]!
            }
        }
        
        for area in self.secondarea {
            if area["code"] == code {
                return area["name"]!
            }
        }
        
        for area in self.thirdarea {
            if area["code"] == code {
                return area["name"]!
            }
        }
        
        for area in self.foutharea {
            if area["code"] == code {
                return area["name"]!
            }
        }
        return ""
    }
    
    //从nsobject解析回来
    init(coder aDecoder: NSCoder!){
        self.firstarea = aDecoder.decodeObjectForKey("firstarea") as! [[String: String]]
        self.secondarea = aDecoder.decodeObjectForKey("secondarea") as! [[String: String]]
        self.thirdarea = aDecoder.decodeObjectForKey("thirdarea") as! [[String: String]]
        self.foutharea = aDecoder.decodeObjectForKey("foutharea") as! [[String: String]]
    }
    
    //编码成object
    func encodeWithCoder(aCoder: NSCoder!){
        aCoder.encodeObject(firstarea, forKey: "firstarea")
        aCoder.encodeObject(secondarea, forKey: "secondarea")
        aCoder.encodeObject(thirdarea, forKey: "thirdarea")
        aCoder.encodeObject(foutharea, forKey: "foutharea")
    }
}