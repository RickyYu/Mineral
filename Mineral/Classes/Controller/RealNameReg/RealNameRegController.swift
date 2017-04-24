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
class RealNameRegController: BaseViewController, UITableViewDelegate, UITableViewDataSource,ParameterDelegate,MultiParameterDelegate {
    
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
        customTableView = getTableView()
        self.view.addSubview(customTableView)
        if saleRecordModel == nil {
            self.saleRecordModel = SaleRecordModel(credentialsName: "身份证")
        }
        
        if saleRecordModel.id != -1 {  //从销售记录进入
            
            if saleRecordModel.isOperate == "1" { // 可保存可删除
                let item=UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.saveInfo))
                self.navigationItem.rightBarButtonItem=item
                
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
                self.cells = saleRecordModel.getCells()
            }else {
                self.cells = saleRecordModel.getReadCells()
            }

            switchCode(saleRecordModel.credentials)
            self.customTableView.reloadData()
        }else { //可保存
            let item=UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.saveInfo))
            self.navigationItem.rightBarButtonItem=item
            self.cells = saleRecordModel.getNoPayTimeCells()
            self.customTableView.reloadData()
        }
    }
    
    func switchCode(credentials:String){
        switch credentials {
        case "DRIVING_LICENSE":
            self.saleRecordModel.credentialsName = "驾驶证" //被输出
            self.startIndex = 2
        case "PASSPORT":
            self.saleRecordModel.credentialsName = "护照"
            self.startIndex = 0
        default:
            self.saleRecordModel.credentialsName = "身份证"
            self.startIndex = 1
        }
    }
    
    func deleteRecord(){
        self.alertNotice("提示", message: "是否删除？") {
            var parameters = [String : AnyObject]()
            parameters["sxsRecord.id"] = String(self.recordId)
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
        
    }
    
    func passParams(text: String,key:String,indexPaths: [NSIndexPath]) {
        saleRecordModel.setValue(text, forKey: key)
        if saleRecordModel.id != -1 {
            self.cells = self.saleRecordModel.getCells()
        }else{
            self.cells = saleRecordModel.getNoPayTimeCells()
        }
        self.customTableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
    }
    
    override func viewWillAppear(animated: Bool) {
        if (customTableView.indexPathForSelectedRow != nil) {
            customTableView.deselectRowAtIndexPath(customTableView.indexPathForSelectedRow!, animated: true)
        }
//        self.navigationController?.navigationBar
//            .setBackgroundImage(UIImage(named: "head_transparent"), forBarMetrics: .Default)
//        //设置navigationBar  黑线背景
//        self.navigationController?.navigationBar.shadowImage = UIImage(named: "head_transparent")
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
        if (customTableView.indexPathForSelectedRow != nil) {
            customTableView.deselectRowAtIndexPath(customTableView.indexPathForSelectedRow!, animated: true)
        }
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
            controller.cardNum = self.startIndex
            self.navigationController?.pushViewController(controller, animated: true)
        case .MULTI_TEXT:
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("BaseMultiTextController") as! BaseMultiTextController
            controller.indexPaths = [indexPath]
            controller.cell = cell
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    var startIndex:Int = 1  // 0 护照  1：身份证  2：驾驶证
    func choiceCreType(indexPaths: [NSIndexPath]){
        UsefulPickerView.showSingleColPicker("请选择", data: singleData, defaultSelectedIndex: startIndex) {[unowned self] (selectedIndex, selectedValue) in
            if selectedValue == "护照"{
                self.credentialType = "PASSPORT"
                self.startIndex = 0
            }else if selectedValue == "身份证"{
                self.credentialType = "ID_CARD"
                self.startIndex = 1
            }else{
                self.credentialType = "DRIVING_LICENSE"
                self.startIndex = 2
            }
            
             self.saleRecordModel.credentials = self.credentialType
              self.switchCode(self.saleRecordModel.credentials)
            if self.saleRecordModel.id != -1 {
                self.cells = self.saleRecordModel.getCells()
            }else{
                self.cells = self.saleRecordModel.getNoPayTimeCells()
            }
            self.customTableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
            
        }
    
    }

    
    /**
     *  创建UITableView
     */
    func getTableView() -> UITableView{
        
        if customTableView == nil{
            customTableView = UITableView(frame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT), style: UITableViewStyle.Plain)
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
        }
        
        //护照
        if startIndex == 0 {
            if strDocumentNum.characters.count>9 || strDocumentNum.characters.count<7   {
                alert("护照长度为7-9位，请正确填写！")
                return
            }
        }else {//身份证，驾照
            if !ValidateEnum.cardNum(strDocumentNum).isRight {
                alert("证件号码格式错误，请重新输入!", handler: {
                    
                })
                return
            }
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
        if saleRecordModel.id != -1 {
            parameters["sxsRecord.id"] = saleRecordModel.id
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
        if saleRecordModel.payTime != "" {
          parameters["sxsRecord.payTime"] = saleRecordModel.payTime//用途
        }
        
        
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
