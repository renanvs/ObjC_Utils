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