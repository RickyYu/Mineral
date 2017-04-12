//
//  RecentSaleRecordsCell.swift
//  Mineral
//
//  Created by Ricky on 2017/3/22.
//  Copyright © 2017年 safetysafetys. All rights reserved.
//

import UIKit

class RecentSaleRecordsCell: UITableViewCell {

    @IBOutlet weak var lbPayTime: UILabel!
    @IBOutlet weak var lbContant: UILabel!
    @IBOutlet weak var lbDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var  model: SaleRecordModel?
        {
        didSet{
            if let art = model {
                // 设置数据

                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let date = formatter.dateFromString(art.payTime)
                let formatter1 = NSDateFormatter()
                formatter1.dateFormat = "MM.dd"
                let dataString = formatter1.stringFromDate(date!)
                
                
                self.lbPayTime.text = dataString
                //self.lbContant.text =  "门店:\(art.companyName)  电话：\(art.phone)"
                self.lbContant.text = ("\(art.name) 购买了\(art.productNumber)升\( ( art.productName))")
                self.lbDetail.text = "联系电话：\(art.phone)"
            }
            
        }
    }
}
