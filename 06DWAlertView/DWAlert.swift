//
//  DWAlert.swift
//  DWAlert
//
//  Created by apple on 17/5/17.
//  Copyright © 2017年 DWade. All rights reserved.
//

import UIKit

class DWAlert: UIView {

//const 常量
let kAlertWidth = 245.0
let kAlertHeight = 160.0
let kTitleYOffset = 15.0
let kTitleHeight = 25.0

let kContentOffset = 30.0
let kBetweenLabelOffset = 20.0
let kSingleButtonWidth = 160.0
let kCoupleButtonWidth = 107.0
let kButtonHeight = 40.0
let kButtonBottomOffset = 10.0

//property 属性
var alertTitleLabel: UILabel!
var alertContentLabel: UILabel!
var button: UIButton!
var backImageView: UIView!


    
     convenience init(alertTitle title: String, alertContent content: String, title Title: String) {

        
        self.init()
        self.layer.cornerRadius = 5.0
        self.backgroundColor = UIColor.white
        self.alertTitleLabel = UILabel.init(frame: CGRect(x: 0, y: kTitleYOffset, width: kAlertWidth, height: kTitleHeight))
        self.alertTitleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        self.alertTitleLabel.textColor = UIColor.init(red: 56.0/255.0, green: 64.0/255.0, blue: 71.0/255.0, alpha: 1)
        self.addSubview(self.alertTitleLabel)
        
        let contentLabelWidth = kAlertWidth - 16
        let alertContentMaxY: Double = Double(self.alertTitleLabel.frame.maxY)
        self.alertContentLabel = UILabel.init(frame: CGRect(x: (kAlertWidth - contentLabelWidth) * 0.5, y: alertContentMaxY, width: contentLabelWidth, height: 60))
        self.alertContentLabel.numberOfLines = 0
        
        self.alertTitleLabel.textAlignment = .center
        self.alertContentLabel.textAlignment = self.alertTitleLabel.textAlignment
        self.alertContentLabel.textColor = UIColor.init(red: 127/255.0, green: 127/255.0, blue: 127/255.0, alpha: 1)
        self.alertContentLabel.font = UIFont.systemFont(ofSize: 15.0)
        self.addSubview(self.alertContentLabel)
        
        // about button
        let btnFrame = CGRect(x: (kAlertWidth - kSingleButtonWidth) * 0.5, y: kAlertHeight - kButtonBottomOffset - kButtonHeight, width: kSingleButtonWidth, height: kButtonHeight)
        self.button = UIButton.init(type: UIButtonType.custom)
        self.button.frame = btnFrame
        
        self.button.backgroundColor = UIColor.init(red: 245/255.0, green: 24/255.0, blue: 42/255.0, alpha: 1)
        self.button.setTitle(Title, for: .normal)
        self.button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        self.button.setTitleColor(UIColor.white, for: .normal)
        self.button.addTarget(self, action: #selector(BtnClick), for: .touchUpInside)
        self.button.layer.cornerRadius = 3.0
        self.addSubview(self.button)
        
        self.alertTitleLabel.text = title
        self.alertContentLabel.text = content
        
        //cancle button
        let cancleBtn = UIButton.init(type: .custom)
        cancleBtn.setImage(UIImage.init(named: "1.png"), for: .normal)
        cancleBtn.setImage(UIImage.init(named: "2.png"), for: .highlighted)
        cancleBtn.frame = CGRect(x: kAlertWidth - 32, y: 0, width: 32, height: 32)
        self.addSubview(cancleBtn)
        cancleBtn.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)

    }
    
    

    func BtnClick() {
        dismissAlert()
    }
    
    func dismissAlert() {
        self.removeFromSuperview()
    }
    override func removeFromSuperview() {
        //1
        self.backImageView.removeFromSuperview()
        self.backImageView = nil
        
        //2
        let shareWindow = UIApplication.shared.keyWindow
        let afterFrame = CGRect(x: (Double((shareWindow?.bounds.width)!) - kAlertWidth)*0.5, y: Double((shareWindow?.bounds.height)!), width: kAlertWidth, height: kAlertHeight)
        
        //3
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseOut, animations: { 
            self.frame = afterFrame
            let angle = M_1_PI / 1.5
            self.transform = CGAffineTransform.init(rotationAngle: CGFloat(angle))
        }) { (finished) in
            //4
            super.removeFromSuperview()
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            return
        }
        let shareWindow = UIApplication.shared.keyWindow
        
        if self.backImageView == nil {
            self.backImageView = UIView.init(frame: (shareWindow?.bounds)!)
        }
        
        self.backImageView.backgroundColor = UIColor.black
        self.backImageView.alpha = 0.6
        shareWindow?.addSubview(self.backImageView)
        let angle = M_1_PI / 2
        self.transform = CGAffineTransform.init(rotationAngle: CGFloat(angle))
        let afterFrame = CGRect(x: (Double((shareWindow?.bounds.width)!) - kAlertWidth)*0.5, y: (Double((shareWindow?.bounds.height)!) - kAlertHeight)*0.5, width: kAlertWidth, height: kAlertHeight)
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform.init(rotationAngle: 0)
            self.frame = afterFrame
        }) { (finished) in
        }
        super.willMove(toSuperview: newSuperview)
    }
    
    func show() {
        let shareWindow = UIApplication.shared.keyWindow
        self.frame = CGRect(x: (Double((shareWindow?.bounds.width)!) - kAlertWidth)*0.5, y: -kAlertHeight - 30, width: kAlertWidth, height: kAlertHeight)
        shareWindow?.addSubview(self)
    }
}
