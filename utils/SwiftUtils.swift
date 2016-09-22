//
//  SwiftUtils.swift
//  Soho
//
//  Created by renanvs on 11/3/15.
//  Copyright © 2015 lookr. All rights reserved.
//

import UIKit
import Foundation

infix operator ~>
prefix operator ~>>

private let queue = DispatchQueue(label: "serial-worker", attributes: [])

func ~> (
    backgroundClosure:  @escaping () -> (),
    mainClosure:        @escaping () -> ()){
        queue.async { () -> Void in
            backgroundClosure()
            DispatchQueue.main.async(execute: mainClosure)
        }
}


prefix func ~>> (mainClosure: @escaping () -> ()){
    DispatchQueue.main.async(execute: mainClosure)
}



class SwiftUtils: NSObject {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
        //return TARGET_IPHONE_SIMULATOR != 0 // Use this line in Xcode 6
    }

    class func convertDeviceTokenToString(_ deviceToken:Data) -> String {
        //  Convert binary Device Token to a String (and remove the <,> and white space charaters).
        var deviceTokenStr = deviceToken.description.replacingOccurrences(of: ">", with: "")
        deviceTokenStr = deviceTokenStr.replacingOccurrences(of: "<", with: "")
        deviceTokenStr = deviceTokenStr.replacingOccurrences(of: " ", with: "")
        
        // Our API returns token in all uppercase, regardless how it was originally sent.
        // To make the two consistent, I am uppercasing the token string here.
        deviceTokenStr = deviceTokenStr.uppercased()
        return deviceTokenStr
    }
    
    class func postSimpleNotification(_ notification : String, object : AnyObject?){
        NotificationCenter.default.post(name: Notification.Name(rawValue: notification), object: object)
    }
    
    class func addSimpleNotification(_ object : AnyObject, selector : Selector, name : String){
        NotificationCenter.default.addObserver(object, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    class func classNameAsString(_ obj: Any) -> String {
        //prints more readable results for dictionaries, arrays, Int, etc
        
        //return String(obj.dynamicType).componentsSeparatedByString("__").last!
        let name = String(describing: type(of: (obj) as AnyObject))
        return name
    }
    
    class func getDayOfWeek(_ date:Date)->Int {
        let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let myComponents = (myCalendar as NSCalendar).components(.weekday, from: date)
        let weekDay = myComponents.weekday
        
        return weekDay!
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

extension UIScrollView{
        func scrollToTop() {
            let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
            setContentOffset(desiredOffset, animated: true)
        }
}

extension UITableViewCell {
    func clearColorCellAndContent(){
        self.clearColor()
        self.contentView.clearColor()
    }
    
    func setStyleToNone(){
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
}

extension UITextField {
    
    func addLeftPadding(_ value:Float){
        let view = UIView(frame: self.frame)
        view.setX(0)
        view.setY(0)
        view.setWidth(CGFloat(value))
        self.leftView = view
        self.leftViewMode = .always
    }
    
    func setPlaceHolderColor(_ color : UIColor){
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
    static func isEmptyStr(_ str : String?)->Bool{
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
    
    func NSStringDescription() -> NSString{
        return self as NSString
    }
}

extension UIImage{
    static func localPartialPath(_ partialPath : String?) -> UIImage?{
        if partialPath == nil{
            return nil
        }
        
        let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as AnyObject
        let destinationPath = documentsPath.appending(partialPath!)

        let data = try? Data(contentsOf: URL(fileURLWithPath: destinationPath as String))
        var image : UIImage?
        
        if let d = data {
            image = UIImage(data: d)
            return image
        }
        return image
    }
}

extension UIView{
    func viewWithUniqueTag(_ tagD : Int)->UIView?{
        for v in self.subviews{
            if v.tag == tagD{
                return v;
            }
        }
        
        return self.viewWithTag(tagD)
    }
    
    func removeLayerWithName(name : String){
        if self.layer.sublayers != nil{
            for l in self.layer.sublayers!{
                if l.name != nil && l.name == name{
                    l.removeFromSuperlayer()
                }
            }
        }
    }
    
    func addTopBorder(){
        
        self.removeLayerWithName(name: "top")
        
        let borderTest = CALayer()
        borderTest.name = "top"
        borderTest.backgroundColor = UIColor.black.cgColor
        borderTest.frame = CGRect(x: 0, y: 0, width: self.widthSize(), height: 1)
        self.layer.addSublayer(borderTest)
    }
    
    func addBottonBorder(){
        
        self.removeLayerWithName(name: "botton")
        
        let borderTest = CALayer()
        borderTest.name = "botton"
        borderTest.backgroundColor = UIColor.black.cgColor
        borderTest.frame = CGRect(x: 0, y: self.height() - 1, width: self.widthSize(), height: 1)
        self.layer.addSublayer(borderTest)
    }
    
    func addLeftBorder(){
        
        self.removeLayerWithName(name: "left")
        
        let borderTest = CALayer()
        borderTest.name = "left"
        borderTest.backgroundColor = UIColor.black.cgColor
        borderTest.frame = CGRect(x: 0, y: 0, width: 1, height: self.height())
        self.layer.addSublayer(borderTest)
    }
    
    func addRightBorder(){
        
        self.removeLayerWithName(name: "right")
        
        let borderTest = CALayer()
        borderTest.name = "right"
        borderTest.backgroundColor = UIColor.black.cgColor
        borderTest.frame = CGRect(x: self.widthSize() - 1, y: 0, width: 1, height: self.height())
        self.layer.addSublayer(borderTest)
    }
}

extension UIViewController{
    func removeAllNotificationObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    func addSimpleObserver(_ name : String, selectorName : String){
        NotificationCenter.default.addObserver(self, selector: Selector(selectorName), name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    func presentDefault(_ vc : UIViewController){
        self.present(vc, animated: true, completion: nil)
    }
}

extension UIButton{
    func setImageByNameInNormalState(_ imageName : String){
        let image = UIImage(named:imageName)
        self.setImage(image, for: UIControlState())
    }
}

extension NSMutableDictionary{
    func setSafeString(_ value : String?, forKey: String){
        if String.isEmptyStr(value){
            self.setObject("", forKey: forKey as NSCopying)
        }else{
            self.setObject(value!, forKey: forKey as NSCopying)
        }
    }
    
    func setSafeNumber(_ value : NSNumber?, forKey: String){
        if value == nil{
            self.setObject(NSNumber(value: 0 as Int32), forKey: forKey as NSCopying)
        }else{
            self.setObject(value!, forKey: forKey as NSCopying)
        }
    }
}

extension NSDictionary{
    
    func JSON_String()-> String?{
        do{
            let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            return json

        }catch{
            return nil
        }
        
    }
}

