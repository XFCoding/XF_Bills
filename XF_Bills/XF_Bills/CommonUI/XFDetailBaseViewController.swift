//
//  XFDetailBaseViewController.swift
//  XF_Bills
//
//  Created by IAskSpace on 2017/6/2.
//  Copyright © 2017年 XFCoding. All rights reserved.
//

import UIKit

class XFDetailBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置背景颜色
        self.view.backgroundColor = UIColor.groupTableViewBackground;
        // Do any additional setup after loading the view.
        
        
        //设置返回按钮
        let btnSize:CGFloat = (UIImage.init(named: "detail_back")?.size.width)!;
        let margin:CGFloat = 25.0;
        
        let backBtn = UIButton.init(type: UIButtonType.custom);
        backBtn.setBackgroundImage(UIImage.init(named: "detail_back"), for: UIControlState.normal);
        backBtn.frame = CGRect.init(x: SCREEN_WIDTH - btnSize - margin, y: SCREEN_HEIGHT - btnSize - margin, width: btnSize, height: btnSize);
        backBtn.addTarget(self, action: #selector(XFDetailBaseViewController.clickBackBtn), for: UIControlEvents.touchUpInside);
        self.view.addSubview(backBtn);
    }
    
    
    @objc private func clickBackBtn(){
        self.navigationController?.dismiss(animated: true, completion: {
        });
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
