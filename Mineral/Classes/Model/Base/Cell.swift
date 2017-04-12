//
//  KV.swift
//  yhintegrationES
//
//  Created by 安生科技 on 16/9/20.
//  Copyright © 2016年 安生科技. All rights reserved.
//

import Foundation

class Cell: BaseModel {
    var fieldName: String!
    var image: String!
    var title: String!
    var value: String!
    var state: CellState = CellState.READ
    /// 内容最大长度
    var maxLength: Int = 0
    var placeHolder:String!
    
    init(fieldName: String, image: String, title: String, value: String) {
        self.fieldName = fieldName
        self.image = image
        self.title = title
        self.value = value
    }
    
    init(fieldName: String, image: String, title: String, state: CellState) {
        self.fieldName = fieldName
        self.image = image
        self.title = title
        self.state = state
    }
    
    init(fieldName: String, image: String, title: String, value: String, maxLength: Int) {
        self.fieldName = fieldName
        self.image = image
        self.title = title
        self.value = value
        self.maxLength = maxLength
    }
    
    init(fieldName: String, image: String, title: String, value: String, state: CellState) {
        self.fieldName = fieldName
        self.image = image
        self.title = title
        self.value = value
        self.state = state
    }
    
    init(fieldName: String, image: String, title: String, value: String, state: CellState, maxLength: Int) {
        self.fieldName = fieldName
        self.image = image
        self.title = title
        self.value = value
        self.state = state
        self.maxLength = maxLength
    }
    init(fieldName: String, image: String, title: String, value: String, state: CellState, maxLength: Int,placeHolder: String) {
        self.fieldName = fieldName
        self.image = image
        self.title = title
        self.value = value
        self.state = state
        self.maxLength = maxLength
        self.placeHolder = placeHolder
    }
}