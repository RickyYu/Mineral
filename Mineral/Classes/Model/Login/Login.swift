//
//  Login.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2016/11/23.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//

import Foundation
import SwiftyJSON
/// 登录对象信息
class Login: BaseModel {
    var msg: String!
    var identify: String!
    var success: Bool!
    var user: User!
    override init() {
   
        
    }
    
    init(json: JSON) {
        self.msg = json["msg"].string!
        self.identify = json["identify"].string! ?? ""
        self.success = json["success"].bool!
        let entityJson = json["entity"].dictionaryObject
        let cpyName = entityJson!["name"] as? String ?? ""
        let phone = entityJson!["phone"] as? String ?? ""
        self.user = User(cpyName: cpyName, phone: phone)
    }
    init(success:Bool, msg: String,identify:String){
        self.success = success
        self.msg = msg
        self.identify = identify
    }
    
    //从nsobject解析回来
    init(coder aDecoder: NSCoder!){
        self.msg = aDecoder.decodeObjectForKey("msg") as! String
        self.identify = aDecoder.decodeObjectForKey("identify") as! String
        self.success = aDecoder.decodeObjectForKey("success") as! Bool
        self.user = aDecoder.decodeObjectForKey("user") as! User
    }
    
    //编码成object
    func encodeWithCoder(aCoder: NSCoder!){
        aCoder.encodeObject(msg, forKey: "msg")
        aCoder.encodeObject(identify, forKey: "identify")
        aCoder.encodeObject(success, forKey: "success")
        aCoder.encodeObject(user, forKey: "user")
    }
}