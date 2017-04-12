//
//  BaseTabViewController.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2017/1/20.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit

class BaseTabViewController:UITableViewController {
    override func viewDidLoad() {
       tableView.tableFooterView = UIView()
    }
    
    func setNavagation(title:String){
        //修改导航栏按钮颜色为白色
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //修改导航栏文字颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //修改导航栏背景颜色
       // self.navigationController?.navigationBar.barTintColor = YMGlobalBlueColor()
        self.view.backgroundColor = UIColor.whiteColor()
        //修改导航栏按钮返回只有箭头
        let item = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
        self.navigationItem.title = title
        
    }
    
    func alertNotice(titile:String,message:String,handler:()->Void){
        let alertController = UIAlertController(title: titile, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let acSure = UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive, handler: {
            action in
            handler()
        })
        let acCancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            print("click Cancel")
        }
        
        
        alertController.addAction(acSure)
        alertController.addAction(acCancel)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    func alertNoticeWithVoid(titile:String,message:String,handSure:()->Void,handCancel:()->Void){
        let alertController = UIAlertController(title: titile, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let acSure = UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive, handler: {
            action in
            handSure()
        })
        let acCancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
           handCancel()
        }
        
        
        alertController.addAction(acSure)
        alertController.addAction(acCancel)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func toLogin(){
        self.alertNotice("提示", message: NOTICE_SECURITY_NAME, handler: {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
}