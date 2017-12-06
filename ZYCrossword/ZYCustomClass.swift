//
//  ZYCustomClass.swift
//  ZYFastApp
//
//  Created by MAC on 16/8/15.
//  Copyright © 2016年 TongBuWeiYe. All rights reserved.
//

import UIKit
import Material

//MARK: - 宏定义
let screenHeight = UIScreen.main.bounds.height
let screenWidth = UIScreen.main.bounds.width

let chessboardColumns: Int = { () -> Int in
    return Int((screenWidth - 44) / 33)
}()
var chessboardEmptySymbol = "-"
let chessboardDocumentPath = "Chessboard.plist"
let coinCountKey = "coinCountChangeNotificationCenterKey"
let userInfoKey = "userInfoUserDefultKey"
let unlockedKey = "unlockedCountDefultKey"
let themeKey = "themeDefultKey"

class ZYCustomClass: NSObject {
    static let shareCustom = ZYCustomClass()
    fileprivate override init() { }
    
    func showSnackbar(with text: String, snackbarController: SnackbarController?) {
        guard let snack = snackbarController else {
            return
        }
        snack.snackbar.text = text
        _ = snack.animate(snackbar: .visible)
        _ = snack.animate(snackbar: .hidden, delay: 4)
    }
}
//MARK: - 字符串的扩展
extension String {
    func rangeFromNSRange(_ nsRange : NSRange) -> Range<String.Index>? {
        if let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex) {
            if let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex) {
                if let from = String.Index(from16, within: self),
                    let to = String.Index(to16, within: self) {
                    return from ..< to
                }
            }
        }
        return nil
    }
    func textHeightWithFont(_ font: UIFont, constrainedToSize size:CGSize) -> CGFloat {
        var textSize:CGSize!
        if size.equalTo(CGSize.zero) {
            let attributes = [NSAttributedStringKey.font: font]
            textSize = self.size(withAttributes: attributes)
        } else {
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let attributes = [NSAttributedStringKey.font: font]
            let stringRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
            textSize = stringRect.size
        }
        return textSize.height + 2
    }
    func getFilePath() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let DBPath = (documentPath as NSString).appendingPathComponent(self)
        return DBPath
    }
    func showContentString(with contentString: String, typeString: String) -> String {
        var replaceString = ""
        for _ in 0 ..< self.count {
            replaceString += "_ "
        }
        return contentString.replacingOccurrences(of: self, with: replaceString) + "\n----" + typeString
    }
}
//MARK: - Array的扩展
extension Array where Element: Equatable {
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
//MARK: - View的扩展
extension UIView {
    func setAmphitheatral(cornerRadius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
    }
    func takeSnapshot(with fram: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 1)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage(cgImage: img!.cgImage!.cropping(to: frame)!)
    }
}
//MARK: - HexColor的扩展
extension UIColor {
    public convenience init(_ value: Int) {
        let components = UIColor.getColorComponents(value)
        self.init(red: components.red, green: components.green, blue: components.blue, alpha: 1.0)
    }
    public convenience init(_ value: Int, alpha: CGFloat) {
        let components = UIColor.getColorComponents(value)
        self.init(red: components.red, green: components.green, blue: components.blue, alpha: alpha)
    }
    public func alpha(_ value: CGFloat) -> UIKit.UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIKit.UIColor(red: red, green: green, blue: blue, alpha: value)
    }
    private static func getColorComponents(_ value: Int) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let r = CGFloat(value >> 16 & 0xFF) / 255.0
        let g = CGFloat(value >> 8 & 0xFF) / 255.0
        let b = CGFloat(value & 0xFF) / 255.0
        return (r, g, b)
    }
}
enum ZYCustomColor: Int {//特定色值
    case buttonTittleGray = 0x7a7a7a
    case buttonTittleRed = 0xFF7070
    case buttonSelectedGray = 0xD8D8D8
    case textBlack = 0x3E3E3E
    case textGray = 0xC1C1C1
}
