//
//  ValidateEnum.swift
//  Mineral
//
//  Created by Ricky on 2017/3/27.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import Foundation
enum ValidateEnum {
    case email(_: String)
    case phoneNum(_: String)
    case carNum(_: String)
    case username(_: String)
    case password(_: String)
    case nickname(_: String)
    case URL(_: String)
    case IP(_: String)
    case cardNum(_: String)
    
    
    var isRight: Bool {
        var predicateStr:String!
        var currObject:String!
        switch self {
        case let .email(str):
            predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            currObject = str
        case let .phoneNum(str):
            predicateStr = "^(1[0-9]{10})|([0-9]{7,8})|(0\\d{2,3}-\\d{5,9})$"
//            "^((1[0-9]{10})|(15[^4,\\D]) |(17[0,0-9])|(18[0,0-9]))\\d{8}$"
            currObject = str
        case let .carNum(str):
            predicateStr = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
            currObject = str
        case let .username(str):
            predicateStr = "^[A-Za-z0-9]{6,20}+$"
            currObject = str
        case let .password(str):
            
            predicateStr = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,18}$"
//                "^[a-zA-Z0-9]{6,18}+$"
            currObject = str
        case let .nickname(str):
            predicateStr = "^[\\u4e00-\\u9fa5]{4,8}$"
            currObject = str
        case let .URL(str):
            predicateStr = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
            currObject = str
        case let .IP(str):
            predicateStr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
            currObject = str
        case let .cardNum(str):
            predicateStr = "^(\\d{18})|[0-9]{17}(x|X)$"
//            "^(\\d{18})|([0-9]){17}(x|X)?$"
            currObject = str
        }
        
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        return predicate.evaluateWithObject(currObject)
    }
}