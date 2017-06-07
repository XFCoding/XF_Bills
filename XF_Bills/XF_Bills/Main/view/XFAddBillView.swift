//
//  XFAddBillView.swift
//  XF_Bills
//
//  Created by IAskSpace on 2017/6/1.
//  Copyright © 2017年 XFCoding. All rights reserved.
//

import UIKit
import Toaster

class XFAddBillView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //传参数block
    typealias getAReturnBlock = ((name:String,people:String,type:Int)?)->Void;
    
    var returnBlock:getAReturnBlock? = nil;
    
    let margin:CGFloat = 15.0;
    
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var billNameTF: UITextField!
    @IBOutlet weak var billPeopleTF: UITextField!
    @IBOutlet weak var billTypeSegCtrl: UISegmentedControl!
    
    var backImgVIew:UIImageView? = nil;
    
    class func instanceFromNib()->XFAddBillView{
        return UINib(nibName: "XFAddBillView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! XFAddBillView;
    }

    override func awakeFromNib() {
        let color = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 255/255.0, alpha: 1);
        self.cancelBtn.layer.borderColor = color.cgColor;
        self.confirmBtn.layer.borderColor = color.cgColor;
        self.billTypeSegCtrl.selectedSegmentIndex = 0;
        self.billPeopleTF.text = "1";
        self.billPeopleTF.isUserInteractionEnabled = false;
    }
    
    public func showAddBillView(){
        //背景
        let window:UIWindow = ((UIApplication.shared.delegate?.window)!)!;
        self.backImgVIew = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT));
        self.backImgVIew?.image = UIImage.init(named: "alpha");
        window.addSubview(backImgVIew!);
        //动画
        let keyBoardHeight:CGFloat = 252.0;
        self.frame = CGRect.init(x: self.margin, y: 0 - self.frame.size.height, width: SCREEN_WIDTH - 2.0*self.margin, height: self.frame.size.height);
        window.addSubview(self);
        UIView.animate(withDuration: 0.5) { 
            self.frame = CGRect.init(x: self.margin, y: SCREEN_HEIGHT - keyBoardHeight - 30.0 - self.frame.size.height, width: SCREEN_WIDTH - 2.0*self.margin, height: self.frame.size.height);
        };
    }
    
    public func hideAddBillView(){
        UIView.animate(withDuration: 0.3, animations: {
            self.frame =  CGRect.init(x: self.margin, y: 0 - self.frame.size.height, width: SCREEN_WIDTH - 2.0*self.margin, height: self.frame.size.height);
        }) { (true) in
            self.backImgVIew?.removeFromSuperview();
            self.removeFromSuperview();
        };
    }
    
    
    @IBAction func clickConfirmBtn(_ sender: UIButton) {
        if (billNameTF.text == nil) {
            print("账本名称不能为空");
            return;
        }
        if billTypeSegCtrl.selectedSegmentIndex == 1 && Int(billPeopleTF.text!)! <= 1 {
            print("多人账本人数必须在2人或者以上");
            Toast.init(text: "多人账本人数必须在2人或者以上").show();
            
            return;
        }
        
        if (self.returnBlock != nil) {
            self.returnBlock!((billNameTF.text!,billPeopleTF.text!,billTypeSegCtrl.selectedSegmentIndex));
        }
    }
    
    @IBAction func clickCancelBtn(_ sender: UIButton) {
        if (self.returnBlock != nil) {
            self.returnBlock!(nil);
        }
    }
    
    
    @IBAction func segChangedValue(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.billPeopleTF.text = "1";
            self.billPeopleTF.isUserInteractionEnabled = false;
        }else{
            self.billPeopleTF.text = nil;
            self.billPeopleTF.isUserInteractionEnabled = true;
        }
    }

}
