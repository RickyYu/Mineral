//
//  StoreInfoController.swift
//  Mineral
//
//  Created by Ricky on 2017/3/17.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
class TestShopInfoController: BaseViewController,NSXMLParserDelegate  {
    
    @IBOutlet weak var tfShopName: UITextField!
    @IBOutlet weak var tfBusinessRegNum: UITextField!
    @IBOutlet weak var tfDelegate: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfAdress: UITextField!
    @IBOutlet weak var tfDocumentInfo: UITextField!
    @IBOutlet weak var tfBusinessScope: UITextField!
    @IBOutlet weak var lbAreaName: UILabel!
    var parse:NSXMLParser! = nil
    var dictArea:Dictionary<String,String> = ["1":"1"]
    var firstArea :String = "330200000000"
    var secondArea :String!
    var thirdArea :String!
    var firstAreaName:String!
    var secondAreaName:String!
    var thirdAreaName:String!
    var secondAreaChoiceName:String = ""
    var thirdAreaChoiceName:String = ""
    override func viewDidLoad() {
       setNavagation("门店基本信息")
      self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignEdit(_:))))
        let item=UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.updateInfo))
        self.navigationItem.rightBarButtonItem=item
        
//        initAreaTest()
        
        parse = NSXMLParser(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("nbyhpc_area", ofType: "xml")!))!
        parse.delegate = self
        
        
        getData()
        addNotification()
    }

    
    override func resignEdit(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
             tfShopName.resignFirstResponder()
             tfBusinessRegNum.resignFirstResponder()
             tfDelegate.resignFirstResponder()
             tfPhone.resignFirstResponder()
             tfAdress.resignFirstResponder()
             tfDocumentInfo.resignFirstResponder()
             tfBusinessScope.resignFirstResponder()
             lbAreaName.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    func getData(){
        let parameters = [String : AnyObject]()
        
        
        NetworkTool.sharedTools.getCompanyInfo(parameters) { (data, error) in
            if error == nil{
                if data != nil{
                self.tfShopName.text = data.companyName
                self.tfBusinessRegNum.text = data.businessRegNum
                self.tfDelegate.text = data.principalPerson
                self.tfPhone.text = data.principalTelephone
                self.tfAdress.text = data.businessAddress
                self.tfDocumentInfo.text = data.documentInfo
                self.tfBusinessScope.text = data.businessScope
                self.firstArea = String(data.firstArea)
                self.secondArea = String(data.secondArea)
                self.thirdArea = String(data.thirdArea)
                    // 开始解析
                self.parse.parse()
                self.lbAreaName.text = data.areaName
                }
            }else{
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }else{
                    self.showHint(error, duration: 2.0, yOffset: 2.0)
                }
            }
        }
    }
    
    func back(){
        self.lastNavigationPage()
    }

    @IBAction func areaChoice(sender: AnyObject) {
        getChoiceArea(areaArr) { (area,areaArr) in
        self.secondAreaChoiceName = areaArr[1]
        self.thirdAreaChoiceName = areaArr[2]
         self.lbAreaName.text =  area
         self.secondArea = self.dictArea[self.secondAreaChoiceName]
         self.thirdArea = self.dictArea[self.thirdAreaChoiceName]
        }
    }


    func updateInfo(sender: UIButton) {
        let strShopName = tfShopName.text!
        let strBusinessRegNum = tfBusinessRegNum.text!
        let strDelegate = tfDelegate.text!
        let strPhone = tfPhone.text!
        let strAdress = tfAdress.text!
        let strDocumentInfo = tfDocumentInfo.text!
        let strBusinessScope = tfBusinessScope.text!
        
        
        if AppTools.isEmpty(strShopName) {
            alert("门店名称不可为空!", handler: {
                self.tfShopName.becomeFirstResponder()
            })
            return
        }
        if AppTools.isEmpty(strBusinessRegNum) {
            alert("工商注册号不可为空!", handler: {
                self.tfBusinessRegNum.becomeFirstResponder()
            })
            return
        }
        
        if AppTools.isEmpty(strDelegate) {
            alert("门店负责人不可为空!", handler: {
                self.tfDelegate.becomeFirstResponder()
            })
            return
        }
        if AppTools.isEmpty(strPhone) {
            alert("联系方式不可为空!", handler: {
                self.tfPhone.becomeFirstResponder()
            })
            return
        }
        
        if !ValidateEnum.phoneNum(strPhone).isRight {
            alert("电话格式错误，请重新输入!", handler: {
                self.tfPhone.becomeFirstResponder()
            })
            return
          }
        
        
        if AppTools.isEmpty(strAdress) {
            alert("门店地址不可为空!", handler: {
                self.tfAdress.becomeFirstResponder()
            })
            return
        }
        if AppTools.isEmpty(strDocumentInfo) {
            alert("证件信息不可为空!", handler: {
                self.tfDocumentInfo.becomeFirstResponder()
            })
            return
        }
        
        if AppTools.isEmpty(strBusinessScope) {
            alert("经营范围不可为空!", handler: {
                self.tfBusinessScope.becomeFirstResponder()
            })
            return
        }
        
        var parameters = [String : AnyObject]()
        parameters["companyName"] = strShopName
        parameters["businessRegNum"] = strBusinessRegNum
        parameters["principalPerson"] = strDelegate
        parameters["principalTelephone"] = strPhone
        parameters["firstArea"] = firstArea
        parameters["secondArea"] = secondArea
        parameters["thirdArea"] = thirdArea
        parameters["businessAddress"] = strAdress
        parameters["documentInfo"] = strDocumentInfo
        parameters["businessScope"] = strBusinessScope
        
        NetworkTool.sharedTools.updateCpyInfo(parameters) { (login, error) in
            if error == nil{
                self.showHint("保存成功！", duration: 2.0, yOffset: 2.0)
                self.lastNavigationPage()
            }else{
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }else{
                    self.showHint(error, duration: 2.0, yOffset: 2.0)
                }
            }
        }
    }
    var areaArr = [String]()
    // 监听解析节点的属性
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){

        let code = attributeDict["code"]!as String
        let name = attributeDict["name"]! as String

        dictArea[code] = name
        dictArea[name] = code
        if attributeDict["code"]! == firstArea{
            firstAreaName = attributeDict["name"]! as String
            areaArr.append(firstAreaName)
        }
        if attributeDict["code"]! == secondArea{
            secondAreaName = attributeDict["name"]! as String
            areaArr.append(secondAreaName)
        }
        if attributeDict["code"]! == thirdArea{
            thirdAreaName = attributeDict["name"]! as String
            areaArr.append(thirdAreaName)
        }
        
    }

}
