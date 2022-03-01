//
//  MMPageViewController.swift
//  MMUIKit
//
//  Created by Mingle on 2022/2/27.
//

import UIKit

open class MMPageViewController: UIViewController, MMLoopViewDelegate {
    
    public var categoryView: MMPageCategoryView? {
        didSet {
            oldValue?.removeFromSuperview()
            if categoryView != nil {
                view.addSubview(categoryView!)
                categoryView?.clickItem = { [weak self] (_, index) in
                    guard let `self` = self else { return }
                    self.index = index
                }
            }
        }
    }
    
    public var index: Int {
        set {
            scrollView.index = newValue
        }
        get {
            return scrollView.index
        }
    }
    
    public var didScrollToIndex: ((MMPageViewController, Int) -> Void)?
    
    private lazy var scrollView: MMLoopView = {
        let view = MMLoopView()
        view.loopEnable = false
        view.delegate = self
        view.backgroundColor = .clear
        view.register(_MMPageSubCell.self, forCellWithReuseIdentifier: "cell")
        return view
    } ()
    
    public var subViewControllers = [UIViewController]() {
        didSet {
            oldValue.forEach { vc in
                vc.removeFromParentViewController()
            }
            subViewControllers.forEach { vc in
                self.addChildViewController(vc)
            }
            if scrollView.superview != nil {
                scrollView.reloadData()
            }
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(scrollView)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        categoryView?.frame = CGRect(x: 0, y: 0, width: view.mWidth, height: categoryView?.mHeight ?? 0)
        if #available(iOS 11.0, *) {
            if categoryView != nil && self.view.safeAreaInsets.top > 0 {
                categoryView?.mTop = self.view.safeAreaInsets.top
            }
        }
        scrollView.frame = CGRect(x: 0, y: categoryView?.mBottom ?? 0, width: view.mWidth, height: view.mHeight - (categoryView?.mBottom ?? 0))
    }
    

    public func numberOfLoopView(_ loopView: MMLoopView) -> Int {
        return subViewControllers.count
    }
    
    public func cellForIndexOfLoopView(_ loopView: MMLoopView, _ index: Int) -> UICollectionViewCell {
        let cell = loopView.dequeueReusableCell(withReuseIdentifier: "cell", for: index) as! _MMPageSubCell
        cell.container = subViewControllers[index].view
        return cell
    }

    public func didScrollToIndexOfLoopView(_ loopView: MMLoopView, _ index: Int) {
        categoryView?.index = index
        didScrollToIndex?(self, index)
    }
}

private class _MMPageSubCell: UICollectionViewCell {
    
    var container: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            guard let view = container else { return }
            contentView.addSubview(view)
            view.frame = contentView.bounds
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        container?.frame = contentView.bounds
    }
}
