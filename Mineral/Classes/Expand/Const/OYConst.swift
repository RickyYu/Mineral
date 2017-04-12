//
//  OYConst.swift
//  ZhiAnTongGov
//
//  Created by Ricky on 2016/12/28.
//  Copyright © 2016年 safetysafetys. All rights reserved.
//

import UIKit


let APPSTOR_ID = "id444934666"
//(1松香水，2烟花爆竹)
let TYPE_CODE = "1"

let PAGE_SIZE = 15
let LOAD_FINISH = "加载完毕"
let NOTICE_CPY_NAME = "请输入企业名称"
let NOTICE_SECURITY_NAME = "你的账号在另一台设备登录，如非本人操作，请注意账号安全!"
let NOTICE_NETWORK_FAILED = "网络连接失败,请检查您的网络连接!"
let NOTICE_CANCELL = "注销当前账号!"
let NOTICE_PASSWORD = "密码长度必须为6到18位，密码由数字字母组成，必须包含大小写字母以及数字!"

let MAX_INPUT_NUM = 20
//最大上传图片数
let IMAGE_MAX_SELECTEDNUM = 9


let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height

/// RGBA的颜色设置
func YMColor(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

/// 背景灰色
func YMGlobalColor() -> UIColor {
    return YMColor(240, g: 240, b: 240, a: 1)
}

/// 红色
func YMGlobalRedColor() -> UIColor {
    return YMColor(245, g: 80, b: 83, a: 1.0)
}

/// 红色
func YMGlobalDeapBlueColor() -> UIColor {
    return YMColor(0, g: 191, b: 255, a: 1.0)
}

/// navagtion蓝
func YMGlobalBlueColor() -> UIColor {
    return YMColor(0, g: 102, b: 255, a: 1.0)
}


/// 间距
let kMargin: CGFloat = 10.0

/// iPhone 5
let isIPhone5 = SCREEN_WIDTH == 568 ? true : false
/// iPhone 6
let isIPhone6 = SCREEN_WIDTH == 667 ? true : false
/// iPhone 6P
let isIPhone6P = SCREEN_WIDTH == 736 ? true : false


func getTroubleType(key:String)->String{
    switch key {
    case "物":
       return "1332"
    case "1332":
        return "物"
        
    case "管理":
        return "1344"
    case "1344":
        return "管理"
        
    case "人":
        return "1327"
    case "1327":
        return "人"
    default: return ""
        
    }
}
//处罚类型
func getPunType(key:String)->String{
    switch key {
    case "警告":
        return "punishmentType01"
    case "punishmentType01":
        return "警告"
        
    case "罚款":
        return "punishmentType02"
    case "punishmentType02":
        return "罚款"
        

    case "责令改正":
        return "punishmentType03"
    case "punishmentType03":
        return "责令改正"
        
    case "没收违法所得":
        return "punishmentType04"
    case "punishmentType04":
        return "没收违法所得"
        
    case "责令停产停业整顿":
        return "punishmentType05"
    case "punishmentType05":
        return "责令停产停业整顿"
        
    case "暂扣或者吊销有关许可证":
        return "punishmentType06"
    case "punishmentType06":
        return "暂扣或者吊销有关许可证"
        
        
    case "关闭":
        return "punishmentType07"
    case "punishmentType08":
        return "关闭"
        
        
    case "拘留":
        return "punishmentType08"
    case "punishmentType08":
        return "拘留"
        
        
    case "其他行政处罚":
        return "punishmentType09"
    case "punishmentType09":
        return "其他行政处罚"

    default: return ""
    }
}


    //经济类型
    func getEconomyType(key:String)->String{
        switch key {
        case "01国有经济":
            return "economyType01"
        case "economyType01":
            return "01国有经济"
            
        case "02集体经济":
            return "economyType02"
        case "economyType02":
            return "02集体经济"
            
        case "03私营经济":
            return "economyType03"
        case "economyType03":
            return "03私营经济"
            
        case "04有限责任公司":
            return "economyType04"
        case "economyType04":
            return "04有限责任公司"
            
        case "05联营经济":
            return "economyType05"
        case "economyType05":
            return "05联营经济"
            
        case "06股份合作":
            return "economyType06"
        case "economyType06":
            return "06股份合作"
            
        case "07外商投资":
            return "economyType07"
        case "economyType07":
            return "07外商投资"
            
        case "08港澳台投资":
            return "economyType08"
        case "economyType08":
            return "08港澳台投资"
            
        case "09其它经济":
            return "economyType09"
        case "economyType09":
            return "09其它经济"
            
        case "10股份有限公司":
            return "economyType10"
        case "economyType10":
            return "10股份有限公司"
            
        default: return ""
        }
    }
    
    //规模类型
    func getCpyType(key:String)->String{
        switch key {
        case "规上企业":
            return "isEnterprise1"
        case "isEnterprise1":
            return "规上企业"
            
        case "规下企业":
            return "isEnterprise2"
        case "isEnterprise2":
            return "规下企业"
            
        case "小微企业":
            return "isEnterprise3"
        case "isEnterprise3":
            return "小微企业"
        default: return ""

        }
    }

func getExpertTypeCode(key:String)->String{
    switch key {
    case "金属与非金属矿山":
        return "companyType_02"
    case "companyType_02":
        return "金属与非金属矿山"
        
    case "危险化学品":
        return "companyType_03"
    case "companyType_03":
        return "危险化学品"
        
    case "烟花爆竹":
        return "companyType_04"
    case "companyType_04":
        return "烟花爆竹"
        
    case "石油化工":
        return "companyType_05"
    case "companyType_05":
        return "石油化工"
        
    case "交通运输":
        return "companyType_06"
    case "companyType_06":
        return "交通运输"
        
    case "医药":
        return "companyType_07"
    case "companyType_07":
        return "医药"
        
    case "建材":
        return "companyType_08"
    case "companyType_08":
        return "建材"
        
    case "冶金":
        return "companyType_09"
    case "companyType_09":
        return "冶金"
        
    case "有色":
        return "companyType_10"
    case "companyType_10":
        return "有色"
        
    case "机械":
        return "companyType_11"
    case "companyType_11":
        return "机械"
        
    case "建筑":
        return "companyType_12"
    case "companyType_12":
        return "建筑"
        
    case "旅游":
        return "companyType_13"
    case "companyType_13":
        return "旅游"
        
    case "纺织":
        return "companyType_14"
    case "companyType_14":
        return "纺织"
        
    case "烟草":
        return "companyType_15"
    case "companyType_15":
        return "烟草"
        
    case "电力":
        return "companyType_16"
    case "companyType_16":
        return "电力"
        
    case "燃气":
        return "companyType_17"
    case "companyType_17":
        return "燃气"
        
    case "电信":
        return "companyType_18"
    case "companyType_18":
        return "电信"
        
    case "商贸":
        return "companyType_19"
    case "companyType_19":
        return "商贸"
        
    case "渔业":
        return "companyType_20"
    case "companyType_20":
        return "渔业"
        
    case "科研事业单位":
        return "companyType_21"
    case "companyType_21":
        return "科研事业单位"
        
    case "文化娱乐场所":
        return "companyType_22"
    case "companyType_22":
        return "文化娱乐场所"
        
    case "体育项目经营场所":
        return "companyType_23"
    case "companyType_23":
        return "体育项目经营场所"
        
    case "公园、风景区":
        return "companyType_24"
    case "companyType_24":
        return "公园、风景区"
        
    case "安全监管监察部门":
        return "companyType_60"
    case "companyType_60":
        return "安全监管监察部门"
        
    case "其他":
        return "companyType_99"
    case "companyType_99":
        return "其他"
   
  
    default: return ""
        
    }
}
