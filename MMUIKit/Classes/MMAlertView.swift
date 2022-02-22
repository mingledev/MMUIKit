//
//  MMAlertView.swift
//  MMUIKit
//
//  Created by Mingle on 2022/2/22.
//

import UIKit

public class MMAlertView: MMBaseShowView {
    
    public typealias Index = Int
    public typealias CanHide = Bool
    
    public let indexOfCancelButton = -1
    
    public var buttonOnClick: ((MMAlertView, Index) -> CanHide)?
    
    @objc dynamic public var titleFont: UIFont = .systemFont(ofSize: 15, weight: .medium) {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    @objc dynamic public var contentFont: UIFont = .systemFont(ofSize: 13) {
        didSet {
            textView.font = contentFont
        }
    }
    
    @objc dynamic public var buttonFont: UIFont = .systemFont(ofSize: 15) {
        didSet {
            cancelButton.titleLabel?.font = buttonFont
            for item in otherButtonList {
                item.titleLabel?.font = buttonFont
            }
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = titleFont
        lbl.textColor = titleColor
        return lbl
    }()
    
    @objc dynamic public var cancelButtonTitleColor: UIColor = .blue {
        didSet {
            cancelButton.setTitleColor(cancelButtonTitleColor, for: .normal)
        }
    }
    
    @objc dynamic public var otherButtonTitleColor: UIColor = .black {
        didSet {
            for item in otherButtonList {
                item.setTitleColor(otherButtonTitleColor, for: .normal)
            }
        }
    }
    
    @objc dynamic public lazy var lineViewColor: UIColor = UIColor("#E1E1E1") {
        didSet {
            for item in lineViewList {
                item.backgroundColor = lineViewColor
            }
        }
    }
    
    @objc dynamic public lazy var titleColor: UIColor = .black {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    @objc dynamic public lazy var contentColor: UIColor = .black {
        didSet {
            textView.textColor = contentColor
        }
    }
    
    private var lineViewList = [UIView]()
    
    private var textFieldList = [UITextField]()
    
    private lazy var cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = buttonFont
        btn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return btn
    }()
    
    private var otherButtonList = [UIButton]()
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.font = contentFont
        view.isEditable = false
        view.textAlignment = .center
        view.textColor = contentColor
        return view
    }()
    
    private var customerView: UIView?
    
    private func setupSubViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(textView)
        contentView.addSubview(cancelButton)
        for item in otherButtonList {
            contentView.addSubview(item)
        }
        let btnCount = otherButtonList.count + (cancelButton.titleLabel?.text == nil ? 0 : 1)
        for _ in 0..<(btnCount - lineViewList.count) {
            let line = UIView()
            line.backgroundColor = lineViewColor
            contentView.addSubview(line)
            lineViewList.append(line)
        }
        contentView.mCornerRadius = 8
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
    }
    
    public override func layoutContentView() {
        super.layoutContentView()
        
        contentView.mWidth = min(mWidth, mHeight) - 100
        
        var currentMaxY: CGFloat = 10
        
        if let _ = titleLabel.text {
            titleLabel.isHidden = false
            titleLabel.mSize = titleLabel.sizeThatFits(CGSize(width: contentView.mWidth - 30, height: 100))
            titleLabel.mTop = currentMaxY
            titleLabel.mCenterX = contentView.mWidth / 2
            currentMaxY = titleLabel.mBottom
        } else {
            titleLabel.isHidden = true
        }
        
        if textView.text.count > 0 {
            textView.isHidden = false
            textView.mSize = textView.sizeThatFits(CGSize(width: contentView.mWidth - 30, height: mHeight / 2))
            textView.mHeight = ceil(min(textView.mHeight, mHeight / 2))
            textView.mTop = currentMaxY + 10
            textView.mCenterX = contentView.mWidth / 2
            currentMaxY = textView.mBottom
        }
        
        if customerView != nil {
            customerView?.mCenterX = contentView.mWidth / 2
            customerView?.mTop = currentMaxY + 10
            currentMaxY = customerView!.mBottom
        }
        
        for item in textFieldList {
            item.frame = CGRect(x: 15, y: currentMaxY + 10, width: contentView.mWidth - 30, height: item.mHeight)
            currentMaxY = item.mBottom
        }
        
        var btnList = [UIButton]()
        if cancelButton.titleLabel?.text != nil {
            btnList.append(cancelButton)
        }
        btnList.append(contentsOf: otherButtonList)
        
        if btnList.count == 2 {
            for (i, item) in btnList.enumerated() {
                item.mLeft = CGFloat(i) * (contentView.mWidth / 2)
                item.mTop = currentMaxY + 10
                item.mWidth = contentView.mWidth / 2
                item.mHeight = 40
                if i == 0 {
                    lineViewList[i].mTop = item.mTop
                    lineViewList[i].mLeft = 0
                    lineViewList[i].mWidth = contentView.mWidth
                    lineViewList[i].mHeight = WidthDivideScreenScale(1)
                } else {
                    lineViewList[i].mTop = item.mTop
                    lineViewList[i].mCenterX = contentView.mWidth / 2
                    lineViewList[i].mHeight = item.mHeight
                    lineViewList[i].mWidth = WidthDivideScreenScale(1)
                }
            }
            currentMaxY = btnList.last!.mBottom
        } else {
            currentMaxY += 10
            for (i, item) in btnList.enumerated() {
                item.mLeft = 0
                item.mTop = currentMaxY
                item.mWidth = contentView.mWidth
                item.mHeight = 40
                currentMaxY = item.mBottom
                lineViewList[i].mLeft = 0
                lineViewList[i].mTop = item.mTop
                lineViewList[i].mWidth = item.mWidth
                lineViewList[i].mHeight = WidthDivideScreenScale(1)
            }
        }
        contentView.mHeight = currentMaxY
        contentView.mCenterY = mHeight / 2
        contentView.mCenterX = mWidth / 2
    }
    
    public class func show(title: String?, content: String?, cancelButtonTitle: String?, otherButtonTitle: String?...) -> MMAlertView {
        let alert = MMAlertView()
        alert.titleLabel.text = title
        alert.textView.text = content
        alert.cancelButton.setTitle(cancelButtonTitle, for: .normal)
        for (_, otherTitle) in otherButtonTitle.compactMap({ $0 }).enumerated() {
            alert.addButton(otherTitle)
        }
        alert.setupSubViews()
        alert.show()
        return alert
    }
    
    func addButton(_ title: String) {
        let btn = UIButton(type: .system)
        btn.tag = otherButtonList.count
        btn.titleLabel?.font = buttonFont
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(otherButtonTitleColor, for: .normal)
        btn.addTarget(self, action: #selector(otherButtonAction(_:)), for: .touchUpInside)
        contentView.addSubview(btn)
        otherButtonList.append(btn)
        
        let line = UIView()
        line.backgroundColor = lineViewColor
        contentView.addSubview(line)
        lineViewList.append(line)
        
        if isVisible {
            layoutContentView()
        }
    }
    
    public func addTextField(_ textField: UITextField) {
        if textField.mHeight == 0 {
            textField.mHeight = 30
        }
        contentView.addSubview(textField)
        textFieldList.append(textField)
        if isVisible {
            layoutContentView()
        }
    }
    
    public func addCustomerView(_ view: UIView) {
        if customerView != nil {
            customerView?.removeFromSuperview()
        }
        contentView.addSubview(view)
        customerView = view
        if self.isVisible {
            layoutContentView()
        }
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
    
    public override func show() {
        if self.isVisible == false {
            UIApplication.shared.keyWindow?.addSubview(self)
            self.transform = .init(scaleX: 1, y: 1)
            self.contentView.transform = .init(scaleX: 0.5, y: 0.5)
            self.backgroundView.alpha = 0
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseInOut) {
                self.backgroundView.alpha = 0.6
                self.contentView.transform = .init(scaleX: 1, y: 1)
            } completion: { _ in
                self.isVisible = true
            }
        }
    }
    
    public override func hide() {
        if isVisible {
            UIView.animate(withDuration: 0.25) {
                self.backgroundView.alpha = 0
                self.transform = .init(scaleX: 1.5, y: 1.5)
                self.contentView.alpha = 0
            } completion: { _ in
                self.removeFromSuperview()
                self.isVisible = false
                self.contentView.alpha = 1
            }
        }
    }
}

