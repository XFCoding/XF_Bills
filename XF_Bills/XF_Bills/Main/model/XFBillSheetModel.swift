//
//  XFSheetModel.swift
//  XF_Bills
//
//  Created by IAskSpace on 2017/5/23.
//  Copyright © 2017年 XFCoding. All rights reserved.
//

import Foundation

//单条记录model
class XFBillSheetModel{
    // 账本编号
    var billID = Int();
    //账单编号
    var sheetID = Int();
    //时间戳
    var timeInterval = String();
    // 消费/支出 类型(默认一般支出类型)
    var sheetType = SheetType.revenueType_normal;
    // 金额
    var sheetMoney = Float();
    // 备注
    var sheetRemark = String();
    
}





/// 账目类型（嵌套枚举）
///
/// - revenue: 支出(默认“一般”)
/// - income: 收入(默认"薪水")
enum SheetType:Int {
    
    /// 收入类型
    ///
    /// - salary:       薪水
    /// - redBag:       红包
    /// - investment:   投资
    case incomeType_salary = 1
    case incomeType_redBag
    case incomeType_investment
    /// 支出类型
    ///
    /// - normal:       一般（默认）
    /// - food:         食物
    /// - movie:        电影
    /// - sing:         唱歌
    /// - medical:      医药
    /// - travel:       旅行
    /// - study:        学习
    /// - love:         爱
    /// - shopping:     购物
    /// - bodyBuild:    健身
    /// - transfer:     转账
    case revenueType_normal
    case revenueType_food
    case revenueType_movie
    case revenueType_sing
    case revenueType_medical
    case revenueType_travel
    case revenueType_study
    case revenueType_love
    case revenueType_shopping
    case revenueType_bodyBuild
    case revenueType_transfer
}
