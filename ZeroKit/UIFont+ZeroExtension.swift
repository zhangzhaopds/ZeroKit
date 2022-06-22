//
//  UIFont+ZeroExtension.swift
//  ZeroKit
//
//  Created by zhangzhao on 2022/6/22.
//

import UIKit

extension UIFont {
    
    /// "PingFangSC-Regular"
    public static func regularFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    /// "PingFangSC-Medium"
    public static func mediumFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    /// "PingFangSC-Semibold"
    public static func semiboldFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Semibold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
    }
}
