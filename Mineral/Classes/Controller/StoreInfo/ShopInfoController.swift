//
//  TestShopInfoController.swift
//  Mineral
//
//  Created by Ricky on 2017/3/29.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
private let ReuseIdentifier = "ShopInfoCell"
class ShopInfoController: BaseViewController, UITableViewDelegate, UITableViewDataSource,NSXMLParserDelegate,ParameterDelegate,MultiParameterDelegate{
    
    var cells: Dictionary<Int, [Cell]>? = [:]
    var shopInfoModel: ShopInfoModel! = nil
    var customTableView:UITableView!
    var parse:NSXMLParser! = nil
    var dictArea:Dictionary<String,String> = ["1":"1"]
    var firstArea :String = "330200000000"
    var secondArea :String = ""
    var thirdArea :String = ""
    var firstAreaName:String!
    var secondAreaName:String!
    var thirdAreaName:String!
    var secondAreaChoiceName:String = ""
    var thirdAreaChoiceName:String = ""
    let indexPaths: [NSIndexPath] = []
    var isSave:Bool = false  //第一次进入该页面才有保存，之后都无法保存
    override func viewDidLoad() {
        setNavagation("门店基本信息")

         let item = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.updateInfo))
         self.navigationItem.rightBarButtonItem=item

        self.shopInfoModel = ShopInfoModel(firstArea: 0)
        customTableView = getTableView()
        self.view.addSubview(customTableView)
        self.cells = shopInfoModel.getCells()
        self.customTableView.reloadData()

        //cell 去除Value
        //获取后，再赋值给它
        parse = NSXMLParser(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("nbyhpc_area", ofType: "xml")!))!
        parse.delegate = self
        //parse.parse()
        getData()
    }

    
    func passParams(text: String,key:String,indexPaths: [NSIndexPath]) {
        shopInfoModel.setValue(text, forKey: key)
        self.cells = self.shopInfoModel.getCells()
        self.customTableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
    }
    
    override func viewWillAppear(animated: Bool) {
        if (customTableView.indexPathForSelectedRow != nil) {
            customTableView.deselectRowAtIndexPath(customTableView.indexPathForSelectedRow!, animated: true)
        }
        self.navigationController?.navigationBar
                       .setBackgroundImage(UIImage(named: "set_head"), forBarMetrics: .Default)

    }
    
 
    
    func getData(){
        let parameters = [String : AnyObject]()
        NetworkTool.sharedTools.getCompanyInfo(parameters) { (data, error) in
            if error == nil{
                if data != nil{
                    self.setData(data)
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
    
    func setData(data : ShopInfoModel!){
        self.shopInfoModel = data
        self.secondArea = String(self.shopInfoModel.secondArea)
        self.thirdArea = String(self.shopInfoModel.thirdArea)
        self.parse.parse()
        self.shopInfoModel.areaName = combinedString ?? data.areaName
        self.cells = self.shopInfoModel.getCells()
        self.customTableView.reloadData()
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
        customTableView.deselectRowAtIndexPath(customTableView.indexPathForSelectedRow!, animated: true)
        switch cell.state {
        case CellState.READ:
            break
        case .AREA:
            choiceArea([indexPath])
        case .ENUM:
            self.showHint("test", duration: 1, yOffset: 1)
        case .TEXT:
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("BaseEditTextController") as! BaseEditTextController
            controller.indexPaths = [indexPath]
            controller.cell = cell
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        case .MULTI_TEXT:
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("BaseMultiTextController") as! BaseMultiTextController
            controller.indexPaths = [indexPath]
            controller.cell = cell
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func choiceArea(indexPath: [NSIndexPath]){
       if areaArr.count == 2 { areaArr.append(" ")}
        getChoiceArea(areaArr) { (area,areaArr) in
            self.secondAreaChoiceName = areaArr[1]
            self.thirdAreaChoiceName = areaArr[2]
            self.shopInfoModel.areaName = area
            self.cells = self.shopInfoModel.getCells()
            self.customTableView.reloadRowsAtIndexPaths(indexPath, withRowAnimation: .None)
            self.secondArea = self.dictArea[self.secondAreaChoiceName] ?? ""
            self.thirdArea = self.dictArea[self.thirdAreaChoiceName] ?? ""
         
            self.areaArr.removeAll()
            self.areaArr.append("宁波市")
            self.areaArr.append(self.secondAreaChoiceName)
            self.areaArr.append(self.thirdAreaChoiceName)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    var areaArr = [String]()
    var combinedString : String = ""
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
      
        combinedString = areaArr.reduce("", combine: { (result, value) -> String in
            result + " " + value
        })
        
    }
    
    func updateInfo(sender: UIButton) {
        
        let strShopName = shopInfoModel.companyName
        let strBusinessRegNum = shopInfoModel.businessRegNum
        let strDelegate = shopInfoModel.principalPerson
        let strPhone = shopInfoModel.principalTelephone
        let strAdress = shopInfoModel.businessAddress
        let strDocumentInfo = shopInfoModel.documentInfo
        let strBusinessScope = shopInfoModel.businessScope
        
        
        if AppTools.isEmpty(strShopName) {
            alert("门店名称不可为空!", handler: {
               // self.tfShopName.becomeFirstResponder()
            })
            return
        }
        if AppTools.isEmpty(strBusinessRegNum) {
            alert("工商注册号不可为空!", handler: {
              //  self.tfBusinessRegNum.becomeFirstResponder()
            })
            return
        }
        
        if AppTools.isEmpty(strDelegate) {
            alert("门店负责人不可为空!", handler: {
              //  self.tfDelegate.becomeFirstResponder()
            })
            return
        }
        if AppTools.isEmpty(strPhone) {
            alert("联系方式不可为空!", handler: {
              ///  self.tfPhone.becomeFirstResponder()
            })
            return
        }
        
        if !ValidateEnum.phoneNum(strPhone).isRight {
            alert("电话格式错误，请重新输入!", handler: {
               // self.tfPhone.becomeFirstResponder()
            })
            return
        }
        
        
        if AppTools.isEmpty(strAdress) {
            alert("门店地址不可为空!", handler: {
              //  self.tfAdress.becomeFirstResponder()
            })
            return
        }
        if AppTools.isEmpty(strDocumentInfo) {
            alert("证件信息不可为空!", handler: {
              //  self.tfDocumentInfo.becomeFirstResponder()
            })
            return
        }
        
        if AppTools.isEmpty(strBusinessScope) {
            alert("经营范围不可为空!", handler: {
             //   self.tfBusinessScope.becomeFirstResponder()
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
                self.showHint("保存成功！", duration: 1.0, yOffset: 1.0)
//                self.navigationController?.pushViewController(MainController(), animated: false)
                let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainController") as! MainController
                let  navMainController = UINavigationController(rootViewController:controller)
                self.presentViewController(navMainController, animated: true, completion: nil)
//                self.lastNavigationPage()
            }else{
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }else{
                    self.showHint(error, duration: 1.0, yOffset:1.0)
                }
            }
        }
    }
    
}
