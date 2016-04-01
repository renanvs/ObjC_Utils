//
//  SwiftUtils.swift
//  Soho
//
//  Created by renanvs on 11/3/15.
//  Copyright © 2015 lookr. All rights reserved.
//

import UIKit
import Foundation

infix operator ~>{}

private let queue = dispatch_queue_create("serial-worker", DISPATCH_QUEUE_SERIAL)

func ~> (
    backgroundClosure:  () -> (),
    mainClosure:        () -> ()){
        dispatch_async(queue) { () -> Void in
            backgroundClosure()
            dispatch_async(dispatch_get_main_queue(), mainClosure)
        }
}

class SwiftUtils: NSObject {

    class func convertDeviceTokenToString(deviceToken:NSData) -> String {
        //  Convert binary Device Token to a String (and remove the <,> and white space charaters).
        var deviceTokenStr = deviceToken.description.stringByReplacingOccurrencesOfString(">", withString: "")
        deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString("<", withString: "")
        deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        // Our API returns token in all uppercase, regardless how it was originally sent.
        // To make the two consistent, I am uppercasing the token string here.
        deviceTokenStr = deviceTokenStr.uppercaseString
        return deviceTokenStr
    }
    
    class func postSimpleNotification(notification : String, object : AnyObject?){
        NSNotificationCenter.defaultCenter().postNotificationName(notification, object: object)
    }
    
    class func addSimpleNotification(object : AnyObject, selector : Selector, name : String){
        NSNotificationCenter.defaultCenter().addObserver(object, selector: selector, name: name, object: nil)
    }
    
    class func classNameAsString(obj: Any) -> String {
        //prints more readable results for dictionaries, arrays, Int, etc
        
        //return String(obj.dynamicType).componentsSeparatedByString("__").last!
        let name = String(obj.dynamicType)
        return name
    }
}

#if os(iOS)

extension UIWebView {
    func disableBounces(){
        for view in self.subviews{
            if let v = view as? UIScrollView{
                v.bounces = false
            }
        }
    }
}

extension UITableViewCell {
    func clearColorCellAndContent(){
        self.clearColor()
        self.contentView.clearColor()
    }
    
    func setStyleToNone(){
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
}

extension UITextField {
    func addLeftPadding(value:Float){
        let view = UIView(frame: self.frame)
        view.setX(0)
        view.setY(0)
        view.setWidth(CGFloat(value))
        self.leftView = view
        self.leftViewMode = .Always
    }
    
    func setPlaceHolderColor(color : UIColor){
        if self.placeholder != nil{
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSForegroundColorAttributeName: color])
        }
    }
    
    func safeText() -> String{
        if String.isEmptyStr(self.text){
            return ""
        }
        
        return self.text!
    }
}
    
#endif

extension String {
    static func isEmptyStr(str : String?)->Bool{
        if let s = str{
            if let ss = s as String?{
                if ss.isEmpty == false{
                    return false
                }
            }
        }
        
        return true
    }
    
    func integerValue() -> Int{
        return (self as NSString).integerValue
    }
    
    func intValue() -> Int32{
        return (self as NSString).intValue
    }
    
    func floatValue() -> Float{
        return (self as NSString).floatValue
    }
}

extension UIImage{
    static func localPartialPath(partialPath : String?) -> UIImage?{
        if partialPath == nil{
            return nil
        }
        
        let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
        let destinationPath:NSString = documentsPath.stringByAppendingString(partialPath!)

        let data = NSData(contentsOfFile: destinationPath as String)
        var image : UIImage?
        
        if let d = data {
            image = UIImage(data: d)
            return image
        }
        return image
    }
}

extension UIView{
    func viewWithUniqueTag(tagD : Int)->UIView?{
        for v in self.subviews{
            if v.tag == tagD{
                return v;
            }
        }
        
        return self.viewWithTag(tagD)
    }
}

extension UIViewController{
    func removeAllNotificationObservers(){
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func addSimpleObserver(name : String, selectorName : String){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(selectorName), name: name, object: nil)
    }
}

extension UIButton{
    func setImageByNameInNormalState(imageName : String){
        let image = UIImage(named:imageName)
        self.setImage(image, forState: .Normal)
    }
}


