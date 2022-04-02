//
//  UIImage+MMExtension.swift
//  MMUIKit
//
//  Created by Mingle on 2022/3/5.
//

import UIKit

public extension UIImage {
    
    enum GradientType: Int {
        case topToBottom
        case leftToRight
        case leftTopToRightBottom
        case leftBottomToRightTop
    }
    
    static func byGradientColor(_ colors: [UIColor], size: CGSize, percentArray: [CGFloat]? = nil, gradientType: GradientType, cornerRadius: CGFloat = 0) -> UIImage? {
        let cgColors: [CGColor] = colors.map({ $0.cgColor })
        
        UIGraphicsBeginImageContextWithOptions(size, cornerRadius == 0, 1)
        let context = UIGraphicsGetCurrentContext()
        if cornerRadius != 0 {
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: cornerRadius)
            path.addClip()
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradientRef = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: percentArray)
        var start: CGPoint = .zero
        var end: CGPoint = .zero
        switch gradientType {
        case .topToBottom:
            start = CGPoint(x: size.width / 2, y: 0)
            end = CGPoint(x: size.width / 2, y: size.height)
            break
        case .leftToRight:
            start = CGPoint(x: 0, y: size.height / 2)
            end = CGPoint(x: size.width, y: size.height / 2)
            break
        case .leftTopToRightBottom:
            start = CGPoint(x: 0, y: 0)
            end = CGPoint(x: size.width, y: size.height)
            break
        case .leftBottomToRightTop:
            start = CGPoint(x: 0, y: size.height)
            end = CGPoint(x: size.width, y: 0)
            break
        }
        context?.drawLinearGradient(gradientRef!, start: start, end: end, options: .drawsBeforeStartLocation)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    static func byColor(_ colorStr: String, _ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return byColor(UIColor(colorStr), size)
    }
    
    static func byColor(_ color: UIColor, _ size: CGSize = CGSize(width: 1, height: 1), _ cornerRadius: CGFloat = 0) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        if cornerRadius != 0 {
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: cornerRadius)
            path.addClip()
        }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    static func byView(_ view: UIView, _ opaque: Bool = false) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.mSize, opaque, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        view.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
