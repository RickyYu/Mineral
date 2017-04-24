//
//  SaleRecordsListController.swift
//  Mineral
//
//  Created by Ricky on 2017/3/21.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit
private let ReuseIdentifier = "SaleRecordsCell"
class SaleRecordsListController: BaseViewController,UITableViewDelegate,UITableViewDataSource  {
    
    @IBOutlet weak var table: UITableView!
    
    var models = [SaleRecordModel]()
    // 当前页
    var currentPage : Int = 0  //加载更多时候+PAGE_SIZE
    //总条数
    var totalCount : Int = 0
    // 是否加载更多
    private var toLoadMore = false
    //搜索控制器
    var countrySearchController = UISearchController()
    //排序规则
    var isSortType = false //false 时间排序  time 数量排序
    
    var btnHome:UIButton!
    
    var itemTime = UIBarButtonItem()
    var itemNum = UIBarButtonItem()
    
    override func viewDidLoad() {
        setNavagation("销售记录列表")
        initView()
    }
    
    func initView(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "set_head.png"), forBarMetrics: .Default)
        // 设置tableview相关
        let nib = UINib(nibName: ReuseIdentifier,bundle: nil)
        self.table.registerNib(nib, forCellReuseIdentifier: ReuseIdentifier)
        table.rowHeight = 53;
        table.backgroundColor = UIColor.whiteColor()
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
//        sortByNum()
    }
    
    func sortByNum(){
        isSortType = false
        itemTime=UIBarButtonItem(title: "数量排序", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.sortByTime))
        self.navigationItem.rightBarButtonItem=itemTime
        reSet()
        getRecordList()
    }
    override func viewWillAppear(animated: Bool) {
        sortByNum()
    }
    
    func sortByTime(){
        isSortType = true
        itemTime=UIBarButtonItem(title: "时间排序", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.sortByNum))
        self.navigationItem.rightBarButtonItem=itemTime
        reSet()
        getRecordList()
    }

    func getRecordList(){
        var parameters = [String : AnyObject]()
        parameters["type"] = TYPE_CODE
        parameters["limit"] = PAGE_SIZE
        parameters["start"] = currentPage
        if isSortType {
        parameters["productNumber"] = "1"
        }
        NetworkTool.sharedTools.getRecordList(parameters) { (data, error,totalCount) in
            if error == nil{
                if self.currentPage>totalCount{
                    self.totalCount = totalCount!
                    self.currentPage -= PAGE_SIZE
                    return
                }
                self.toLoadMore = false
                self.models += data!
                self.table.reloadData()
            }else{
                // 获取数据失败后
                self.currentPage -= PAGE_SIZE
                if self.toLoadMore{
                    self.toLoadMore = false
                }
                if error == NOTICE_SECURITY_NAME {
                    self.toLogin()
                }else{
                    self.showHint(error, duration: 2.0, yOffset: 2.0)
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ReuseIdentifier, forIndexPath: indexPath) as! SaleRecordsCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        let count = models.count ?? 0
        if count > 0 {
            let model = models[indexPath.row]
            cell.model = model
        }
        //自动下拉加载
        if count > 0 && indexPath.row == count-1 && !toLoadMore && totalCount>PAGE_SIZE{
            toLoadMore = true
            currentPage += PAGE_SIZE
            getRecordList()
        }
        return cell
    }

    
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RealNameRegController") as! RealNameRegController
        controller.saleRecordModel = models[indexPath.row]
        table.deselectRowAtIndexPath(table.indexPathForSelectedRow!, animated: true)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    // MARK: - 内部控制方法
    /**
     重置数据
     */
    func reSet(){
        // 重置当前页
        currentPage = 0
         totalCount = 0
        // 重置数组
        models.removeAll()
        models = [SaleRecordModel]()
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            let recordId = models[indexPath.row].id
            models.removeAtIndex(indexPath.row)
            deleteRecord(recordId)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
    }
    
    func deleteRecord(recordId:Int){
        var parameters = [String : AnyObject]()
        parameters["sxsRecord.id"] = String(recordId)
        parameters["type"] = TYPE_CODE
        NetworkTool.sharedTools.deleteSaleRecord(parameters) { (data, error) in
            if error == nil{
               self.table.reloadData()
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
