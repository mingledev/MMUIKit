//
//  MMUIKit.swift
//  MMUIKit
//
//  Created by Mingle on 2022/2/20.
//

import UIKit

public var ScreenSize: CGSize {
    return UIScreen.main.bounds.size
}

public var ScreenWidth: CGFloat {
    return ScreenSize.width
}

public var ScreenHeight: CGFloat {
    return ScreenSize.height
}

public var StatusBarHeight: CGFloat {
    return UIApplication.shared.statusBarFrame.height
}

public var FullScreenBottomSafeHeight: CGFloat {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
    } else {
        // Fallback on earlier versions
        return 0
    }
}

public var IsFullScreen: Bool {
    return FullScreenBottomSafeHeight > 0
}

/// 宽度除以屏幕缩放系数
public func WidthDivideScreenScale(_ width: CGFloat) -> CGFloat {
    return width / UIScreen.main.scale
}

public var KeyWindow: UIWindow? {
    var window: UIWindow?
    if #available(iOS 13.0, *) {
        window = UIApplication.shared.connectedScenes.filter( {$0 is UIWindowScene} ).map( {$0 as! UIWindowScene} ).flatMap { $0.windows }.filter({$0.isKeyWindow}).first
    } else {
        window = UIApplication.shared.keyWindow
    }
    return window
}

public var CurrentViewController: UIViewController? {
    var vc = KeyWindow?.rootViewController
    while vc != nil {
        if vc is UITabBarController {
            vc = (vc as! UITabBarController).selectedViewController
        }
        if vc is UINavigationController {
            vc = (vc as! UINavigationController).visibleViewController
        }
        if vc?.presentedViewController != nil {
            vc = vc?.presentedViewController
        } else {
            break
        }
    }
    return vc
}

public var TopViewController: UIViewController? {
    var vc = KeyWindow?.rootViewController
    while vc?.presentedViewController != nil {
        vc = vc?.presentedViewController
    }
    return vc
}
