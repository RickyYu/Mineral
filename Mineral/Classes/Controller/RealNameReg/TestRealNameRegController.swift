//
//  RealNameRegController.swift
//  Mineral
//
//  Created by Ricky on 2017/3/17.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
import UsefulPickerView
class TestRealNameRegController: BaseViewController{
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfDocumentNum: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfUnit: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var tfNum: UITextField!
    @IBOutlet weak var tfPurpose: UITextField!
    @IBOutlet weak var lbCreType: UILabel!
    //        PASSPROT 护照
    //        ID_CARD  身份证
    //        DRMING_LICENSE 驾照
    var credentialType:String = "ID_CARD"
    var parse:NSXMLParser! = nil
    var dictArea:Dictionary<String,String> = ["1":"1"]
    let singleData = ["护照","身份证", "驾驶证", ]
    var firstArea :String = "330200000000"
    var secondArea :String!
    var thirdArea :String!
    var firstAreaName:String!
    var secondAreaName:String!
    var thirdAreaName:String!
    var secondAreaChoiceName:String = ""
    var thirdAreaChoiceName:String = ""
    var kMaxLength: Int  = 18
    var recordId:Int = -1
    var submitBtn = UIButton()
    override func viewDidLoad() {
        setNavagation("销售实名登记")
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignEdit(_:))))
        tfDocumentNum.keyboardType = UIKeyboardType.NumberPad
        tfDocumentNum.addTarget(self, action: #selector(self.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        submitBtn.setTitle("保存", forState:.Normal)
        submitBtn.backgroundColor = YMGlobalDeapBlueColor()
        submitBtn.setTitleColor(UIColor.greenColor(), forState: .Highlighted) //触摸状态下文字的颜色
        submitBtn.addTarget(self, action: #selector(self.saveInfo), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(submitBtn)
        submitBtn.snp_makeConstraints { make in
            make.bottom.equalTo(self.view.snp_bottom).offset(-30)
            make.left.equalTo(self.view.snp_left).offset(50)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-100, 35))
        }
        if recordId != -1 {
          let item=UIBarButtonItem(title: "删除", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.deleteRecord))
           self.navigationItem.rightBarButtonItem=item
          getData()
        }
        addNotification()
    }
    
    override func resignEdit(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            tfName.resignFirstResponder()
            tfDocumentNum.resignFirstResponder()
            tfAddress.resignFirstResponder()
            tfUnit.resignFirstResponder()
            tfPhone.resignFirstResponder()
            tfProductName.resignFirstResponder()
            tfNum.resignFirstResponder()
            tfPurpose.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    func getData(){
        var parameters = [String : AnyObject]()
        parameters["type"] = "1"
        parameters["sxsRecord.id"] = recordId
        NetworkTool.sharedTools.getRecordInfo(parameters) { (data, error) in
            if error == nil{
                self.tfName.text = data.name
                self.tfDocumentNum.text = data.credentialsCode
                switch data.credentials {
                case "DRMING_LICENSE":
                self.lbCreType.text = "驾照" //被输出
                case "PASSPROT":
                self.lbCreType.text = "护照"
                default:
                   self.lbCreType.text = "身份证"
                }
                self.tfAddress.text = data.address
                self.tfUnit.text = data.companyName
                self.tfPhone.text = data.phone
                self.tfProductName.text = data.productName
                self.tfNum.text = data.productNumber
                self.tfPurpose.text = data.content
            }else{
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }else{
                    self.showHint(error, duration: 2.0, yOffset: 2.0)
                }
            }
        }
    }

    

    
    func saveInfo(){
        
            let strName = tfName.text!
            let strDocumentNum = tfDocumentNum.text!
            let strAddress = tfAddress.text!
            let strUnit = tfUnit.text!
            let strPhone = tfPhone.text!
            let strProductName = tfProductName.text!
            let strNum = tfNum.text!
            let strPurpose = tfPurpose.text!
            
            if AppTools.isEmpty(strName) {
                alert("姓名不可为空!", handler: {
                    self.tfName.becomeFirstResponder()
                })
                return
            }
            if AppTools.isEmpty(strDocumentNum) {
                alert("证件号码不可为空!", handler: {
                    self.tfDocumentNum.becomeFirstResponder()
                })
                return
            }else{
                if strDocumentNum.characters.count < kMaxLength {
                    alert("证件号码填写错误，请重新填写!", handler: {
                        self.tfDocumentNum.becomeFirstResponder()
                    })
                    return
                }
           }
            
        if AppTools.isEmpty(strPhone) {
            alert("联系电话不可为空!", handler: {
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
        
        if AppTools.isEmpty(strProductName) {
            alert("品名不可为空!", handler: {
                self.tfProductName.becomeFirstResponder()
            })
            return
        }
        if AppTools.isEmpty(strNum) {
            alert("数量不可为空!", handler: {
                self.tfNum.becomeFirstResponder()
            })
            return
        }
            var parameters = [String : AnyObject]()
            if recordId != -1 {
            parameters["sxsRecord.id"] = recordId
            }
            parameters["type"] = TYPE_CODE
            parameters["sxsRecord.credentials"] = self.credentialType
            parameters["sxsRecord.credentialsCode"] = strDocumentNum//证件编号
            parameters["sxsRecord.name"] = strName//姓名
            parameters["sxsRecord.address"] = strAddress//住址
            parameters["sxsRecord.companyName"] = strUnit//所在单位
            parameters["sxsRecord.phone"] = strPhone//联系电话
            parameters["sxsRecord.productName"] = strProductName//品名
            parameters["sxsRecord.productNumber"] = strNum//松香水的数量(升)
            parameters["sxsRecord.content"] = strPurpose//用途
 
            
            NetworkTool.sharedTools.saveInfo(parameters) { (login, error) in
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


    @IBAction func choiceCreType(sender: AnyObject) {
        UsefulPickerView.showSingleColPicker("请选择", data: singleData, defaultSelectedIndex: 1) {[unowned self] (selectedIndex, selectedValue) in
            if selectedValue == "护照"{
            self.kMaxLength = 7
                self.credentialType = "PASSPROT"
            }else if selectedValue == "身份证"{
            self.credentialType = "ID_CARD"
            }else{
            self.credentialType = "DRMING_LICENSE"
            }
            
            self.lbCreType.text = selectedValue
            
        }
    }
    

    var areaArr = [String]()
    // 监听解析节点的属性，后续要改，登陆时只解析一次即可
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        
        let code = attributeDict["code"]!as String
        let name = attributeDict["name"]! as String
        dictArea[code] = name
        dictArea[name] = code
    }
    
    func deleteRecord(){
        var parameters = [String : AnyObject]()
        parameters["sxsRecord.id"] = String(recordId)
        parameters["type"] = "1"
        NetworkTool.sharedTools.deleteSaleRecord(parameters) { (data, error) in
            if error == nil{
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
    
}