//
//  UIColor+ZeroExtension.swift
//  ZeroKit
//
//  Created by zhangzhao on 2022/6/22.
//

import UIKit

extension UIColor {
    
    public convenience init(_ hexValue: Int, alpha: CGFloat = 1.0) {
        let redValue   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        let greenValue = CGFloat((hexValue & 0xFF00) >> 8) / 255.0
        let blueValue  = CGFloat(hexValue & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
    }
    
    public static func hex(_ hexValue: Int, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(hexValue, alpha: alpha)
    }
    
    public convenience init(_ hexString: String, alpha: CGFloat = 1.0) {
        var result: UInt32 = 0
        var hex = hexString
        if hexString.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }
        Scanner(string: "0x" + hex).scanHexInt32(&result)
        self.init(Int(result))
    }
    
    public var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        if !getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            getWhite(&red, alpha: &alpha)
            green = red
            blue = red
        }
        
        red = round(red * 255)
        green = round(green * 255)
        blue = round(blue * 255)
        alpha = round(alpha * 255)
        
        let hex: UInt = (UInt(red) << 24) | (UInt(green) << 16) | (UInt(blue) << 8) | UInt(alpha)
        
        return String(format: "#%08x", hex)
    }
}
