//
//  User.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2016/11/23.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//

import Foundation
/// 用户信息
class User: BaseModel {
    var userName: String!
    var userPassword: String!
    
    /// 用户所属企业名称
    var userCompany: String!
    /// 用户所属企业ID
    var companyId: String!
    /// 用户姓名
    var factName: String!
    ///电话号码
    var phone:String!
    
    init(userCompany: String, companyId: String, factName: String) {
        self.userCompany = userCompany
        self.companyId = companyId
        self.factName = factName
    }
    init(userCompany: String,  factName: String) {
        self.userCompany = userCompany
        self.factName = factName
    }
    
    init(cpyName: String,  phone: String) {
        self.userCompany = cpyName
        self.phone = phone
    }
    
    //从nsobject解析回来
    init(coder aDecoder: NSCoder!){
        self.userName = aDecoder.decodeObjectForKey("userName") as! String
        self.userPassword = aDecoder.decodeObjectForKey("userPassword") as! String
        self.userCompany = aDecoder.decodeObjectForKey("userCompany") as! String
//        self.companyId = aDecoder.decodeObjectForKey("companyId") as! String
      //  self.factName = aDecoder.decodeObjectForKey("factName") as! String
        self.phone = aDecoder.decodeObjectForKey("phone") as! String
    }
    
    //编码成object
    func encodeWithCoder(aCoder: NSCoder!){
        aCoder.encodeObject(userName, forKey: "userName")
        aCoder.encodeObject(userPassword, forKey: "userPassword")
        aCoder.encodeObject(userCompany, forKey: "userCompany")
//        aCoder.encodeObject(companyId, forKey: "companyId")
        aCoder.encodeObject(factName, forKey: "factName")
         aCoder.encodeObject(phone, forKey: "phone")
    }
}