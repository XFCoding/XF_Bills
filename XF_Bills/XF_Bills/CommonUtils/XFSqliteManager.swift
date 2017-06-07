//
//  XFSqliteManager.swift
//  XF_Bills
//
//  Created by IAskSpace on 2017/5/23.
//  Copyright © 2017年 XFCoding. All rights reserved.
//

import Foundation
import FMDB

class XFSqliteManager: NSObject {
    
    //MARK: - --------------properties---------------
    /// 创建单例
    static let shareManager = XFSqliteManager();
    /// 数据库名称
    private let dbName = "bills.db";
    /// FMDatabaseQueue对象
    let dbQueue:FMDatabaseQueue
    
    enum TableType {
        case billType
        case sheetType
    }
    
    //构造方法
    override init() {
        // 获取沙盒路径
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!;
        // 拼接数据库完整路径
        let dbPath = (docPath as NSString).appendingPathComponent(dbName);
        
        // 创建FMDatabaseQueue对象，会自动打开数据库，并创建一个串行队列
        dbQueue = FMDatabaseQueue(path: dbPath);
        super.init();
        
        // 创建数据表
        // 账本表
        createBillTable();
        // 账目表
        createSheetTable();
        
    }
    //MARK: - --------------private---------------
    private func createBillTable(){
        let sql = "CREATE TABLE IF NOT EXISTS XF_BillTable(" +
            "billID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT," +
            "billName TEXT," +
            "billType INTEGER," +
            "billPeople INTEGER" +
            ");"
        
        // db表示一个数据库
        dbQueue.inDatabase { (db) -> Void in
            
            // 执行sql语句，创建一张表。返回Bool类型是否创建成功
            if db.executeStatements(sql) {
                print("BillTable建表成功")
            } else {
                print("BillTable建表失败")
            }
        }
}
    
    private func createSheetTable(){
        let sql = "CREATE TABLE IF NOT EXISTS XF_SheetTable(" +
            "id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT," +
            "billID INTEGER," +
            "sheetID INTEGER," +
            "timeInterval TEXT" +
            "sheetRemark TEXT," +
            "sheetType INTEGER," +
            "sheetMoney REAL" +
            ");"

        // db表示一个数据库
        dbQueue.inDatabase { (db) -> Void in
            // 执行sql语句，创建一张表。返回Bool类型是否创建成功
            if db.executeStatements(sql) {
                print("SheetTable建表成功")
            } else {
                print("SheetTable建表失败")
            }
        }
    }
    //MARK: - --------------pubilic---------------
    
    //MARK: =========delete==========
    /// 删除表
    ///
    /// - Parameter type: 表类型
    /// - Returns: 是否执行成功
    func dropTable(type:TableType) -> Bool {
        var tbName = String();
        switch type {
        case .billType:
            tbName = "XF_BillTable";
            break;
        case .sheetType:
            tbName = "XF_SheetTable";
            break;
        }
        
        let sql = "DROP TABLE \(tbName);";
        var flag = false;
        dbQueue.inDatabase { (db) -> Void in
            if db.executeStatements(sql){
                flag = true;
            }else{
                flag = false;
            }
        }
        return flag;
    }
    
    func deleteBillByBillID(billID:NSInteger) -> Bool {
        var flag = false;
        let sqlB = "DELETE FROM XF_BillTable WHERE billID = ?"
        let sqlS = "DELETE FROM XF_SheetTable WHERE billID = ?"
        //删除账本
        dbQueue.inDatabase{ (db) -> Void in
            if db.executeUpdate(sqlB, withArgumentsIn: [String(billID)]){
                flag = true;
            }else{
                flag = false;
            }
        }
        //删除账本对应的所有账单
        dbQueue.inDatabase{ (db) -> Void in
            if db.executeUpdate(sqlS, withArgumentsIn: [String(billID)]){
                flag = true;
            }else{
                flag = false;
            }
        }
        return flag;
    }
    
    func deleteASheetBySheetID(sheetID:NSInteger) -> Bool {
        var flag = false;
        let sql = "DELETE FROM XF_SheetTable WHERE sheetID = ?"
        //删除账单
        dbQueue.inDatabase{ (db) -> Void in
            if db.executeUpdate(sql, withArgumentsIn: [String(sheetID)]){
                flag = true;
            }else{
                flag = false;
            }
        }
        return flag;
    }

    //MARK: =========add==========
    func insertDataToBillTable(billModel:XFBillCellModel) -> Bool {
        var flag = false;
        let sql = "INSERT INTO XF_BillTable(billName,billType,billPeople) VALUES(?,?,?);"
        //获取类型
        let type:Int = billModel.billType.rawValue;
        let arr:[AnyObject] = [billModel.billName as AnyObject,type as AnyObject,billModel.billPeople as AnyObject];
        
        dbQueue.inDatabase { (db) -> Void in
            if  db.executeUpdate(sql, withArgumentsIn: arr){
                flag = true;
            }else{
                flag = false;
            }
        }
        return flag;
    }

    func insertDataToSheetTable(sheetModel:XFBillSheetModel) -> Bool {
        var flag = false;
        let sql = "INSERT INTO XF_BillTable(billID,sheetID,timeInterval,sheetType,sheetMoney,sheetRemark) VALUES(?,?,?,?,?,?);"
        //获取类型
        let type:Int = sheetModel.sheetType.rawValue;
        let arr:[AnyObject] = [sheetModel.billID as AnyObject,sheetModel.sheetID as AnyObject,sheetModel.timeInterval as AnyObject,type as AnyObject,sheetModel.sheetMoney as AnyObject,sheetModel.sheetRemark as AnyObject];
        dbQueue.inDatabase { (db) -> Void in
            if  db.executeUpdate(sql, withArgumentsIn: arr){
                flag = true;
            }else{
                flag = false;
            }
        }
        return flag;
    }
    
    //MARK: =========query==========
    func queryRecordByIDFromBillTable(billID:Int) -> [XFBillCellModel]? {
        let sql = "SELECT * FROM XF_BillTable WHERE billID = ?";
        var rsArr = [XFBillCellModel]();
        dbQueue.inDatabase { (db) ->Void in
            if let rs = db.executeQuery(sql, withArgumentsIn:[String(billID)]){
                while(rs.next()){
                    let model =  XFBillCellModel();
                    model.billID = Int(rs.int(forColumn: "billID"));
                    model.billName = rs.string(forColumn: "billName");
                    model.billPeople = Int(rs.int(forColumn: "billPeople"));
                    model.billType = BillType(rawValue: Int(rs.int(forColumn: "billType")))!;
                    rsArr.append(model);
                }
            }else{
                print("查找错误");
            }
        }
        if rsArr.count == 0 {
            return nil;
        }
        return rsArr;
    }
    
    func queryRecordByIDFromSheetTable(sheetID:Int) -> [XFBillSheetModel]? {
        let sql = "SELECT * FROM XF_BillTable WHERE sheetID = ?";
        var rsArr = [XFBillSheetModel]();
        dbQueue.inDatabase { (db) ->Void in
            if let rs = db.executeQuery(sql, withArgumentsIn:[String(sheetID)]){
                while(rs.next()){
                    let model =  XFBillSheetModel();
                    model.billID = Int(rs.int(forColumn: "billID"));
                    model.sheetID = Int(rs.string(forColumn: "sheetID"))!;
                    model.sheetType = SheetType(rawValue: Int(rs.int(forColumn: "sheetType")))!;
                    model.sheetMoney = Float(rs.double(forColumn: "sheetMoney"));
                    model.sheetRemark = rs.string(forColumn: "sheetRemark");
                    model.timeInterval = rs.string(forColumn: "timeInterval");
                    rsArr.append(model);
                }
            }else{
                print("查找错误");
            }
        }
        if rsArr.count == 0 {
            return nil;
        }
        return rsArr;
    }

}
