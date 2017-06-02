//
//  SaleRecordModel.swift
//  Mineral
//
//  Created by Ricky on 2017/3/22.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

class SaleRecordModel:BaseModel{
    var credentials:String!
    var credentialsName:String!
    var credentialsCode:String!
    var name:String!
    var address:String!
    var companyName :String!
    var companyPerson:String!
    var phone:String!
    var productName:String!
    var productNumber:String!
    var content:String!
    var payTime:String!
    var id:Int!
     var isOperate:String!
    override init() {
        super.init()
    }
    
    init(credentialsName:String) {
        super.init()
        self.credentials = ""
        self.credentialsName = credentialsName
        self.credentialsCode = ""
        self.name = ""
        self.address = ""
        self.companyName =  ""
        self.companyPerson = ""
        self.phone = ""
        self.productName = "松香水"
        self.productNumber = ""
        self.content = ""
        self.payTime =  ""
        self.id = -1
    }
    
    init(dict: [String: AnyObject]) {
        super.init()
        self.credentials = dict["credentials"] as? String ?? ""
        self.credentialsCode = dict["credentialsCode"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.address = dict["address"] as? String ?? ""
        self.companyName = dict["companyName"] as? String ?? ""
        self.companyPerson = dict["companyPerson"] as? String ?? ""
        self.phone = dict["phone"] as? String ?? ""
        self.productName = dict["productName"] as? String ?? ""
        self.productNumber = dict["productNumber"] as? String ?? ""
        self.content = dict["content"] as? String ?? ""
        self.payTime = dict["payTime"] as? String ?? ""
        self.id = dict["id"] as? Int
        switch credentials {
        case "DRIVING_LICENSE":
            self.credentialsName = "驾照" //被输出
        case "PASSPORT":
            self.credentialsName = "护照"
        default:
            self.credentialsName = "身份证"
        }
          self.isOperate = dict["isOperate"] as? String ?? ""
    }
    
    
    func getNoPayTimeCells() -> Dictionary<Int, [Cell]>{
        return [
            0:[
                Cell(fieldName: "name", image: "point", title: "姓  名", value: self.name, state: .TEXT,maxLength: 20)
            ],
            1:[
                Cell(fieldName: "credentials", image: "point", title: "证件类型", value: self.credentialsName, state: .ENUM,maxLength: 20),
                Cell(fieldName: "credentialsCode", image: "point", title: "证件号码", value: self.credentialsCode, state: .TEXT,maxLength: 18),
                Cell(fieldName: "phone", image: "point", title: "联系电话", value: self.phone, state: .TEXT, maxLength: 13),
                Cell(fieldName: "productName", image: "point", title: "品  名", value: self.productName, state: .TEXT, maxLength: 20),
                Cell(fieldName: "productNumber", image: "point", title: "数量(升)", value: self.productNumber, state: .TEXT, maxLength: 6),
                Cell(fieldName: "address", image: "point", title: "现 住 址", value: self.address, state: .MULTI_TEXT,maxLength: 50,placeHolder: "选填"),
                Cell(fieldName: "companyName", image: "point", title: "所在单位", value: self.companyName, state: .TEXT, maxLength: 40,placeHolder: "选填"),
                 Cell(fieldName: "companyPerson", image: "point", title: "经 办 人", value: self.companyPerson, state: .TEXT, maxLength: 40,placeHolder: "选填"),
                Cell(fieldName: "content", image: "point", title: "用  途", value: self.content, state: .MULTI_TEXT, maxLength: 50,placeHolder: "选填")
           ]
        ]
    }
    
    func getCells() -> Dictionary<Int, [Cell]>{
        return [
            0:[
                Cell(fieldName: "name", image: "point", title: "姓  名", value: self.name, state: .TEXT,maxLength: 20)
            ],
            1:[
                Cell(fieldName: "credentials", image: "point", title: "证件类型", value: self.credentialsName, state: .ENUM,maxLength: 20),
                Cell(fieldName: "credentialsCode", image: "point", title: "证件号码", value: self.credentialsCode, state: .TEXT,maxLength: 18),
                Cell(fieldName: "phone", image: "point", title: "联系电话", value: self.phone, state: .TEXT, maxLength: 13),
                 Cell(fieldName: "productName", image: "point", title: "品  名", value: self.productName, state: .TEXT, maxLength: 20),
                Cell(fieldName: "productNumber", image: "point", title: "数量(升)", value: self.productNumber, state: .TEXT, maxLength: 6),
                Cell(fieldName: "address", image: "point", title:"现 住 址", value: self.address, state: .MULTI_TEXT,maxLength: 50,placeHolder: "选填"),
                Cell(fieldName: "companyName", image: "point", title: "所在单位", value: self.companyName, state: .TEXT, maxLength: 40,placeHolder: "选填"),
                  Cell(fieldName: "companyPerson", image: "point", title: "经 办 人", value: self.companyPerson, state: .TEXT, maxLength: 40,placeHolder: "选填"),
                Cell(fieldName: "content", image: "point", title: "用  途", value: self.content, state: .MULTI_TEXT, maxLength: 50,placeHolder: "选填"),
                Cell(fieldName: "payTime", image: "point", title: "购买时间", value: self.payTime, state: .READ, maxLength: 50,placeHolder: "选填")
            ]
        ]
    }
    

    func getReadCells() -> Dictionary<Int, [Cell]>{
        return [
            0:[
                Cell(fieldName: "name", image: "point", title: "姓  名", value: self.name, state: .READ,maxLength: 20)
            ],
            1:[
                Cell(fieldName: "credentials", image: "point", title: "证件类型", value: self.credentialsName, state: .READ,maxLength: 20),
                Cell(fieldName: "credentialsCode", image: "point", title: "证件号码", value: self.credentialsCode, state: .READ,maxLength: 18),
                Cell(fieldName: "phone", image: "point", title: "联系电话", value: self.phone, state: .READ, maxLength: 13),
                Cell(fieldName: "productName", image: "point", title: "品  名", value: self.productName, state: .READ, maxLength: 20),
                Cell(fieldName: "productNumber", image: "point", title: "数量(升)", value: self.productNumber, state: .READ, maxLength: 6),
                Cell(fieldName: "address", image: "point", title:"现 住 址", value: self.address, state: .READ,maxLength: 50,placeHolder: "选填"),
                Cell(fieldName: "companyName", image: "point", title: "所在单位", value: self.companyName, state: .READ, maxLength: 40,placeHolder: "选填"),
                  Cell(fieldName: "companyPerson", image: "point", title: "经 办 人", value: self.companyPerson, state: .TEXT, maxLength: 40,placeHolder: "选填"),
                Cell(fieldName: "content", image: "point", title: "用  途", value: self.content, state: .READ, maxLength: 50,placeHolder: "选填"),
                Cell(fieldName: "payTime", image: "point", title: "购买时间", value: self.payTime, state: .READ, maxLength: 50,placeHolder: "选填")
            ]
        ]
    }
    
}
