//
//  UIImage+ZeroExtension.swift
//  ZeroKit
//
//  Created by zhangzhao on 2022/6/22.
//

import UIKit

extension UIImage {
    
    public enum GradientDirection {
        case horizontal
        case vertical
    }
    
    public convenience init?(
        linearGradient colors: [CGColor],
        drawDirection: GradientDirection,
        size: CGSize,
        roundedCorner: CGFloat? = nil)
    {
        UIGraphicsBeginImageContextWithOptions(size, roundedCorner == nil ? true : false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let ctx = UIGraphicsGetCurrentContext(),
              let gradient = CGGradient(colorsSpace: nil, colors: colors as CFArray, locations: nil)
        else {
            return nil
        }
        if let corner = roundedCorner {
            ctx.addPath(UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: corner).cgPath)
            ctx.clip()
        }
        switch drawDirection {
        case .horizontal:
            ctx.drawLinearGradient(gradient, start: CGPoint(x: 0, y: size.height / 2), end: CGPoint(x: size.width, y: size.height / 2), options: [])
        case .vertical:
            ctx.drawLinearGradient(gradient, start: CGPoint(x: size.width / 2, y: 0), end: CGPoint(x: size.width / 2, y: size.height), options: [])
        }
        guard let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
