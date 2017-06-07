//
//  XFBillCellView.swift
//  XF_Bills
//
//  Created by IAskSpace on 2017/5/19.
//  Copyright © 2017年 XFCoding. All rights reserved.
//

import UIKit

class XFBillCellView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //账本名称
    @IBOutlet weak var billTitleLab: UILabel!
    //账目条数
    @IBOutlet weak var sheetCountLab: UILabel!
    
    
    class func instanceFromNib()->XFBillCellView {
        return UINib(nibName: "XFBillCellView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! XFBillCellView;
    }
    
    /// 计算账本cell的坐标原点
    ///
    /// - Parameters:
    ///   - row:    行（0：第一行，1：第二行，2：第二行。。。。。）
    ///   - colum:  列（0：第一列，1：第一列，2：第三列）
    ///   - size:   cell的宽高
    /// - Returns:  坐标（x,y）
    public func getCellOrigin_x_y(row:NSInteger,colum:NSInteger,size:(sizeW:CGFloat,sizeH:CGFloat)) -> (x:CGFloat,y:CGFloat) {
        var o_x:CGFloat = 0.0;
        var o_y:CGFloat = 0.0;
        
        switch colum {
        case 0://第一列
            o_x = (SCREEN_WIDTH/2.0 - size.sizeW/2.0)/2.0 - size.sizeW/2.0;
            break;
        case 1://第二列
            o_x = SCREEN_WIDTH/2.0 - size.sizeW/2.0;
            break;
        case 2://第三列
            o_x =  (SCREEN_WIDTH/2.0 - size.sizeW/2.0)/2.0 + SCREEN_WIDTH/2.0;
            break;
        default:
            break;
        }
        
        /// 间距 （第二列的最小x - 第一列的最大x）
        let margin = (SCREEN_WIDTH/2.0 - size.sizeW/2.0) - ((SCREEN_WIDTH/2.0 - size.sizeW/2.0)/2.0 + size.sizeW/2.0)
        o_y = SCREEN_HEIGHT/2.0 - size.sizeH/2.0 + (size.sizeH + margin) * CGFloat(row);
        
        return (o_x,o_y);
    }
    
    /// 设置为添加账本的样式
    public func setHideLabelStyle()->Void {
        self.billTitleLab.alpha = 0;
        self.sheetCountLab.alpha = 0;
    }
}
