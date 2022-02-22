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
