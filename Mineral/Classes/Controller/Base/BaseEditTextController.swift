//
//  BaseEditTextController.swift
//  Mineral
//
//  Created by Ricky on 2017/3/29.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit

//反向传值
protocol ParameterDelegate{
    func passParams(text: String,key:String,indexPaths: [NSIndexPath])
}
class BaseEditTextController: BaseViewController {

    @IBOutlet weak var customEditText: UITextField!
    var delegate:ParameterDelegate!
    var indexPaths: [NSIndexPath] = []
    var cell: Cell!
    var isPassWord:Bool = false
    override func viewDidLoad() {
        setNavagation(cell.title)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignEdit(_:))))
        if cell.title.componentsSeparatedByString("密码").count>1{
            customEditText.secureTextEntry = true
            isPassWord = true
        }else{
            customEditText.secureTextEntry = false
            isPassWord = false
        }
        
        if cell.placeHolder != nil {
         customEditText.placeholder = cell.placeHolder
        }
        
        if cell.title == "工商注册号" {
         customEditText.enabled = false
        }
   
        customEditText.text = cell.value
        customEditText.becomeFirstResponder()
        customEditText.addTarget(self, action: #selector(self.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        let item=UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.save))
        self.navigationItem.rightBarButtonItem=item
    }
    
    override func resignEdit(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            customEditText.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    func save(){
        if((self.delegate) != nil)
        {
            let text = customEditText.text!
            let count = text.characters.count

            if text.isEmpty {
                alert("\(cell.title)不可为空")
                return
            }
            if  count > cell.maxLength {
             
            }
            
            if isPassWord {
                if !ValidateEnum.password(text).isRight {
                    alert(NOTICE_PASSWORD)
                    return
                }
            }
            
            if cell.title == "联系电话" {
                if !ValidateEnum.phoneNum(text).isRight {
                    alert("电话格式错误，请重新输入!", handler: {
                        self.customEditText.becomeFirstResponder()
                    })
                    return
                }
            }
            
            if cell.title == "证件号码" {
                if text.characters.count>cell.maxLength || text.characters.count<7   {
                    alert("\(cell.title)长度为7-18位，请正确填写！")
                    return
                }
            }
            
            //调用里面的协议方法
            self.delegate.passParams(text,key:cell.fieldName,indexPaths: indexPaths)
            self.navigationController?.popViewControllerAnimated(true)
        }
    
    }
}
