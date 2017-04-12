//
//  BaseViewController.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2016/11/23.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//
import UIKit
import UsefulPickerView



class BaseViewController: UIViewController {
    
    var editText : UITextField!
    var editView : UITextView!
    var keyBoardNeedLayout: Bool = true
    override func viewDidLoad() {
       //setNavagation("")
      self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignEdit(_:))))
    }
    
    func addNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        //当键盘收起的时候会向系统发出一个通知，
        //这个时候需要注册另外一个监听器响应该通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
            value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            let frame = value.CGRectValue()
            let intersection = CGRectIntersection(frame, self.view.frame)
            //除以2，位移变小
            let deltaY = CGRectGetHeight(intersection)/3
            print("deltaY = \(deltaY)")
            if keyBoardNeedLayout {
                UIView.animateWithDuration(duration, delay: 0.0,
                                           options: UIViewAnimationOptions(rawValue: curve),
                                           animations: { _ in
                                            self.view.frame = CGRectMake(0,-deltaY,self.view.bounds.width,self.view.bounds.height)
                                            self.keyBoardNeedLayout = false
                                            self.view.layoutIfNeeded()
                    }, completion: nil)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo,
            value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            let frame = value.CGRectValue()
            let intersection = CGRectIntersection(frame, self.view.frame)
            let deltaY = CGRectGetHeight(intersection)/3
            UIView.animateWithDuration(duration, delay: 0.0,
                                       options: UIViewAnimationOptions(rawValue: curve),
                                       animations: { _ in
                                        self.view.frame = CGRectMake(0,deltaY,self.view.bounds.width,self.view.bounds.height)
                                        self.keyBoardNeedLayout = true
                                        self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }

    func textDidChange(sender:UITextField) {
        let lang = textInputMode?.primaryLanguage
        if lang == "zh-Hans" {
            let range = sender.markedTextRange
            if range == nil {
                if sender.text?.characters.count >= MAX_INPUT_NUM {
                    sender.text = sender.text?.substringToIndex((sender.text?.startIndex.advancedBy(MAX_INPUT_NUM))!)
                }
            }
        }
        else {
            if sender.text?.characters.count >= MAX_INPUT_NUM {
                sender.text = sender.text?.substringToIndex((sender.text?.startIndex.advancedBy(MAX_INPUT_NUM))!)
            }
        }
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
        self.navigationController?.navigationBar.hidden = false
    }
    
    func resignEdit(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
       
        }
        sender.cancelsTouchesInView = false
    }

    
    func handleEditText(handler: () -> Void){
       handler()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    /**
     UITableView默认初始化配置
     */
    func initTableView(tableView: UITableView) {
        //去除多余空白cell
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    /**
     通过navigationController跳转，则使用该方法返回上一页
     */
    func lastNavigationPage() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    /**
     通过navigationController跳转，则使用该方法返回到指定页面
     */
    func lastNavigationPage(toView: UIViewController) {
        self.navigationController?.popToViewController(toView, animated: true)
    }
    
    /**
     通过pushView跳转firsView->secondView->thirdView，当在thirdView执行下面语句，则调回firtView页面
     */
    func lastNavigationRootPage() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    /**
     通过View的presentViewController跳转的页面才能执行，返回上一页
     */
    func lastDismissPage() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    ///presentViewController跳转，包含4种系统默认的过渡效果
    func toViewPresent(toView: UIViewController) {
        toView.modalTransitionStyle =  UIModalTransitionStyle.CrossDissolve
        presentViewController(toView, animated: true, completion: nil)
        
    }
    ///navigationController跳转
    func toViewNavigation(title: String, toView: UIViewController) {
        let item = UIBarButtonItem(title: title, style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
        self.navigationController?.pushViewController(toView, animated: true)
    }
    
    func alert(msg: String) {
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func alert(msg: String, handler: () -> Void) {
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "确定", style: .Default, handler: {
            action in
            handler()
        })
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   internal func choiceTime(finished:(time:String)->()){
        let alertController:UIAlertController=UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        // 初始化 datePicker
        let datePicker = UIDatePicker( )
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        datePicker.locale = NSLocale(localeIdentifier: "zh_CN")
        // 设置样式，当前设为同时显示日期和时间
        datePicker.datePickerMode = UIDatePickerMode.Date
        // 设置默认时间
        datePicker.date = NSDate()
        // 响应事件（只要滚轮变化就会触发）
        // datePicker.addTarget(self, action:Selector("datePickerValueChange:"), forControlEvents: UIControlEvents.ValueChanged)
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default){
            (alertAction)->Void in
            //更新提醒时间文本框
            let formatter = NSDateFormatter()
            //日期样式
            formatter.dateFormat = "yyyy-MM-dd"
           // self.customView4.setRRightLabel(formatter.stringFromDate(datePicker.date))
            finished(time: formatter.stringFromDate(datePicker.date))
            
            })
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler:nil))
        
        alertController.view.addSubview(datePicker)
        
        self.presentViewController(alertController, animated: true, completion: nil)
   
    }
    internal func getSystemTime(finished:(time:String)->()){
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
         finished(time: formatter.stringFromDate(date) as String)
    }
    
    internal func getChoiceArea(areaArr:[String],finished:(area:String,areaArr:[String])->()){
//        UsefulPickerView.showCitiesPicker("市区镇选择", defaultSelectedValues: areaArr) { (selectedIndexs, selectedValues) in
//          
//        }
        UsefulPickerView.showCitiesPicker("市区镇选择", defaultSelectedValues: areaArr) {[unowned self] (selectedIndexs, selectedValues) in
            // 处理数据
            let combinedString = selectedValues.reduce("", combine: { (result, value) -> String in
                result + " " + value
            })
            finished(area:combinedString,areaArr: selectedValues)
        }
    
    }
    
    func toLogin(){
        self.alertNotice("提示", message: NOTICE_SECURITY_NAME, handler: {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    //获取当前版本号
    func getVersion()->String{
        
       return NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
    }

    
    //版本更新
    private func compareVersion(localVersion: String, storeVersion: String) {
        if localVersion.compare(storeVersion) == NSComparisonResult.OrderedAscending {
            self.alertNotice("更新可用", message: "\(NSBundle.mainBundle().infoDictionary!["CFBundleDisplayName"])的新版本可用。请立即更新至\(storeVersion)。", handler: {
                self.gotoAppStore()
            })
        }
    }
    
    //跳转到应用的AppStore页页面
    func gotoAppStore() {
        let urlString = "itms-apps://itunes.apple.com/app/"+APPSTOR_ID
        let url = NSURL(string: urlString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    //比较版本号更新
    func isUpdate()->Bool{
        let sandboxVersion =  NSUserDefaults.standardUserDefaults().objectForKey("CFBundleShortVersionString") as? String ?? ""
        if getVersion().compare(sandboxVersion) == NSComparisonResult.OrderedDescending {
            
            //存储当前的版本到沙盒
            NSUserDefaults.standardUserDefaults().setObject(getVersion(), forKey: "CFBundleShortVersionString")
            //获取到的当前版本 > 之前的版本 = 有新版本
            return true
        }
        //获取到的当前版本 <= 之前的版本 = 没有新版本
        return false
    }
    
    func fileSizeOfCache()-> Int {
        
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
        //缓存目录路径
        print(cachePath)
        
        // 取出文件夹下所有文件数组
        let fileArr = NSFileManager.defaultManager().subpathsAtPath(cachePath!)
        
        //快速枚举出所有文件名 计算文件大小
        var size = 0
        for file in fileArr! {
            
            // 把文件名拼接到路径中
            let path = cachePath?.stringByAppendingString("/\(file)")
            // 取出文件属性
            let floder = try! NSFileManager.defaultManager().attributesOfItemAtPath(path!)
            // 用元组取出文件大小属性
            for (abc, bcd) in floder {
                // 累加文件大小
                if abc == NSFileSize {
                    size += bcd.integerValue
                }
            }
        }
        
        let mm = size / 1024 / 1024
        
        return mm
    }
    
    func clearCache() {
        
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
        
        // 取出文件夹下所有文件数组
        let fileArr = NSFileManager.defaultManager().subpathsAtPath(cachePath!)
        
        // 遍历删除
        for file in fileArr! {
            
            let path = cachePath?.stringByAppendingString("/\(file)")
            if NSFileManager.defaultManager().fileExistsAtPath(path!) {
                
                do {
                    try NSFileManager.defaultManager().removeItemAtPath(path!)
                } catch {
                    
                }
            }
        }
    }
    
    //去除空字符
    func trimSpace(text:String)->String{
        //前后空格去除
        let whiteSpace = NSCharacterSet.whitespaceCharacterSet()
        return text.stringByTrimmingCharactersInSet(whiteSpace)
        //        var tempArray = ss.componentsSeparatedByCharactersInSet(whiteSpace)
        //        tempArray = tempArray.filter($o != "")
        
    }
    
}
