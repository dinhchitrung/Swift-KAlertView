//
//  KAlertView.swift
//  KAlertView
//
//  Created by JVN on 7/28/15.
//  Copyright (c) 2015 Jana. All rights reserved.
//
var DEFAULT_ALERT_WIDTH: CGFloat = 270.0
var DEFAULT_ALERT_HEIGHT: CGFloat = 144.0
var GET_WIDTH: CGFloat = 0.0
var GET_HEIGHT: CGFloat = 0.0


import UIKit

class KAlertView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var delegate: KAlertViewDelegate?
    var container: UIView = UIView()
    var cancelButton: UIButton = UIButton()
    var otherButton: UIButton = UIButton()
    
    var verticalSeparator: UIView = UIView()
    var horizontalSeparator: UIView = UIView()
    
    var title: String?
    var message: String?
    var cancelButtonTitle: String?
    var otherButtonTitle: String?
    
    //Default Frame
    var heightButtonAlert: CGFloat = 44
    var heightTitleAlert: CGFloat = 34
    var titleTopPadding: CGFloat = 14
    var titleBottomPadding: CGFloat = 2
    var messageBottomPadding: CGFloat = 20
    var messageLeftRightPadding: CGFloat = 20
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: GET_WIDTH, height: GET_HEIGHT))
    }
    
    init(title: String?, message: String?, delegate: KAlertViewDelegate?, cancelButtonTitle: String?) {
        GET_WIDTH = UIScreen.mainScreen().bounds.size.width
        GET_HEIGHT = UIScreen.mainScreen().bounds.size.height
        
        super.init(frame: CGRect(x: 0, y: 0, width: GET_WIDTH, height: GET_HEIGHT))
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.delegate = delegate
        
        self.title = title
        self.message = message
        self.cancelButtonTitle = cancelButtonTitle
        self.otherButtonTitle = nil
        
        calculateFrame()
    }
    
    init(title: String?, message: String?, delegate: KAlertViewDelegate?, cancelButtonTitle: String?, otherButtonTitle: String?) {
        GET_WIDTH = UIScreen.mainScreen().bounds.size.width
        GET_HEIGHT = UIScreen.mainScreen().bounds.size.height
        
        super.init(frame: CGRect(x: 0, y: 0, width: GET_WIDTH, height: GET_HEIGHT))
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.delegate = delegate
        
        self.title = title
        self.message = message
        self.cancelButtonTitle = cancelButtonTitle
        self.otherButtonTitle = otherButtonTitle
        
        calculateFrame()
    }
    
    func calculateFrame() {
        container.frame = CGRectMake(GET_WIDTH/2 - DEFAULT_ALERT_WIDTH/2, GET_HEIGHT/2 - DEFAULT_ALERT_HEIGHT/2, DEFAULT_ALERT_WIDTH, DEFAULT_ALERT_HEIGHT)
        container.backgroundColor = UIColor.whiteColor()
        container.layer.cornerRadius = 8
        self.addSubview(container)
        
        if (otherButtonTitle == nil) {
            //Setup "Cancel" Button
            cancelButton.frame = CGRectMake(0, DEFAULT_ALERT_HEIGHT - heightButtonAlert, DEFAULT_ALERT_WIDTH, heightButtonAlert)
            cancelButton.setTitle(cancelButtonTitle, forState: UIControlState.Normal)
            cancelButton.setTitleColor(UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1), forState: UIControlState.Normal)
            cancelButton.addTarget(self.delegate, action: "KAlertViewClickCancelButton", forControlEvents: UIControlEvents.TouchUpInside)
            cancelButton.addTarget(self, action: "dismiss", forControlEvents: UIControlEvents.TouchUpInside)
            container.addSubview(cancelButton)
            //Setup "verticalSeparator" View
            verticalSeparator.frame = CGRectMake(0, DEFAULT_ALERT_HEIGHT - cancelButton.bounds.size.height, DEFAULT_ALERT_WIDTH, 1)
            verticalSeparator.backgroundColor = UIColor(red: 196/255, green: 196/255, blue: 201/255, alpha: 0.5)
            container.addSubview(verticalSeparator)
        } else {
            println("Double button")
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal func showInView(view: UIView) {
        view.addSubview(self)
        self.backgroundColor = UIColor(white: 0.5, alpha: 0)
        self.container.backgroundColor = UIColor(white: 1, alpha: 0)
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.container.backgroundColor = UIColor(white: 1, alpha: 1)
            self.backgroundColor = UIColor(white: 0.5, alpha: 1)
            self.container.layer.opacity = 1
            self.container.layer.transform = CATransform3DMakeScale(1, 1, 1)
            }, completion: { (finished: Bool) in
                
        })
    }
    
    internal func show() {
        let window = (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController?.view
        self.showInView(window!)
    }
    
    internal func dismiss() {
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.backgroundColor = UIColor(white: 0, alpha: 0)
            self.container.layer.transform = CATransform3DConcat(self.container.layer.transform, CATransform3DMakeScale(0.6, 0.6, 1))
            self.container.layer.opacity = 0
            }, completion: { (finished: Bool) in
                self.removeFromSuperview()
        })
    }
    
    internal func setContentView(view: UIView) {
        self.container.removeFromSuperview()
        self.container = view
        self.container.frame = CGRectMake(GET_WIDTH/2 - self.container.bounds.size.width/2, GET_HEIGHT/2 - self.container.bounds.size.height/2, self.container.bounds.size.width, self.container.bounds.size.height)
        self.addSubview(self.container)
    }
}

@objc protocol KAlertViewDelegate : NSObjectProtocol {
    @objc optional func KAlertViewClickCancelButton()
    @objc optional func KAlertViewClickOtherButton()
}

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}