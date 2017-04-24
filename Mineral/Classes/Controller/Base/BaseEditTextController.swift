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
class BaseEditTextController: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var customEditText: UITextField!
    var delegate:ParameterDelegate!
    var indexPaths: [NSIndexPath] = []
    var cell: Cell!
    var isPassWord:Bool = false
    var cellTitle:String!
    var cardNum:Int!
    override func viewDidLoad() {
        setNavagation(cell.title)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "set_head.png"), forBarMetrics: .Default)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignEdit(_:))))
        cellTitle = cell.title
        customEditText.text = cell.value
        customEditText.becomeFirstResponder()
        customEditText.addTarget(self, action: #selector(self.textDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        if cellTitle.componentsSeparatedByString("密码").count>1{
            customEditText.secureTextEntry = true
            isPassWord = true
        }else{
            customEditText.secureTextEntry = false
            isPassWord = false
        }
        
        if cell.placeHolder != nil {
         customEditText.placeholder = cell.placeHolder
        }
        
        if cellTitle == "门店名称" {
          customEditText.enabled = false
        }
        
        if cellTitle == "数量(升)" {
            customEditText.keyboardType = .DecimalPad
            
        }
        
//        if cellTitle.componentsSeparatedByString("电话").count>1 {
//            customEditText.keyboardType = .PhonePad
//            
//        }
        
//        customEditText.delegate = self
        
        let item=UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.save))
        self.navigationItem.rightBarButtonItem=item
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return limitFloat(textField.text!, range: range, string: string)
    }
    
    //限制小数点后面最多只能2位
    func limitFloat(text:String,range:NSRange,string:String)->Bool{
        
        let futureString: NSMutableString = NSMutableString(string: text)
        futureString.insertString(string, atIndex: range.location)
        
        var flag = 0;
        
        let limited = 2;//小数点后需要限制的个数
        
        if !futureString.isEqualToString("") {
            for i in (futureString.length - 1).stride(through: 0, by: -1) {
                let char = Character(UnicodeScalar(futureString.characterAtIndex(i)))
                if char == "." {
                    if flag > limited {
                        return false
                    }
                    break
                }
                flag += 1
            }
        }
        return true
    }
    
    override func textDidChange(sender:UITextField) {
        let lang = textInputMode?.primaryLanguage
        if lang == "zh-Hans" {
            let range = sender.markedTextRange
            if range == nil {
                if sender.text?.characters.count >= cell.maxLength {
                    sender.text = sender.text?.substringToIndex((sender.text?.startIndex.advancedBy(cell.maxLength))!)
                }
            }
        }
        else {
            if sender.text?.characters.count >= cell.maxLength {
                sender.text = sender.text?.substringToIndex((sender.text?.startIndex.advancedBy(cell.maxLength))!)
            }
        }
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
            let text = trimSpace(customEditText.text!)
            let count = text.characters.count
            
            if text.isEmpty {
                alert("\(cell.title)不可为空")
                return
            }
            
            let trimTitle = cellTitle.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if  count > cell.maxLength {
                   alert("\(trimTitle)不能大于\(cell.maxLength)位，请重新填写！")
                    return
            }
            
            if isPassWord {
                
                if cell.title != "旧密码"{
                
                if !ValidateEnum.password(text).isRight {
                    alert(NOTICE_PASSWORD)
                    return
                 }
                }
            }
            
            
            if cellTitle == "联系电话" {
                if !ValidateEnum.phoneNum(text).isRight {
                    alert("电话格式错误，请重新输入!", handler: {
                        self.customEditText.becomeFirstResponder()
                    })
                    return
                }
            }
            
            if cellTitle == "证件号码" {
                //护照
                if cardNum == 0 {
                    if text.characters.count>9 || text.characters.count<7   {
                        alert("护照长度为7-9位，请正确填写！")
                        return
                    }
                }else {//身份证，驾照
                    if !ValidateEnum.cardNum(text).isRight {
                        alert("\(cell.title)格式错误，请重新输入!", handler: {
                            self.customEditText.becomeFirstResponder()
                        })
                        return
                    }
                }
            }

            
            //调用里面的协议方法
            self.delegate.passParams(text,key:cell.fieldName,indexPaths: indexPaths)
            self.navigationController?.popViewControllerAnimated(true)
        }
    
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        customEditText.resignFirstResponder()
        return true
    }
}
