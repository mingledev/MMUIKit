//
//  UIColor+MMExtension.swift
//  MMUIKit
//
//  Created by Mingle on 2022/2/20.
//

import UIKit

public extension UIColor {
    
    convenience init(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat, _ a : CGFloat = 1) {
        let red = r / 255.0
        let green = g / 255.0
        let blue = b / 255.0
        self.init(red: red, green: green, blue: blue, alpha: a)
    }
    
    convenience init(_ color: String, _ alpha: CGFloat = 1) {
        var colorString = color.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if colorString.count < 6 {
            self.init()
        }
        
        if colorString.hasPrefix("0x") {
            colorString = (colorString as NSString).substring(from: 2)
        }
        if colorString.hasPrefix("#") {
            colorString = (colorString as NSString).substring(from: 1)
        }
        
        if colorString.count < 6 {
            self.init()
        }
        
        var rang = NSRange()
        rang.location = 0
        rang.length = 2
        
        let rString = (colorString as NSString).substring(with: rang)
        rang.location = 2
        let gString = (colorString as NSString).substring(with: rang)
        rang.location = 4
        let bString = (colorString as NSString).substring(with: rang)
        
        var r:UInt64 = 0, g:UInt64 = 0,b: UInt64 = 0
        
        Scanner(string: rString).scanHexInt64(&r)
        Scanner(string: gString).scanHexInt64(&g)
        Scanner(string: bString).scanHexInt64(&b)
        
        self.init(CGFloat(r), CGFloat(g), CGFloat(b), alpha)
    }
    
    static var randomColor: UIColor {
        return UIColor(CGFloat(arc4random() % 256), CGFloat(arc4random() % 256), CGFloat(arc4random() % 256))
    }
}
