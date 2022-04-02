//
//  UIImage+MMExtension.swift
//  MMUIKit
//
//  Created by Mingle on 2022/3/5.
//

import UIKit

public extension UIImage {
    
    static func byColor(_ colorStr: String, _ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return byColor(UIColor(colorStr), size)
    }
    
    static func byColor(_ color: UIColor, _ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
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
