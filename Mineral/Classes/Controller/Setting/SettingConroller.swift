//
//  SettingConroller.swift
//  Mineral
//
//  Created by Ricky on 2017/3/16.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit

class SettingConroller: BaseViewController {
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var passView: UIView!
    @IBOutlet weak var lbCache: UILabel!
    var navBarHairlineImageView :UIImageView!
    
    override func viewDidLoad() {
        setNavagation("设置")
       
//      self.navigationController?.navigationBar.subviews[0].removeFromSuperview()//去掉
//        navBarHairlineImageView = findHairlineImageViewUnder(self.navigationController?.navigationBar.bac)
        initView()
    }
    
    override func viewWillAppear(animated: Bool) {
//        self.navBarHairlineImageView.hidden = true
        //设置navigationBar背景
        self.navigationController?.navigationBar
            .setBackgroundImage(UIImage(named: "head_transparent"), forBarMetrics: .Default)
        //设置navigationBar  黑线背景
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "head_transparent")
    }
    
    override func viewWillDisappear(animated: Bool) {
//        self.navBarHairlineImageView.hidden = false
    }
    
    func initView(){
        if AppTools.isExisNSUserDefaultsKey("userName"){
            lbName.text=AppTools.loadNSUserDefaultsValue("userName") as? String
        }
      lbCache.text = "已使用"+String(self.fileSizeOfCache())+"M"
    }
    
    /**
     隐藏导航底部黑线
     
     - parameter view: self.navigationController?.navigationBar
     
     - returns: 底部线的UIImageView
     */
    func findHairlineImageViewUnder(view : UIView)->UIImageView!{
        
        if(view .isKindOfClass(UIImageView) && view.bounds.size.height <= 1.0 ){
            
            return view as! UIImageView
        }
        for subview in view.subviews {
            
            let imageView = self .findHairlineImageViewUnder(subview)
            
            if (imageView != nil) {
                return imageView
            }
        }
        return nil
    }
    
    @IBAction func back(sender: AnyObject) {
        self.lastNavigationPage()
    }
    
    @IBAction func cancell(sender: AnyObject) {
        self.alertNotice("提示", message: NOTICE_CANCELL, handler: {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    @IBAction func clean(sender: AnyObject) {
        self.alert("确定清空缓存吗？") {
            self.clearCache()
            self.lbCache.text = "已使用0M"
        }
    }
    
//    @IBAction func update(sender: AnyObject) {
//        let parameters = [String : AnyObject]()
// 
//        NetworkTool.sharedTools.getVersion(parameters) { (data, error) in
//            if error == nil {
//                self.compareVersion(self.getVersion(),storeVersion: data)
//            }else{
//            self.showHint("当前已是最新版本", duration: 2.0, yOffset: 2.0)
//            }
//
//        }
//    }
    
    
    func up(){
    
        let path = NSString(format: "http://itunes.apple.com/cn/lookup?id=%@", APPSTOR_ID) as String
        
        // AppStore地址(URL)
         let url = NSURL(string: path)
        
        // 配置网络请求参数
         let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 10.0)
        request.HTTPMethod = "POST"
        // 开始网络请求
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { (response, data, error) in
            
            // 声明获取的数据字典
            let receiveStatusDic = NSMutableDictionary()
            
            if data != nil {
                
                do {
                    // JSON解析data
                    let dic = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    
                    // 取出版本号
                    // 判断是否resultCount为空
                    if let resultCount = dic["resultCount"] as? NSNumber {
                        
                        // 判断resultCount的数量是否大于0
                        if resultCount.integerValue > 0 {
                            
                            // 设置请求状态(1代表成功，0代表失败)
                            receiveStatusDic.setValue("1", forKey: "status")
                            
                            // 判断results是否为空
                            if let arr = dic["results"] as? NSArray {
                                
                                if let dict = arr.firstObject as? NSDictionary {
                                    
                                    // 取出version
                                    if let version = dict["version"] as? String {
                                        
                                        receiveStatusDic.setValue(version, forKey: "version")
                                        
                                        // 存网络版本号到UserDefaults里面
                                        NSUserDefaults.standardUserDefaults().setObject(version, forKey: "Version")
                                        
                                        NSUserDefaults.standardUserDefaults().synchronize()
                                    }
                                }
                            }
                        }
                    }
                }catch let error {
                    
                    print("checkUpdate -------- \(error)")
                    
                    receiveStatusDic.setValue("0", forKey: "status")
                }
            }else {
                
                receiveStatusDic.setValue("0", forKey: "status")
            }
            
            // 取出版本号后(若有则status为1，若没有则status为0)，执行方法
//            self.performSelectorOnMainThread(#selector(self.checkUpdateWithData(_:)), withObject: receiveStatusDic, waitUntilDone: false)
        }
        
    }
    
    
    @IBAction func changPwd(sender: AnyObject) {
        self.navigationController?.pushViewController(PwdSettingController(), animated: true)
    }
    
}
