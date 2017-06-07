//
//  XFBillCellModel.swift
//  XF_Bills
//
//  Created by IAskSpace on 2017/5/23.
//  Copyright © 2017年 XFCoding. All rights reserved.
//

import Foundation

/// 账本枚举类型
///
/// - single:   单人账本
/// - multi:    多人公账
enum BillType:Int{
    case single = 1
    case multi
}

/// 账本model
class XFBillCellModel {
    //账本编号
    var billID = Int();
    //账本名称
    var billName  = String();
    //默认单人类型
    var billType  = BillType.single;
    //人数 默认为1
    var billPeople = 1;
    //账单记录(包含当前账单的所有记录model)
    var billArr = [XFBillSheetModel]();
}


