//
//  PwdSettingController.swift
//  Mineral
//
//  Created by Ricky on 2017/4/10.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
import UsefulPickerView
private let ReuseIdentifier = "ShopInfoCell"

class PwdSettingController: BaseViewController,UITableViewDelegate, UITableViewDataSource,ParameterDelegate  {
    var customTableView:UITableView!
     var pwdSettingModel = PwdSettingModel()
    let indexPaths: [NSIndexPath] = []
    var submitBtn = UIButton()
    var cells: Dictionary<Int, [Cell]>? = [:]
    override func viewDidLoad() {
        setNavagation("修改密码")
        customTableView = getTableView()
        self.view.addSubview(customTableView)
        self.cells = pwdSettingModel.getCells()
        self.customTableView.reloadData()
        self.navigationController?.navigationBar
            .setBackgroundImage(UIImage(named: "set_head"), forBarMetrics: .Default)
        submitBtn.setTitle("保存", forState:.Normal)
        submitBtn.backgroundColor = YMGlobalDeapBlueColor()
        submitBtn.setTitleColor(UIColor.greenColor(), forState: .Highlighted) //触摸状态下文字的颜色
        submitBtn.addTarget(self, action: #selector(self.updatePwd), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(submitBtn)
        submitBtn.snp_makeConstraints { make in
            make.bottom.equalTo(self.view.snp_bottom).offset(-30)
            make.left.equalTo(self.view.snp_left).offset(50)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-100, 35))
        }

    }
    
    var oldPwd:String!
    var newPwd:String!
    var rnewPwd:String!
    
    func updatePwd(){
        oldPwd = pwdSettingModel.oldPwd
        newPwd = pwdSettingModel.newPwd
        rnewPwd = pwdSettingModel.rNewPwd
        
        if AppTools.isEmpty(oldPwd) {
            alert("请输入您的旧密码!", handler: {
                
            })
            return
        }
        if AppTools.isEmpty(newPwd) {
            alert("请输入您的新密码!", handler: {
                
            })
            return
        }
        if AppTools.isEmpty(rnewPwd) {
            alert("请确认您的新密码!", handler: {
                
            })
            return
        }
        
        if newPwd != rnewPwd{
            alert("您输入的新密码两次不同，请重新输入！",handler:{
                
            })
            return
        }
        var parameters = [String : AnyObject]()
        parameters["password"] = rnewPwd
        parameters["oldPassword"] = oldPwd
        NetworkTool.sharedTools.updatePassWord(parameters) { (login, error) in
            if error == nil {
                self.alert("密码修改成功，请重新登录！", handler: {
                    let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                    controller.isReLogin = true
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            }else{
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }else{
                    self.showHint(error, duration: 2.0, yOffset: 2.0)
                }
                
            }
            
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        if (customTableView.indexPathForSelectedRow != nil) {
            customTableView.deselectRowAtIndexPath(customTableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    //返回表格行数（也就是返回控件数）
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = self.cells?[section]
        return data!.count
        
    }
    
    //返回几节(组)
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (self.cells?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ReuseIdentifier, forIndexPath: indexPath) as! ShopInfoCell
        let secno = indexPath.section
        let _cell = self.cells![secno]![indexPath.row]
        cell.pwdModel = _cell
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
    
    func passParams(text: String,key:String,indexPaths: [NSIndexPath]) {
        pwdSettingModel.setValue(text, forKey: key)
        self.cells = self.pwdSettingModel.getCells()
       self.customTableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
//        self.customTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = self.cells![indexPath.section]![indexPath.row]
        switch cell.state {
        case CellState.READ:
            break
        case .AREA: break
        case .ENUM: break
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
}