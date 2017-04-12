//
//  SalesCountModel.swift
//  Mineral
//
//  Created by Ricky on 2017/4/11.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//


class SalesCountModel:BaseModel,NSCoding{
    var num:Int!
    var dataType:String!

    init(dict: [String: AnyObject]) {
        super.init()
        self.num = dict["NUM"] as? Int ?? 0
        self.dataType = dict["DATATYPE"] as? String ?? ""
//        setValuesForKeysWithDictionary(dict)
    }
    
    // MARK: - 序列化和反序列化
    private let num_Key = "num"
    private let dataType_Key = "dataType"
    // 序列化
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(num, forKey: num_Key)
        aCoder.encodeObject(dataType, forKey: dataType_Key)

    }
    
    // 反序列化
    required init?(coder aDecoder: NSCoder) {
        num = aDecoder.decodeObjectForKey(num_Key) as? Int
        dataType =  aDecoder.decodeObjectForKey(dataType_Key) as? String
    }
    
    // MARK: - 保存和获取所有分类
    static let SalesCountModelKey = "SalesCountModelKey"
    
    /**
     保存所有的分类
     
     - parameter categories: 分类数组
     */
    class func savaSalesCountModels(salesCountModel: [SalesCountModel])
    {
        let data = NSKeyedArchiver.archivedDataWithRootObject(salesCountModel)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: SalesCountModel.SalesCountModelKey)
    }
    
    /**
     取出本地保存的分类
     
     - returns: 分类数组或者nil
     */
    class func loadLocalSalesCountModels() -> [SalesCountModel]?
    {
        if let array = NSUserDefaults.standardUserDefaults().objectForKey(SalesCountModel.SalesCountModelKey)
        {
            return NSKeyedUnarchiver.unarchiveObjectWithData(array as! NSData) as? [SalesCountModel]
        }
        return nil
    }

}
