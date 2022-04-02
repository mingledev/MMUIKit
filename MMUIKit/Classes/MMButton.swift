//
//  MMButton.swift
//  MMUIKit
//
//  Created by Mingle on 2022/2/20.
//

import UIKit

/// 自定义图片与标签位置关系的按钮
public class MMButton: UIButton {
    
    public enum ImageLocation {
        case left
        case right
        case top
        case bottom
    }
    
    public var imgLocation: ImageLocation = .left

    public var spacing: CGFloat = 8 {
        didSet {
            reLayout()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        reLayout()
    }
    
    private func reLayout() {
        if imageView?.image == nil || titleLabel?.text == nil {
            return
        }
        
        switch imgLocation {
        case .left:
            imageView?.mLeft = (mWidth - imageView!.mWidth - titleLabel!.mWidth - spacing) / 2
            titleLabel?.mLeft = imageView!.mRight + spacing
        case .right:
            titleLabel?.mLeft = (mWidth - imageView!.mWidth - titleLabel!.mWidth - spacing) / 2
            imageView?.mLeft = titleLabel!.mRight + spacing
        case .top:
            let imgRealSize = imageView!.image!.size
            let lblRealSize = titleLabel!.sizeThatFits(CGSize(width: mWidth, height: mHeight - imageView!.image!.size.height - spacing))
            imageView?.mSize = imgRealSize
            imageView?.mCenterX = mWidth / 2
            imageView?.mTop = (mHeight - imgRealSize.height - lblRealSize.height - spacing) / 2
            titleLabel?.mSize = lblRealSize
            titleLabel?.mCenterX = mWidth / 2
            titleLabel?.mTop = imageView!.mBottom + spacing
            break
        case .bottom:
            let imgRealSize = imageView!.image!.size
            let lblRealSize = titleLabel!.sizeThatFits(CGSize(width: mWidth, height: mHeight - imageView!.image!.size.height - spacing))
            titleLabel?.mSize = lblRealSize
            titleLabel?.mCenterX = mWidth / 2
            titleLabel?.mTop = (mHeight - imgRealSize.height - lblRealSize.height - spacing) / 2
            imageView?.mSize = imgRealSize
            imageView?.mCenterX = mWidth / 2
            imageView?.mTop = titleLabel!.mBottom + spacing
            break
        }
    }

}
