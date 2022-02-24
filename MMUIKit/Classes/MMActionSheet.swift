//
//  MMActionSheet.swift
//  MMUIKit
//
//  Created by Mingle on 2022/2/22.
//

import UIKit

public class MMActionSheet: MMBaseShowView {
    
    public typealias Index = Int
    public typealias CanHide = Bool
    
    public let indexOfCancelButton = -1
    
    public var buttonOnClick: ((MMActionSheet, Index) -> CanHide)?

    @objc dynamic public var titleFont: UIFont = UIFont.systemFont(ofSize: 15, weight: .medium) {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    @objc dynamic public var titleColor: UIColor = .black {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    @objc dynamic public var contentFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            contentLabel.font = contentFont
        }
    }
    
    @objc dynamic public var contentColor: UIColor = .black {
        didSet {
            contentLabel.textColor = contentColor
        }
    }
    
    @objc dynamic public var buttonFont: UIFont = .systemFont(ofSize: 15) {
        didSet {
            var btnList = [UIButton]()
            btnList.append(cancelButton)
            btnList.append(contentsOf: otherButtonList)
            btnList.forEach({ item in
                item.titleLabel?.font = buttonFont
            })
        }
    }
    
    @objc dynamic public var cancelButtonColor: UIColor = .lightGray {
        didSet {
            cancelButton.setTitleColor(cancelButtonColor, for: .normal)
        }
    }
    
    @objc dynamic public var otherButtonColor: UIColor = .black {
        didSet {
            otherButtonList.forEach { item in
                item.setTitleColor(otherButtonColor, for: .normal)
            }
        }
    }
    
    @objc dynamic public var lineViewColor: UIColor = UIColor("#E1E1E1") {
        didSet {
            lineViewList.forEach { item in
                item.backgroundColor = lineViewColor
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = titleFont
        lbl.textColor = titleColor
        lbl.numberOfLines = 0
        return lbl
    }()

    private lazy var contentLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = contentFont
        lbl.textColor = titleColor
        lbl.numberOfLines = 0
        return lbl
    }()

    private lazy var cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = buttonFont
        btn.setTitleColor(cancelButtonColor, for: .normal)
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var otherButtonList = [UIButton]()
    private lazy var lineViewList = [UIView]()
    
    private var maskLayer: CAShapeLayer = CAShapeLayer()
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private var cancelTopLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor("#F4F4F4")
        return view
    }()
    
    public class func show(title: String?, content: String?, cancelButtonTitle: String?, otherButtonTitle: String?...) -> MMActionSheet {
        let alert = MMActionSheet()
        alert.titleLabel.text = title
        alert.contentLabel.text = content
        alert.cancelButton.setTitle(cancelButtonTitle, for: .normal)
        for (_, otherTitle) in otherButtonTitle.compactMap({ $0 }).enumerated() {
            alert.addButton(otherTitle)
        }
        alert.setupSubViews()
        alert.show()
        return alert
    }
    
    func setupSubViews() {
        contentView.backgroundColor = .white
        contentView.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(contentLabel)
        scrollView.addSubview(cancelTopLineView)
        scrollView.addSubview(cancelButton)
        
        let btnCount = otherButtonList.count + (cancelButton.titleLabel?.text == nil ? 0 : 1)
        for _ in 0..<(btnCount - lineViewList.count) {
            let line = UIView()
            line.backgroundColor = lineViewColor
            scrollView.addSubview(line)
            lineViewList.append(line)
        }
        
        contentView.layer.mask = maskLayer
    }
    
    @objc private func cancelAction() {
        if buttonOnClick?(self, indexOfCancelButton) ?? true {
            hide()
        }
    }
    
    @objc private func otherButtonAction(_ sender: UIButton) {
        if buttonOnClick?(self, sender.tag) ?? true {
            hide()
        }
    }
    
    public func addButton(_ title: String) {
        let btn = UIButton(type: .system)
        btn.tag = otherButtonList.count
        btn.titleLabel?.font = buttonFont
        btn.setTitleColor(otherButtonColor, for: .normal)
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(otherButtonAction(_:)), for: .touchUpInside)
        scrollView.addSubview(btn)
        otherButtonList.append(btn)
        
        let line = UIView()
        line.backgroundColor = lineViewColor
        scrollView.addSubview(line)
        lineViewList.append(line)
        
        if isVisible {
            layoutContentView()
        }
    }
    
    public override func layoutContentView() {
        super.layoutContentView()
        contentView.mLeft = 0
        contentView.mWidth = superview!.mWidth
        scrollView.frame = contentView.bounds
        
        var currentMaxY: CGFloat = 15
        
        if let _ = titleLabel.text {
            titleLabel.isHidden = false
            titleLabel.mSize = titleLabel.sizeThatFits(CGSize(width: contentView.mWidth - 30, height: 100))
            titleLabel.mTop = currentMaxY
            titleLabel.mCenterX = contentView.mWidth / 2
            currentMaxY = titleLabel.mBottom
        } else {
            titleLabel.isHidden = true
        }
        
        if let _ = contentLabel.text {
            contentLabel.isHidden = false
            contentLabel.mSize = contentLabel.sizeThatFits(CGSize(width: contentView.mWidth - 30, height: mHeight / 2))
            contentLabel.mTop = currentMaxY + 10
            contentLabel.mCenterX = contentView.mWidth / 2
            currentMaxY = contentLabel.mBottom
        }
        
        var btnList = [UIButton]()
        btnList.append(contentsOf: otherButtonList)
        if cancelButton.titleLabel?.text != nil {
            btnList.append(cancelButton)
        }
        
        if btnList.count > 0 {
            currentMaxY += 15
            for (i, item) in btnList.enumerated() {
                if item == btnList.last && item == cancelButton {
                    cancelTopLineView.mWidth = scrollView.mWidth
                    cancelTopLineView.mHeight = 10
                    cancelTopLineView.mTop = currentMaxY
                    currentMaxY = cancelTopLineView.mBottom
                }
                item.mLeft = 0
                item.mTop = currentMaxY
                item.mWidth = scrollView.mWidth
                item.mHeight = 40
                currentMaxY = item.mBottom
                lineViewList[i].mLeft = 0
                lineViewList[i].mTop = item.mTop
                lineViewList[i].mWidth = item.mWidth
                lineViewList[i].mHeight = WidthDivideScreenScale(1)
            }
        }
        
        scrollView.contentSize = CGSize(width: scrollView.mWidth, height: currentMaxY + FullScreenBottomSafeHeight)
        scrollView.mHeight = min(mHeight - 100, scrollView.contentSize.height)
        contentView.mHeight = scrollView.mHeight
        let maskPath = UIBezierPath(roundedRect: contentView.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue), cornerRadii: CGSize(width: 8, height: 8))
        maskLayer.path = maskPath.cgPath
        
        contentView.mTop = isVisible ? mHeight - contentView.mHeight : mHeight
    }
    
    public override func show() {
        if self.isVisible == false {
            UIApplication.shared.keyWindow?.addSubview(self)
            self.isVisible = true
            layoutContentView()
            contentView.mTop = mHeight
            backgroundView.alpha = 0
            UIView.animate(withDuration: 0.25) {
                self.backgroundView.alpha = 0.6
                self.contentView.mBottom = self.mHeight
            }
        }
    }
    
    public override func hide() {
        if isVisible {
            UIView.animate(withDuration: 0.25) {
                self.backgroundView.alpha = 0
                self.contentView.mTop = self.mHeight
            } completion: { _ in
                self.removeFromSuperview()
                self.isVisible = false
                self.contentView.alpha = 1
            }
        }
    }
}
