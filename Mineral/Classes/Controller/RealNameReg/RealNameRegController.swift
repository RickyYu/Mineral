//
//  TestController.swift
//  Mineral
//
//  Created by Ricky on 2017/3/23.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
import UsefulPickerView
private let ReuseIdentifier = "ShopInfoCell"
class RealNameRegController: BaseViewController, UITableViewDelegate, UITableViewDataSource,ParameterDelegate {
    
    var cells: Dictionary<Int, [Cell]>? = [:]
    var saleRecordModel:SaleRecordModel!
    var customTableView:UITableView!
     let indexPaths: [NSIndexPath] = []
       var submitBtn = UIButton()
    var kMaxLength: Int  = 18
    var recordId:Int = -1
    //        PASSPROT 护照
    //        ID_CARD  身份证
    //        DRMING_LICENSE 驾照
    var credentialType:String = "ID_CARD"
     let singleData = ["护照","身份证", "驾驶证", ]
    override func viewDidLoad() {
         setNavagation("销售实名登记")
        self.view.backgroundColor = UIColor.whiteColor()
        customTableView = getTableView()
        self.view.addSubview(customTableView)
        self.saleRecordModel = SaleRecordModel(credentialsName: "身份证")
        self.cells = saleRecordModel.getCells()
        self.customTableView.reloadData()
        
        submitBtn.setTitle("删除", forState:.Normal)
        submitBtn.backgroundColor = UIColor.redColor()
        submitBtn.setTitleColor(UIColor.greenColor(), forState: .Highlighted) //触摸状态下文字的颜色
        submitBtn.addTarget(self, action: #selector(self.deleteRecord), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(submitBtn)
        submitBtn.snp_makeConstraints { make in
            make.bottom.equalTo(self.view.snp_bottom).offset(-30)
            make.left.equalTo(self.view.snp_left).offset(50)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-100, 35))
        }
        
        if recordId != -1 {
            let item=UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.saveInfo))
            self.navigationItem.rightBarButtonItem=item
            getData()
        }
    }
    
    func getData(){
        var parameters = [String : AnyObject]()
        parameters["type"] = TYPE_CODE
        parameters["sxsRecord.id"] = recordId
        NetworkTool.sharedTools.getRecordInfo(parameters) { (data, error) in
            if error == nil{
                self.saleRecordModel = data
                self.cells = self.saleRecordModel.getCells()
                self.customTableView.reloadData()
                }else{
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }else{
                    self.showHint(error, duration: 2.0, yOffset: 2.0)
                }
            }
        }
    }
    
    func deleteRecord(){
        var parameters = [String : AnyObject]()
        parameters["sxsRecord.id"] = String(recordId)
        parameters["type"] = TYPE_CODE
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
    
    func passParams(text: String,key:String,indexPaths: [NSIndexPath]) {
        saleRecordModel.setValue(text, forKey: key)
        self.cells = self.saleRecordModel.getCells()
        self.customTableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
    }
    
    override func viewWillAppear(animated: Bool) {
        if (customTableView.indexPathForSelectedRow != nil) {
            customTableView.deselectRowAtIndexPath(customTableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    //返回几节(组)
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (self.cells?.count)!
    }
    
    //返回表格行数（也就是返回控件数）
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = self.cells?[section]
        return data!.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ReuseIdentifier, forIndexPath: indexPath) as! ShopInfoCell
        let secno = indexPath.section
        let _cell = self.cells![secno]![indexPath.row]
        cell.model = _cell
        return cell
    }
    
    //设置头部标题
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    //设置头部标题高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 8
        }
        return 0
    }
    
    //设置行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = self.cells![indexPath.section]![indexPath.row]
        switch cell.state {
        case CellState.READ:
            break
        case .AREA: break
        case .ENUM:
            choiceCreType([indexPath])
            
        case .TEXT:
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("BaseEditTextController") as! BaseEditTextController
            controller.indexPaths = [indexPath]
            controller.cell = cell
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        case .MULTI_TEXT:
            self.showHint("test", duration: 1, yOffset: 1)
        }
    }
    
    
    func choiceCreType(indexPaths: [NSIndexPath]){
        UsefulPickerView.showSingleColPicker("请选择", data: singleData, defaultSelectedIndex: 1) {[unowned self] (selectedIndex, selectedValue) in
            if selectedValue == "护照"{
                self.kMaxLength = 7
                self.credentialType = "PASSPROT"
            }else if selectedValue == "身份证"{
                self.credentialType = "ID_CARD"
            }else{
                self.credentialType = "DRMING_LICENSE"
            }
            
            self.saleRecordModel.credentials = self.credentialType
            switch self.credentialType {
            case "DRMING_LICENSE":
                self.saleRecordModel.credentialsName = "驾照" //被输出
            case "PASSPROT":
                self.saleRecordModel.credentialsName = "护照"
            default:
                self.saleRecordModel.credentialsName = "身份证"
            }
            self.cells = self.saleRecordModel.getCells()
            self.customTableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
            
        }
    
    }

    
    /**
     *  创建UITableView
     */
    func getTableView() -> UITableView{
        
        if customTableView == nil{
            customTableView = UITableView(frame: CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT), style: UITableViewStyle.Plain)
            let nib = UINib(nibName: ReuseIdentifier,bundle: nil)
            self.customTableView.registerNib(nib, forCellReuseIdentifier: ReuseIdentifier)
            customTableView?.delegate = self
            customTableView?.dataSource = self
            customTableView?.showsHorizontalScrollIndicator = false
            customTableView?.showsVerticalScrollIndicator = false
            customTableView?.tableFooterView = UIView()
            
        }
        
        return customTableView!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func saveInfo(){
        let strName = saleRecordModel.name
        let strDocumentNum = saleRecordModel.credentialsCode
        let strAddress = saleRecordModel.address
        let strUnit = saleRecordModel.companyName
        let strPhone = saleRecordModel.phone
        let strProductName = saleRecordModel.productName
        let strNum = saleRecordModel.productNumber
        let strPurpose = saleRecordModel.content

        if AppTools.isEmpty(strName) {
            alert("姓名不可为空!", handler: {
               // self.tfName.becomeFirstResponder()
            })
            return
        }
        if AppTools.isEmpty(strDocumentNum) {
            alert("证件号码不可为空!", handler: {
                //self.tfDocumentNum.becomeFirstResponder()
            })
            return
        }else{
            if strDocumentNum.characters.count < kMaxLength {
                alert("证件号码填写错误，请重新填写!", handler: {
                   // self.tfDocumentNum.becomeFirstResponder()
                })
                return
            }
        }
        
        if AppTools.isEmpty(strPhone) {
            alert("联系电话不可为空!", handler: {
                //self.tfPhone.becomeFirstResponder()
            })
            return
        }
        
        
        if !ValidateEnum.phoneNum(strPhone).isRight {
            alert("电话格式错误，请重新输入!", handler: {
                //self.tfPhone.becomeFirstResponder()
            })
            return
        }
        
        if AppTools.isEmpty(strProductName) {
            alert("品名不可为空!", handler: {
               // self.tfProductName.becomeFirstResponder()
            })
            return
        }
        if AppTools.isEmpty(strNum) {
            alert("数量不可为空!", handler: {
                //self.tfNum.becomeFirstResponder()
            })
            return
        }
        var parameters = [String : AnyObject]()
        if recordId != -1 {
            parameters["sxsRecord.id"] = recordId
        }
        parameters["type"] = TYPE_CODE
        parameters["sxsRecord.credentials"] = saleRecordModel.credentials
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
    

}
