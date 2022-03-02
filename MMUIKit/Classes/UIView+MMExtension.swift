//
//  UIView+MMExtension.swift
//  MMUIKit
//
//  Created by Mingle on 2022/2/20.
//

import UIKit

public extension UIView {
    
    var mLeft: CGFloat {
        get {
            return self.frame.minX
        }
        set {
            var nFrame = frame
            nFrame.origin.x = newValue
            frame = nFrame
        }
    }
    
    var mTop: CGFloat {
        get {
            return self.frame.minY
        }
        set {
            var nFrame = frame
            nFrame.origin.y = newValue
            frame = nFrame
        }
    }
    
    var mRight: CGFloat {
        get {
            return self.frame.maxX
        }
        set {
            var nFrame = frame
            nFrame.origin.x = newValue - nFrame.size.width
            frame = nFrame
        }
    }
    
    var mBottom: CGFloat {
        get {
            return self.frame.maxY
        }
        set {
            var nFrame = frame
            nFrame.origin.y = newValue - nFrame.size.height
            frame = nFrame
        }
    }
    
    var mCenter: CGPoint {
        get {
            return center
        }
        set {
            center = newValue
        }
    }
    
    var mCenterX: CGFloat {
        get {
            return center.x
        }
        set {
            var point = center
            point.x = newValue
            center = point
        }
    }
    
    var mCenterY: CGFloat {
        get {
            return center.y
        }
        set {
            var point = center
            point.y = newValue
            center = point
        }
    }
    
    var mOrigin: CGPoint {
        get {
            return frame.origin
        }
        set {
            var nFrame = frame
            nFrame.origin = newValue
            frame = nFrame
        }
    }
    
    var mSize: CGSize {
        get {
            return frame.size
        }
        set {
            var nFrame = frame
            nFrame.size = newValue
            frame = nFrame
        }
    }
    
    var mWidth: CGFloat {
        get {
            return frame.size.width
        }
        set {
            var nFrame = frame
            nFrame.size.width = newValue
            frame = nFrame
        }
    }
    
    var mHeight: CGFloat {
        get {
            return frame.size.height
        }
        set {
            var nFrame = frame
            nFrame.size.height = newValue
            frame = nFrame
        }
    }
    
    var mCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    var mBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    var mBorderColor: UIColor? {
        get {
            return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) : nil
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    var mShadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    var mShadowPath: CGPath? {
        get {
            return layer.shadowPath
        }
        set {
            layer.shadowPath = newValue
        }
    }
    
    var mShadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    var mShadowColor: UIColor? {
        get {
            return layer.shadowColor != nil ? UIColor(cgColor: layer.shadowColor!) : nil
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    var mShadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
   func addCorners(_ corners: UIRectCorner, _ radii: CGSize) {
        let path = UIBezierPath(roundedRect: frame, byRoundingCorners: corners, cornerRadii: radii)
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.mask = layer
    }
    
    @discardableResult func addGesture<T: UIGestureRecognizer>( type: T.Type, target: Any, action: Selector) -> T {
        let ges = type.init(target: target, action: action)
        addGestureRecognizer(ges)
        return ges
    }
}
