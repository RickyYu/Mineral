//
//  BaseMultiTextController.swift
//  Mineral
//
//  Created by Ricky on 2017/3/29.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
//反向传值
protocol MultiParameterDelegate{
    func passParams(text: String,key:String,indexPaths: [NSIndexPath])
}

class BaseMultiTextController: BaseViewController,UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!
    var delegate:MultiParameterDelegate!
    var indexPaths: [NSIndexPath] = []
    var cell: Cell!
    override func viewDidLoad() {
        setNavagation(cell.title)
        textView.delegate = self
        textView.layer.borderWidth = 1  //边框粗细
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        textView.layer.cornerRadius = 8
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignEdit(_:))))
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "set_head.png"), forBarMetrics: .Default)
        textView.text = cell.value
        textView.becomeFirstResponder()
        if cell.title == "门店名称" {
            textView.editable = false
        }else{
            let item=UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.save))
            self.navigationItem.rightBarButtonItem=item
        }
    }
    
    
    func save(){
        if((self.delegate) != nil)
        {
            let text = textView.text!
            let count = text.characters.count
            
            if text.isEmpty {
                alert("\(cell.title)不可为空")
                return
            }
            
            if  count > cell.maxLength {
                alert("\(cell.title)不能大于\(cell.maxLength)位，请重新填写！")
                return
            }
  
            
            
            //调用里面的协议方法
            self.delegate.passParams(text,key:cell.fieldName,indexPaths: indexPaths)
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
}
