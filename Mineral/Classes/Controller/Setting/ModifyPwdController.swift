//
//  ModifyPwdController.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2016/11/30.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ModifyPwdController: BaseViewController {
    
    @IBOutlet weak var newPwdField: UITextField!
    @IBOutlet weak var confirmNewPwdField: UITextField!
    @IBOutlet weak var oldPwdField: UITextField!
     var submitBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavagation("密码修改")
        initPage()
    }
    
    private func initPage(){
        submitBtn.setTitle("提交", forState:.Normal)
        submitBtn.backgroundColor = YMGlobalDeapBlueColor()
        submitBtn.setTitleColor(UIColor.greenColor(), forState: .Highlighted) //触摸状态下文字的颜色
        submitBtn.addTarget(self, action: #selector(self.submit), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(submitBtn)
        
        submitBtn.snp_makeConstraints { make in
            make.bottom.equalTo(self.view.snp_bottom).offset(-30)
            make.left.equalTo(self.view.snp_left).offset(50)
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH-100, 35))
        }
        // 设置navigation
       // navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_white"), style: .Done, target: self, action: #selector(ModifyPwdController.back))
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignEdit(_:))))
        
    }
    
    override func resignEdit(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            newPwdField.resignFirstResponder()
            confirmNewPwdField.resignFirstResponder()
            oldPwdField.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    func back()
    {
        self.lastNavigationPage()
    }
    
    func submit(){
        let newPwd = newPwdField.text!
        let confirmNewPwd = confirmNewPwdField.text!
        let oldPwd = oldPwdField.text!
        if AppTools.isEmpty(newPwd) {
            alert("请输入您的新密码!", handler: {
                self.newPwdField.becomeFirstResponder()
            })
            return
        }
        if AppTools.isEmpty(confirmNewPwd) {
            alert("请确认您的新密码!", handler: {
                self.confirmNewPwdField.becomeFirstResponder()
            })
            return
        }
        if AppTools.isEmpty(oldPwd) {
            alert("请输入您的旧密码!", handler: {
                self.oldPwdField.becomeFirstResponder()
            })
            return
        }
        if newPwd != confirmNewPwd{
            alert("您输入的新密码两次不同，请重新输入！",handler:{
                self.confirmNewPwdField.becomeFirstResponder()
            })
            return
        }
        self.updatePwd(confirmNewPwd, oldPwd: oldPwd)
    
    }
    
    func updatePwd(confirmNewPwd:String,oldPwd:String){
        var parameters = [String : AnyObject]()
        parameters["password"] = confirmNewPwd
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
}

