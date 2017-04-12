//
//  PwdSettingModel.swift
//  Mineral
//
//  Created by Ricky on 2017/4/10.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

class PwdSettingModel:BaseModel{
    var oldPwd:String!
    var newPwd:String!
    var rNewPwd:String!
    override init() {
        super.init()
        self.oldPwd = ""
        self.newPwd = ""
        self.rNewPwd = ""
    }
    func getCells() -> Dictionary<Int,[Cell]>{
        return[
            0:[
                Cell(fieldName: "oldPwd", image: "point", title: "旧密码", value: self.oldPwd, state: .TEXT,maxLength: 20)
            ],
            1:[
                Cell(fieldName: "newPwd", image: "point", title: "新密码", value: self.newPwd, state: .TEXT,maxLength: 20)
            ],
            2:[
                Cell(fieldName: "rNewPwd", image: "point", title: "再次输入新密码", value: self.rNewPwd, state: .TEXT,maxLength: 20)
            ]
        ]
    }
}