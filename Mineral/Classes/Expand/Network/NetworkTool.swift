//
//  NetworkTool.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2016/11/23.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD


class NetworkTool: Alamofire.Manager {
    // MARK: - 单例
    internal static let sharedTools: NetworkTool = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        var header : Dictionary =  Manager.defaultHTTPHeaders
        configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        return NetworkTool(configuration: configuration)
        
    }()
    
    //获取AppStore版本号
    func getVersion(parameters:[String:AnyObject],finished: (data : String!, error: String!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        let path = NSString(format: "http://itunes.apple.com/cn/lookup?id=%@", APPSTOR_ID) as String
        self.sendPostRequest(path, parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                finished(data:nil,error: "服务器异常")
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("getCompanyInfo = \(dict)")
                _ = dict["resultCount"].numberValue
//                let results = dict["results"] as? NSArray
//                if let dict = results!.firstObject as? NSDictionary {
//                    if let version = dict["version"] as? String {
//                    finished(data: version,error: nil) //success  false
//                    }
//                }else{
//                  finished(data: nil,error: "") //success  false
//                }

                SVProgressHUD.dismiss()
            }else {
                finished(data: nil,error: "数据异常")
            }
            
        }
    }

    
    //MARK: - 登陆
    func login(parameters:[String:AnyObject],finished:(login:Login!,error:String!)->()){
          SVProgressHUD.showWithStatus("正在加载...")
        let identify = ""
        var addParameters = parameters
        addParameters["client"] = "ios"
        let key = "SAFETYS_CLIENT_AUTH_KEY_2016="+identify
        let headers = [
            "Cookie": key,
            "Accept-Language" : "zh-CN,zh;q=0.8,en;q=0.6"
        ]
        //"Content-Type": "application/json;charset=UTF-8"  加上此header报type不能为空
        request(.POST, AppTools.getServiceURLWithYh("LOGIN"), parameters: addParameters, encoding: .URL, headers: headers).responseJSON(queue: dispatch_get_main_queue(), options: []){(response) in
            guard response.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus(NOTICE_NETWORK_FAILED)
                return
            }
            if let dictValue = response.result.value{
                let dict = JSON(dictValue)
                print("login.dict = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    let login = Login(json:dict)
                    finished(login: login, error: nil)
                    
                }else{
                    SVProgressHUD.dismiss()
                    finished(login: nil,error: message) //success  false
                }
            }else {
                finished(login: nil,error: NOTICE_NETWORK_FAILED)
            }
            
        }
    }
    
    
    
    func getCompanyInfo(parameters:[String:AnyObject],finished: (data : ShopInfoModel!, error: String!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("GET_COMPANY_INFO"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("getCompanyInfo = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    let data = ShopInfoModel(dict:dict["entity"].dictionaryObject!)
                    
                    finished(data: data, error: nil)
                }else{
                    finished(data: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(data: nil,error: NOTICE_NETWORK_FAILED)
            }
            
        }
    }
    
    
    func getRecordCount(parameters:[String:AnyObject],finished: (data : [SalesCountModel]!, error: String!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("GET_RECORD_COUNT"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus("加载失败...")
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("getRecordCount = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    if let items = dict["json"].arrayObject {
                        var salesCountModels = [SalesCountModel]()
                        for item in items {
                            let homeItem = SalesCountModel(dict: item as! [String: AnyObject])
                            salesCountModels.append(homeItem)
                        }
                        SalesCountModel.savaSalesCountModels(salesCountModels)
                        finished(data: salesCountModels,error: nil)
                    }
                    
                }else{
                    finished(data: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(data: nil,error: NOTICE_NETWORK_FAILED)
            }
            
        }
    }
    
    
    func getRecordInfo(parameters:[String:AnyObject],finished: (data : SaleRecordModel!, error: String!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("GET_RECORD_INFO"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus(NOTICE_NETWORK_FAILED)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("getRecordInfo = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    
                    let data = SaleRecordModel(dict:dict["entity"].dictionaryObject!)
                    finished(data: data, error: nil)
                    
                }else{
                    finished(data: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(data: nil,error: NOTICE_NETWORK_FAILED)
            }
            
        }
    }
    
    func updatePassWord(parameters:[String:AnyObject],finished: (data :String!, error: String!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("UPDATE_PASSWORD"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus(NOTICE_NETWORK_FAILED)

                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("getRecordInfo = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    finished(data: "success",error: nil)
                    
                }else{
                    finished(data: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(data: nil,error: NOTICE_NETWORK_FAILED)
            }
            
        }
    }

    
    func updateCpyInfo(parameters:[String:AnyObject],finished: (data : String!, error: String!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("UPDATE_CPY_INFO"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus(NOTICE_NETWORK_FAILED)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("update = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                     finished(data: "success",error: nil)
                    
                }else{
                    finished(data: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                SVProgressHUD.dismiss()
                finished(data: nil,error: NOTICE_NETWORK_FAILED)
            }
            
        }
    }
    
    
    
    func deleteSaleRecord(parameters:[String:AnyObject],finished: (data : String!, error: String!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("DELETE_SALE_RECORD"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus(NOTICE_NETWORK_FAILED)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("deleteSaleRecord = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    finished(data: "success",error: nil)
                    
                }else{
                    finished(data: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(data: nil,error: NOTICE_NETWORK_FAILED)
            }
            
        }
    }
    
    func saveInfo(parameters:[String:AnyObject],finished: (data : String!, error: String!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("SAVE_SALE_RECORDS"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus(NOTICE_NETWORK_FAILED)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("saveInfo = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                    finished(data: "success",error: nil) //success  false
                    
                }else{
                    finished(data: nil,error: message) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(data: nil,error: "数据异常")
            }
            
        }
    }
    
    func getRecordList(parameters:[String:AnyObject],finished: (data : [SaleRecordModel]!, error: String!,totalCount:Int!)->()) {
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithYh("GET_RECORD_LIST"), parameters: parameters) { (response) in
            
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus(NOTICE_NETWORK_FAILED)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("getRecordList = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                let totalCount = dict["totalCount"].intValue
                //  字典转成模型
                if success {
                    if let items = dict["json"].arrayObject {
                        var saleRecordModels = [SaleRecordModel]()
                        for item in items {
                            let homeItem = SaleRecordModel(dict: item as! [String: AnyObject])
                            saleRecordModels.append(homeItem)
                        }
                        finished(data: saleRecordModels,error: nil,totalCount: totalCount)
                        //  保存在本地 暂无需使用
                        // CpyInfoModel.savaCpyInfoModels(cpyInfoModels)
                    }
                    
                }else{
                    finished(data: nil,error: message,totalCount: nil) //success  false
                }
                SVProgressHUD.dismiss()
            }else {
                finished(data: nil,error: NOTICE_NETWORK_FAILED,totalCount: nil)
            }
            
        }
    }
    
    
    //MARK:获取企业经纬度
    func getPoint(parameters:[String:AnyObject],finished:(locInfoModel:Login!,error:String!)->()){
        SVProgressHUD.showWithStatus("正在加载...")
        self.sendPostRequest(AppTools.getServiceURLWithDa("GET_POINT"), parameters: parameters) { (response) in
            guard response!.result.isSuccess else {
                SVProgressHUD.showErrorWithStatus(NOTICE_NETWORK_FAILED)
                return
            }
            if let dictValue = response!.result.value{
                let dict = JSON(dictValue)
                print("getPoint.dict = \(dict)")
                let success = dict["success"].boolValue
                let message = dict["msg"].stringValue
                //  字典转成模型
                if success {
                }else{
                    finished(locInfoModel: nil,error: message) //success  false
                }
                 SVProgressHUD.dismiss()
            }else {
                finished(locInfoModel: nil,error: NOTICE_NETWORK_FAILED)
            }
           
            
        }
    }
    

    func sendPostRequest(URL:String,parameters:[String:AnyObject],finished:(response:Response<AnyObject, NSError>!)->()){
        let identify = AppTools.loadNSUserDefaultsValue("identify") as! String
        var addParameters = parameters
        addParameters["client"] = "ios"
        let key = "SXS_FIREWORK_CLIENT_AUTH_KEY_2017="+identify
                      let headers = [
            "Cookie": key,
            "Accept-Language" : "zh-CN,zh;q=0.8,en;q=0.6"
            ]
        //"Content-Type": "application/json;charset=UTF-8"  加上此header报type不能为空
          request(.POST, URL, parameters: addParameters, encoding: .URL, headers: headers).responseJSON(queue: dispatch_get_main_queue(), options: []){(response) in
               finished(response: response)
        }

     }
    }
