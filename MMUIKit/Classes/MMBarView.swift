//
//  MMBarView.swift
//  MMUIKit
//
//  Created by Mingle on 2022/2/20.
//

import UIKit

/// 可以浮动在父视图顶部或底部，自动处理安全距离
open class MMBarView: UIView {

    public enum Location {
        case top
        case bottom
    }

    private var location: Location
    private var contentHeight: CGFloat
    private lazy var _contentView: UIView = {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: contentHeight))
        view.backgroundColor = .clear
        return view
    }()
    
    open var contentView: UIView {
        return _contentView
    }
    
    public init(contentHeight: CGFloat = 44, location: Location = .top) {
        self.location = location
        self.contentHeight = contentHeight
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: contentHeight + (location == .bottom ? FullScreenBottomSafeHeight : StatusBarHeight)))
    }
    
    required public init?(coder: NSCoder) {
        location = .top
        contentHeight = 44
        super.init(coder: coder)
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if contentView.superview == nil {
            addSubview(contentView)
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        reLayout()
    }
    
    private func reLayout() {
        
        guard let _ = superview else { return }
        
        if #available(iOS 11.0, *) {
            frame = CGRect(x: 0, y: location == .top ? 0 : (superview!.mHeight - superview!.safeAreaInsets.bottom - contentHeight), width: ScreenWidth, height: contentHeight + (location == .top ? superview!.safeAreaInsets.top : superview!.safeAreaInsets.bottom))
        } else {
            // Fallback on earlier versions
            frame = CGRect(x: 0, y: location == .top ? 0 : superview!.mHeight - contentHeight, width: ScreenWidth, height: contentHeight)
        }
        contentView.frame = CGRect(x: 0, y: location == Location.top ? StatusBarHeight : 0, width: ScreenWidth, height: contentHeight)
    }
}
