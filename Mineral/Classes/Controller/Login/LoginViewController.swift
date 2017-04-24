//
//  ViewController.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2016/11/16.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class LoginViewController: BaseViewController{
    ///用户名上边距约束
    @IBOutlet weak var userNameFieldTop: NSLayoutConstraint!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passWordField: UITextField!
    @IBOutlet weak var isRmbPasBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    var isReLogin = false
    var oldUserName:String = ""
    
    ///记住密码标识符
    let LOGIN_RECORD_STATE: String = "loginRecordStatesMineral"
    
    override func viewDidLoad() {
        super.viewDidLoad()
      // self.navigationController?.navigationBar.hidden = true
        self.initPage()
        //点击空白处隐藏键盘
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignEdit(_:))))
        addNotification()
       
        if AppTools.isExisNSUserDefaultsKey("userName") {
              oldUserName = AppTools.loadNSUserDefaultsValue("userName") as! String
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        // self.navigationController?.navigationBar.hidden = true
    }
    
    override func resignEdit(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            userNameField.resignFirstResponder()
            passWordField.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    @IBAction func login(sender: UIButton) {
      //  self.reloadData()
        let userName = trimSpace(userNameField.text!)
        let passWord = trimSpace(passWordField.text!)
     
        if AppTools.isEmpty(userName) {
            alert("请输入您的用户名!", handler: {
                self.userNameField.becomeFirstResponder()
            })
            return
        }
        if AppTools.isEmpty(passWord) {
            alert("请输入您的密码!", handler: {
                self.passWordField.becomeFirstResponder()
            })
        return
        }
        //后台验证登录信息是否正确
        self.loginValidate(userName, password: passWord)
        //记住用户名
        AppTools.setNSUserDefaultsValue("userName", userName)
        //根据页面状态，记住登录密码
        if AppTools.isExisNSUserDefaultsKey(LOGIN_RECORD_STATE) {
            AppTools.setNSUserDefaultsValue("userPassword", passWord)
        }
    }
    
    ///后台登录验证
    func loginValidate(userName: String, password: String) {
        
        var parameters = [String : AnyObject]()
        parameters["username"] = userName
        parameters["password"] = password
        parameters["type"] = TYPE_CODE
        
        NetworkTool.sharedTools.login(parameters) { (login, error) in
            if error == nil{
                let user = login!.user
                if user != nil{
                    user.userName = userName
                    user.userPassword =  password
                    AppTools.setNSUserDefaultsClassValue("login", login!)
                    AppTools.setNSUserDefaultsClassValue("user", user)
                    AppTools.setNSUserDefaultsValue("identify", (login?.identify)!)
                    if self.oldUserName != userName {
                        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ShopInfoController") as! ShopInfoController
                        controller.isSave = true
                        let  navShopInfoController = UINavigationController(rootViewController:controller)
                        self.presentViewController(navShopInfoController, animated: true, completion: nil)
                    }else {
                        
                        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainController") as! MainController
                        let  navShopInfoController = UINavigationController(rootViewController:controller)
                        self.presentViewController(navShopInfoController, animated: true, completion: nil)
//                        self.performSegueWithIdentifier("toMain", sender: self)
                    }
                }else{
                    self.alert((login?.msg)!)
                    self.passWordField.text = ""
                }
                
            }else{
                self.showHint(error, duration: 2.0, yOffset: 2.0)
                
            }
        }
        
    }

    @IBAction func rmbPas(sender: UIButton) {
        self.setCheckboxBtnImage();
    }
    
    
    func initPage(){
        if AppTools.isExisNSUserDefaultsKey("userName"){
            userNameField.text=AppTools.loadNSUserDefaultsValue("userName") as? String
        }
        let state = AppTools.isExisNSUserDefaultsKey(LOGIN_RECORD_STATE)
        if state{
        isRmbPasBtn.setImage(UIImage(named: "cb_select"), forState: UIControlState.Normal)
            passWordField.text=AppTools.loadNSUserDefaultsValue("userPassword") as? String
            if isReLogin {
               passWordField.text = ""
            }
        }
        userNameField.resignFirstResponder()
        //userNameField.returnKeyType = UIReturnKeyType.Next
        userNameField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        passWordField.resignFirstResponder()
        self.initTextFieldLeftImage()
        
    }
    
    //去除密码
    func textFieldDidChange(sender:UITextField) {
        let userNameCount = userNameField.text?.characters.count
        if userNameCount > 0 {
            passWordField.text = ""
        }
    }
    
    ///给控件添加左视图
    func initTextFieldLeftImage() {
        let nameLeftView:UIView = UIView(frame: CGRectMake(0, 0, 25, 65))
        let namePic:UIImageView = UIImageView(frame: CGRectMake(1, 18, 28, 28))
        namePic.image = UIImage(named: "login_icon_account")
        nameLeftView.addSubview(namePic)
        userNameField.leftView = nameLeftView
        //下面这句代码是指图片何时显示
        userNameField.leftViewMode = UITextFieldViewMode.Always;
        
        let pwdLeftView:UIView = UIView(frame: CGRectMake(0, 0, 25, 65))
        let pwdPic:UIImageView = UIImageView(frame: CGRectMake(1, 18, 28, 28))
        pwdPic.image = UIImage(named: "login_icon_pas")
        pwdLeftView.addSubview(pwdPic)
        passWordField.leftView = pwdLeftView
        passWordField.leftViewMode = UITextFieldViewMode.Always
        
    }
    
    ///密码状态设置
    func setCheckboxBtnImage() {
        if AppTools.isEmpty(passWordField.text!) {
            showHint("密码不能为空", duration: 2, yOffset: 2)
            return
        }
        
        let loginRecordState = AppTools.isExisNSUserDefaultsKey(LOGIN_RECORD_STATE)
        if loginRecordState {
            AppTools.removeNSUserDefaultsKey(LOGIN_RECORD_STATE)
            isRmbPasBtn.setImage(UIImage(named: "cb_unselect"), forState: UIControlState.Normal)
        }
        else {
            AppTools.setNSUserDefaultsValue(LOGIN_RECORD_STATE, true)
            isRmbPasBtn.setImage(UIImage(named: "cb_select"), forState: UIControlState.Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func DoneCloseKeyBoard(sender: AnyObject) {
        passWordField.resignFirstResponder()
    }
    
    deinit{
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

