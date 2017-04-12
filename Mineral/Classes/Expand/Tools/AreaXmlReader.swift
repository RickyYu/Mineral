//
//  XmlReader.swift
//  yhintegrationES
//
//  Created by 安生科技 on 16/9/26.
//  Copyright © 2016年 安生科技. All rights reserved.
//

import Foundation

class AreaXmlReader: NSObject, NSXMLParserDelegate {
    var area:Area = Area()
    
    //文档开始解析时触发，只触发一次
    func parserDidStartDocument(parser: NSXMLParser) {
        //print(parser)
    }
    
    //文档结束时触发，只触发一次，通常需要在这里给出一个信号告诉上层或其他人解析已经结束
    func parserDidEndDocument(parser: NSXMLParser) {
        //print(parser)
    }
    
    //遇到一个开始标签触发，elementName为当前标签，如果当前标签有属性，则字典sttributeDict不为空
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        let code = attributeDict["code"]!
        let name = attributeDict["name"]!
        
        if elementName == "first-area" {
            area.firstarea.append(attributeDict)
        }
        else if elementName == "second-area" {
            let fcode = (code as NSString).substringToIndex(4) + "00000000"
            let temp = ["code": code, "fcode": fcode, "name": name]
            area.secondarea.append(temp)
        }
        else if elementName == "third-area" {
            let fcode = (code as NSString).substringToIndex(6) + "000000"
            let temp = ["code": code, "fcode": fcode, "name": name]
            area.thirdarea.append(temp)
        }
        else if elementName == "fouth-area" {
            let fcode = (code as NSString).substringToIndex(9) + "000"
            let temp = ["code": code, "fcode": fcode, "name": name]
            area.foutharea.append(temp)
        }
    }
    
    //遇到结束标签触发，该方法主要是做一些清理工作，在这里我修改了当前的深度
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
    
    // 遇到字符串时触发
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let str:String! = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if str != ""{
            //print("temp:\(str)")
        }
    }
    
    // 文档出错时触发
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        //print(parseError)
    }
}