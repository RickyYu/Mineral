//
//  ShopInfoModel.swift
//  Mineral
//
//  Created by Ricky on 2017/3/20.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//


class ShopInfoModel:BaseModel,NSCoding{
    // MARK: - 保存和获取所有分类
    static let ShopInfoModelKey = "ShopInfoModelKey"
    var firstArea:Int!
    var businessRegNum:String!
    var thirdArea:Int!
    var businessScope:String!
    var principalPerson :String!
    var secondArea:Int!
    var companyName:String!
    var principalTelephone:String!
    var businessAddress:String!
    var areaName:String!
    var documentInfo:String!
    
    init(firstArea:Int) {
        self.firstArea = 0
        self.businessRegNum = ""
        self.thirdArea = 0
        self.businessScope = ""
        self.principalPerson = ""
        self.secondArea = 0
        self.companyName = ""
        self.principalTelephone =  ""
        self.businessAddress = ""
        self.documentInfo =  ""
        self.areaName = ""
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        self.firstArea = dict["firstArea"] as? Int
        self.businessRegNum = dict["businessRegNum"] as? String ?? ""
        self.thirdArea = dict["thirdArea"] as? Int ?? 0
        self.businessScope = dict["businessScope"] as? String ?? ""
        self.principalPerson = dict["principalPerson"] as? String ?? ""
        self.secondArea = dict["secondArea"] as? Int
        self.companyName = dict["companyName"] as? String ?? ""
        self.principalTelephone = dict["principalTelephone"] as? String ?? ""
        self.businessAddress = dict["businessAddress"] as? String ?? ""
        self.documentInfo = dict["documentInfo"] as? String ?? ""
        self.areaName = dict["areaName"] as? String ?? ""
    }

    // MARK: - 序列化和反序列化
    private let firstArea_Key = "firstArea"
    private let businessRegNum_Key = "businessRegNum"
    private let thirdArea_Key = "thirdArea"
    private let businessScope_Key = "businessScope"
    private let principalPerson_Key = "principalPerson"
    private let secondArea_Key = "secondArea"
    private let companyName_Key = "companyName"
    private let principalTelephone_Key = "principalTelephone"
    private let businessAddress_Key = "businessAddress"
    private let areaName_Key = "areaName"
    private let documentInfo_Key = "documentInfo"
    // 序列化
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(firstArea, forKey: firstArea_Key)
        aCoder.encodeObject(businessRegNum, forKey: businessRegNum_Key)
        aCoder.encodeObject(thirdArea, forKey: thirdArea_Key)
        aCoder.encodeObject(businessScope, forKey: businessScope_Key)
        aCoder.encodeObject(principalPerson, forKey: principalPerson_Key)
        aCoder.encodeObject(secondArea, forKey: secondArea_Key)
        aCoder.encodeObject(companyName, forKey: companyName_Key)
        aCoder.encodeObject(principalTelephone, forKey: principalTelephone_Key)
        aCoder.encodeObject(businessAddress, forKey: businessAddress_Key)
        aCoder.encodeObject(areaName, forKey: areaName_Key)
        aCoder.encodeObject(documentInfo, forKey: documentInfo_Key)
    }
    
    // 反序列化
    required init?(coder aDecoder: NSCoder) {
        firstArea = aDecoder.decodeObjectForKey(firstArea_Key) as? Int
        businessRegNum =  aDecoder.decodeObjectForKey(businessRegNum_Key) as? String
        thirdArea = aDecoder.decodeObjectForKey(thirdArea_Key) as? Int
        businessScope =  aDecoder.decodeObjectForKey(businessScope_Key) as? String
        principalPerson = aDecoder.decodeObjectForKey(principalPerson_Key) as? String
        secondArea =  aDecoder.decodeObjectForKey(secondArea_Key) as? Int
        companyName = aDecoder.decodeObjectForKey(companyName_Key) as? String
        principalTelephone =  aDecoder.decodeObjectForKey(principalTelephone_Key) as? String
        businessAddress = aDecoder.decodeObjectForKey(businessAddress_Key) as? String
        areaName =  aDecoder.decodeObjectForKey(areaName_Key) as? String
    }
    
    
    /**
     保存所有的分类
     
     - parameter categories: 分类数组
     */
    class func savaShopInfoModel(shopInfoModel: ShopInfoModel)
    {
        let data = NSKeyedArchiver.archivedDataWithRootObject(shopInfoModel)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: ShopInfoModel.ShopInfoModelKey)
    }
    
    /**
     取出本地保存的分类
     
     - returns: 分类数组或者nil
     */
    class func loadLocalShopInfoModel() -> ShopInfoModel?
    {
        if let array = NSUserDefaults.standardUserDefaults().objectForKey(ShopInfoModel.ShopInfoModelKey)
        {
            return NSKeyedUnarchiver.unarchiveObjectWithData(array as! NSData) as? ShopInfoModel
        }
        return nil
    }
    
    
    func getCells() -> Dictionary<Int, [Cell]>{
        return [
            0:[
                Cell(fieldName: "companyName", image: "point", title: "门店名称", value: self.companyName, state: .MULTI_TEXT,maxLength: 50)
            ],
            1:[
                Cell(fieldName: "businessRegNum", image: "point", title: "工商注册号", value: self.businessRegNum, state: .READ,maxLength: 20),
                Cell(fieldName: "principalPerson", image: "point", title: "门店负责人", value: self.principalPerson, state: .TEXT,maxLength: 20),
                Cell(fieldName: "principalTelephone", image: "point", title: "联系电话", value: self.principalTelephone, state: .TEXT,maxLength: 13),
                Cell(fieldName: "areaName", image: "point", title: "所属区域", value: self.areaName, state: .AREA, maxLength: 40),
                Cell(fieldName: "businessAddress", image: "point", title: "门店地址", value: self.businessAddress, state: .MULTI_TEXT, maxLength: 50),
                Cell(fieldName: "documentInfo", image: "point", title: "证件信息", value: self.documentInfo, state: .TEXT, maxLength: 20),
                Cell(fieldName: "businessScope", image: "point", title: "经营范围", value: self.businessScope, state: .MULTI_TEXT, maxLength: 200),
              ]
        ]
    }
}
