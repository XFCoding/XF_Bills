//
//  ViewController.swift
//  XF_Bills
//
//  Created by IAskSpace on 2017/5/19.
//  Copyright © 2017年 XFCoding. All rights reserved.
//

import UIKit
import Toaster

class XFBillViewController: UIViewController {
    
    //MARK: - --------------properties---------------
    /// 保存账本cell
    var cellArr         = [XFBillCellView]();
    /// 保存账本model
    var cellModelArr    = [XFBillCellModel]();
    /// 每个cell的frame
    var cellFrameArr    = [CGRect]();
    
    ///记录选择的操作cellIndex
    var selectedCellIndex:Int = 0;
    
    
    //MARK: - -----------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.groupTableViewBackground;
        
        
        for i:Int in 0...4 {
            let model = XFBillCellModel();
            model.billID = i;
            model.billPeople = i;
            model.billName = "first\(i)";
            model.billType = BillType.single;
            cellModelArr.append(model);
        }
        setBaseUI();
        
//        let sqlManager = XFSqliteManager.shareManager;
//        let model = XFBillCellModel();
//        model.billID = 1;
//        model.billPeople = 1;
//        model.billName = "first";
//        model.billType = BillType.single;
//        
//        let success = sqlManager.insertDataToBillTable(billModel: model);
//        if success {
//            print("success");
//        }else{
//            print("oops~");
//        }
        
//        sqlManager.dropTable(type: XFSqliteManager.TableType.billType);
//        sqlManager.dropTable(type: XFSqliteManager.TableType.sheetType);
    }
    
    //MARK: - --------------setUI---------------
    func setBaseUI(){
        let imageSize = UIImage.init(named: "menu_cell_add")!.size;
        
        for i:Int in 0...cellModelArr.count {
            let billCell = XFBillCellView.instanceFromNib();
            billCell.tag = 100 + i;
            /// 取商判断是第几行
            let over3 = i/3;
            /// 取余判断是第几列
            let remian3 = i%3;
            /// 计算宽高
            let cell_size:(sizeW:CGFloat,sizeH:CGFloat) = (imageSize.width*FIT_WIDTH,imageSize.height*FIT_HEIGHT);
            /// 记录算出的坐标
            let (originX,originY) = billCell.getCellOrigin_x_y(row: over3, colum: remian3,size: cell_size);
            /// 点击手势
            billCell.isUserInteractionEnabled = true;
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(XFBillViewController.clickCell(sender:)));
            billCell.addGestureRecognizer(tap);
            if i !=  cellModelArr.count{
                /// 长按删除手势
                let longPressGes = UILongPressGestureRecognizer.init(target: self, action: #selector(XFBillViewController.longPressCell(sender:)));
                billCell.addGestureRecognizer(longPressGes);
            }else{
                billCell.setHideLabelStyle();
            }

            billCell.frame = CGRect.init(origin: CGPoint.init(x: originX, y: originY), size: CGSize.init(width: imageSize.width*FIT_WIDTH, height: imageSize.height*FIT_HEIGHT));
            cellFrameArr.append(billCell.frame);
            cellArr.append(billCell);
            self.view.addSubview(billCell);
        }
    }
    //MARK: - --------------private---------------
    //长按
    @objc private func longPressCell(sender:UILongPressGestureRecognizer){
        print("长按tag:\(String(describing: sender.view?.tag))");
        self.selectedCellIndex = sender.view!.tag - 100;
        showDeleteBillCellAlret();
        
    }
    //点击
    @objc private func clickCell(sender:UITapGestureRecognizer){
        if cellArr.count > 0 {
            print("get a tap");
            print("tag:\(String(describing: sender.view?.tag))");
            let tempFlag = (sender.view?.tag)! - 100;
            if tempFlag + 1 == cellArr.count {//最后一个元素说明要添加账本
                self.addBillAction();
            }else{//进入账本
                let billDetailVC = XFBillDetailViewController();
                let detailNavi = XFBaseNavigationController();
                detailNavi.viewControllers = [billDetailVC];
                self.navigationController?.present(detailNavi, animated: true, completion: {
                });
            }
        }
    }
    
    /// 添加cell操作
    private func addBillAction() -> Void {
        let addView = XFAddBillView.instanceFromNib();
        addView.showAddBillView();
        weak var weakAddView = addView;
        //添加账本回调
        addView.returnBlock = {
            (info)->Void in
            weakAddView?.hideAddBillView();
            if info != nil{
                let (name,people,type) = info!;
                print("\nname:\(name)\npeople:\(people)\n\(type)\n");
                self.addANewCellWith(index: self.cellArr.count);
            }else{
                print("点击了取消");
            }
        };
    }
    
    /// 删除cell操作
    private func showDeleteBillCellAlret()->Void {
        let alertVC         = UIAlertController.init(title: nil, message: "确定删除该账单？", preferredStyle: UIAlertControllerStyle.actionSheet);
        let cancelAction    = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel);
        let okAction        = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.destructive){ (action:UIAlertAction) in
            let cell = self.cellArr[self.selectedCellIndex];
            cell.removeFromSuperview();
            self.cellArr.remove(at: self.selectedCellIndex);
            self.cellModelArr.remove(at: self.selectedCellIndex);
            self.cellFrameArr.removeLast();
            self.updateSubViews();
        };
        alertVC.addAction(cancelAction);
        alertVC.addAction(okAction);
        self.present(alertVC, animated: true);
    }
    
    /// 更新UI
    private func updateSubViews()->Void {
        if self.cellArr.count == self.cellModelArr.count + 1  && self.cellArr.count == self.cellFrameArr.count{
            for i:Int in self.selectedCellIndex..<self.cellFrameArr.count {
                let cell = cellArr[i];
                cell.tag = cell.tag - 1;
                UIView.animate(withDuration: 0.2, animations: {
                    cell.frame = self.cellFrameArr[i];
                })
            };
        }else{
            print("数据错误，model和cell对不上");
        }
    }
    
    private func addANewCellWith(index:Int)->Void {
        
        if index > 5 {
             Toast.init(text: "您最多可以拥有六个账本~").show();
            
            return;
        }
        
        let model = XFBillCellModel();
        model.billID = index;
        model.billPeople = index;
        model.billName = "first\(index)";
        model.billType = BillType.single;
        cellModelArr.append(model);
        
        
        let imageSize = UIImage.init(named: "menu_cell_add")!.size;
        let billCell = XFBillCellView.instanceFromNib();
        billCell.tag = 100 + index;
        /// 取商判断是第几行
        let over3 = index/3;
        /// 取余判断是第几列
        let remian3 = index%3;
        /// 计算宽高
        let cell_size:(sizeW:CGFloat,sizeH:CGFloat) = (imageSize.width*FIT_WIDTH,imageSize.height*FIT_HEIGHT);
        /// 记录算出的坐标
        let (originX,originY) = billCell.getCellOrigin_x_y(row: over3, colum: remian3,size: cell_size);
        /// 计算坐标存储
        let tempRect = CGRect.init(x: originX, y: originY, width: cell_size.sizeW, height: cell_size.sizeH);
        billCell.frame = cellFrameArr.last!;
        selectedCellIndex = index;
        cellArr.insert(billCell, at: index-1);
        cellFrameArr.append(tempRect);
        self.view.addSubview(billCell)
        self.updateSubViews();
    }

    //MARK: - --------------didReceiveMemoryWarning---------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

