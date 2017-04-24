//
//  MainController.swift
//  Mineral
//
//  Created by Ricky on 2017/3/9.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
class MainController: BaseViewController{

    @IBOutlet weak var totalYearNum: UILabel!
    @IBOutlet weak var firstSeasonNum: UILabel!
    @IBOutlet weak var secondSeasonNum: UILabel!
    @IBOutlet weak var thirdSeasonNum: UILabel!
    @IBOutlet weak var fouthSeasonNum: UILabel!
    

    @IBOutlet weak var totalMonthNum: UILabel!
    @IBOutlet weak var firstWeekNum: UILabel!
    @IBOutlet weak var secondWeekNum: UILabel!
    @IBOutlet weak var thirdWeekNum: UILabel!
    @IBOutlet weak var fourhWeekNum: UILabel!
    
    var numSeason1:Int = 0
    var numSeason2:Int = 0
    var numSeason3:Int = 0
    var numSeason4:Int = 0
    
    var numMonth1:Int = 0
    var numMonth2:Int = 0
    var numMonth3:Int = 0
    var numMonth4:Int = 0
    


    var models = [SalesCountModel]()
    // 当前页
    var currentPage : Int = 0  //加载更多时候+PAGE_SIZE
    //总条数
    var totalCount : Int = 0
    // 是否加载更多
    private var toLoadMore = false
    override func viewDidLoad() {
        setNavagation("")
       self.navigationController?.navigationBar.hidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "set_head.png"), forBarMetrics: .Default)
    }
    
    override func viewWillAppear(animated: Bool) {
       self.navigationController?.navigationBar.hidden = true
        getRecords()
    }
    
    func getRecords(){
//        if let array = SalesCountModel.loadLocalSalesCountModels() {
//            setData(array)
//        }
        
        var parameters = [String : AnyObject]()
        parameters["type"] = TYPE_CODE
        NetworkTool.sharedTools.getRecordCount(parameters) { (data, error) in
            if error == nil{
                 self.setData(data)
            }else{
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }else{
                    self.showHint(error, duration: 2.0, yOffset: 2.0)
                }
            }
        }
        
    }
    
    func setData(data : [SalesCountModel]!){
        self.models = data
        for model in data {
            if model.dataType == "season1" {
                self.numSeason1 = model.num
                self.firstSeasonNum.text = "第一季度：\(self.numSeason1)"
            }else if model.dataType == "season2" {
                self.numSeason2 = model.num
                self.secondSeasonNum.text = "第二季度：\(self.numSeason2)"
            }else if model.dataType == "season3" {
                self.numSeason3 = model.num
                self.thirdSeasonNum.text = "第三季度：\(self.numSeason3)"
            }else if model.dataType == "season4" {
                self.numSeason4 = model.num
                self.fouthSeasonNum.text = "第四季度：\(self.numSeason4)"
            }else if model.dataType == "month1" {
                self.numMonth1 = model.num
                self.firstWeekNum.text = "第一周：\(self.numMonth1)"
            }else if model.dataType == "month2" {
                self.numMonth2 = model.num
                self.secondWeekNum.text = "第二周：\(self.numMonth2)"
            }else if model.dataType == "month3" {
                self.numMonth3 = model.num
                self.thirdWeekNum.text = "第三周：\(self.numMonth3)"
            }else if model.dataType == "month4" {
                self.numMonth4 = model.num
                self.fourhWeekNum.text = "第四周：\(self.numMonth4)"
            }
            
            self.totalYearNum.text = String(self.numSeason1+self.numSeason2+self.numSeason3+self.numSeason4)
            self.totalMonthNum.text = String(self.numMonth1+self.numMonth2+self.numMonth3+self.numMonth4)
        }
    }
    
}

