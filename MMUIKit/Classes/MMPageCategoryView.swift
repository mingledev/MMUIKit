//
//  MMPageCategoryView.swift
//  MMUIKit
//
//  Created by Mingle on 2022/2/27.
//

import UIKit

public protocol MMPageCategoryDelegate: NSObjectProtocol {
    
    var titles: [String] { get set }
    
    var index: Int { get set }
    
    var clickItem: ((Self, Int) -> Void)? { get set }
}

open class MMPageCategoryView: UIView, MMPageCategoryDelegate, UIScrollViewDelegate {
    
    public var titles: [String] = [String]() {
        didSet {
            updateTitlesView()
        }
    }
    
    public var index: Int = 0 {
        didSet {
            if titleLblList.count > index && index >= 0 {
                selectAnimation(oldValue, index)
            }
        }
    }
    
    public var clickItem: ((MMPageCategoryView, Int) -> Void)?
    
    public var spacing: CGFloat = 20 {
        didSet {
            updateTitlesView()
        }
    }

    public lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.delegate = self
        return view
    } ()
    
    @objc dynamic public var normalFont: UIFont = .systemFont(ofSize: 15) {
        didSet {
            updateTitlesView()
        }
    }
    
    @objc dynamic public var selectedFont: UIFont? {
        didSet {
            updateTitlesView()
        }
    }
    
    @objc dynamic public var selectedScaleRatio: CGFloat = 1.1 {
        didSet {
            updateTitlesView()
        }
    }
    
    @objc dynamic public var normalColor: UIColor = .black {
        didSet {
            updateTitlesView()
        }
    }
    
    @objc dynamic public var selectedColor: UIColor = .red {
        didSet {
            updateTitlesView()
        }
    }
    
    @objc dynamic public var indicatorColor: UIColor = .red {
        didSet {
            indicatorView.backgroundColor = indicatorColor
        }
    }
    
    open lazy var indicatorView: UIView = {
        let view = UIView()
        view.mHeight = 2
        view.backgroundColor = indicatorColor
        return view
    } ()
    
    var titleLblList = [UILabel]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(indicatorView)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        updateTitlesView()
    }
    
    func updateTitlesView() {
        if titleLblList.count != titles.count {
            let count = titleLblList.count - titles.count
            if count > 0 {
                titleLblList.removeSubrange((titleLblList.count - count)..<count)
            } else {
                for i in 0..<abs(count) {
                    let btn = UILabel()
                    btn.textAlignment = .center
                    btn.isUserInteractionEnabled = true
                    btn.tag = titleLblList.count + i
//                    btn.addTarget(self, action: #selector(titleBtnAction(_:)), for: .touchUpInside)
                    btn.addGesture(type: UITapGestureRecognizer.self, target: self, action: #selector(titleBtnAction(_:)))
                    scrollView.addSubview(btn)
                    titleLblList.append(btn)
                }
            }
        }
        for (i, title) in titles.enumerated() {
            let btn = titleLblList[i]
            btn.tag = i
            btn.font = normalFont
            btn.textColor = index == i ? selectedColor : normalColor
            btn.text = title
            
//            let textSize = NSString(string: title).boundingRect(with: CGSize(width: mWidth, height: scrollView.mHeight), options: .usesFontLeading, attributes: [.font:btn.titleLabel?.font ?? normalFont], context: nil).size
            btn.sizeToFit()
            btn.mTop = 0
            btn.mLeft = i == 0 ? spacing : titleLblList[i-1].mRight
            btn.mWidth += spacing
            btn.mHeight = scrollView.mHeight
            
            btn.font = index == i ? (selectedFont ?? normalFont) : normalFont
            if i == index && selectedFont == nil {
                btn.transform = CGAffineTransform(scaleX: selectedScaleRatio, y: selectedScaleRatio)
            } else {
                btn.transform = CGAffineTransform.identity
            }
        }
        scrollView.contentSize = CGSize(width: (titleLblList.last?.mRight ?? 0) + spacing, height: scrollView.mHeight)
        
        if index >= 0 && titleLblList.count > index {
            indicatorView.mWidth = titleLblList[index].mWidth - spacing
            indicatorView.mBottom = self.scrollView.mHeight - indicatorView.mHeight
            indicatorView.mCenterX = titleLblList[index].mCenterX
        }
    }
    
    func selectAnimation(_ oldIndex: Int, _ newIndex: Int) {
        if titleLblList.count > index && index >= 0 {
            UIView.animate(withDuration: 0.25) {
                self.titleLblList[oldIndex].textColor = self.normalColor
                self.titleLblList[newIndex].textColor = self.selectedColor
                if self.selectedFont != nil {
                    self.titleLblList[oldIndex].font = self.normalFont
                    self.titleLblList[newIndex].font = self.selectedFont
                } else {
                    self.titleLblList[oldIndex].transform = .identity
                    self.titleLblList[newIndex].transform = .init(scaleX: self.selectedScaleRatio, y: self.selectedScaleRatio)
                }
                self.indicatorView.mWidth = self.titleLblList[newIndex].mWidth - self.spacing
                self.indicatorView.mBottom = self.scrollView.mHeight - self.indicatorView.mHeight
                self.indicatorView.mCenterX = self.titleLblList[newIndex].mCenterX
            }
            scrollView.scrollRectToVisible(titleLblList[newIndex].frame, animated: true)
        }
    }
    
    @objc func titleBtnAction(_ sender: UITapGestureRecognizer) {
        index = sender.view!.tag
        clickItem?(self, sender.view!.tag)
    }
    
}
