//
//  MMLoopView.swift
//  MMUIKit
//
//  Created by Mingle on 2022/2/26.
//

import UIKit

@objc public protocol MMLoopViewDelegate: NSObjectProtocol {
    
    func numberOfLoopView(_ loopView: MMLoopView) -> Int
    
    func cellForIndexOfLoopView(_ loopView: MMLoopView, _ index: Int) -> UICollectionViewCell
    
    @objc optional func didSelectIndexOfLoopView(_ loopView: MMLoopView, _ index: Int)
    
    @objc optional func didScrollToIndexOfLoopView(_ loopView: MMLoopView, _ index: Int)
    
}

/// 循环展示视图
public class MMLoopView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    
    public weak var delegate: MMLoopViewDelegate?
    
    private var realCount: Int = 0 {
        didSet {
            if realCount > 0 && self.collectionView.visibleCells.count == 0 {
                collectionView.contentOffset = CGPoint(x: CGFloat(realCount) * collectionView.mWidth + CGFloat(index % realCount) * collectionView.mWidth, y: 0)
            }
        }
    }
    
    private var _index: Int = 0
    
    public var index: Int {
        set {
            if realCount > 0 {
                if _index % realCount == newValue % realCount {
                    return
                }
            }
            if abs(_index - newValue) > realCount && realCount > 0 {
                if _index > newValue {
                    _index = _index / realCount * realCount + newValue % realCount
                } else {
                    _index = (_index / realCount + 1) * realCount + newValue % realCount
                }
            } else {
                _index = newValue
            }
            if realCount * (loopEnable && (realCount > 1 || (realCount == 1 && loopIfOnlyOne)) ? 3 : 1) > _index && _index >= 0 {
                self.collectionView.scrollToItem(at: IndexPath(row: self._index, section: 0), at: .left, animated: true)
            }
            self.delegate?.didScrollToIndexOfLoopView?(self, self.index)
        }
        get {
            return realCount > 0 ? _index % realCount : _index
        }
    }
    
    public var loopEnable: Bool = true
    
    public var loopIfOnlyOne: Bool = true
    
    public var loopTimeInterval: TimeInterval = 5 {
        didSet {
            let auto = autoLoop
            autoLoop = auto
        }
    }
    
    public var autoLoop: Bool = false {
        didSet {
            loopTimer?.invalidate()
            if autoLoop {
                loopTimer = Timer.scheduledTimer(withTimeInterval: loopTimeInterval, repeats: true, block: { [weak self] timer in
                    guard let _ = self else {
                        timer.invalidate()
                        return
                    }
                    if self!.realCount > 0 {
                        self?.adjustCollectionContent()
                        self!.index = 1 + self!._index
                    }
                })
            }
        }
    }
    
    private var loopTimer: Timer?
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = .zero
        return layout
    } ()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.bounces = false
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    } ()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(collectionView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        flowLayout.itemSize = mSize
        collectionView.frame = bounds
        adjustCollectionContent()
    }
    
    private func adjustCollectionContent() {
        if realCount > 0 {
            // 解决屏幕方向改变时位置偏移的问题
            collectionView.contentOffset = CGPoint(x: CGFloat(index) * collectionView.mWidth, y: 0)
            var pageIndex: Int = Int(collectionView.contentOffset.x / collectionView.mWidth)
            let m = Int(collectionView.contentOffset.x) % Int(collectionView.mWidth)
            if m != 0 {
                pageIndex += (m > Int(collectionView.mWidth / 2) ? 1 : -1)
            }
            _index = pageIndex
            // 使位置始终展示在中间
            if loopEnable && ((loopIfOnlyOne && realCount == 1) || realCount > 1) {
                if collectionView.contentOffset.x == 0 || collectionView.contentOffset.x == collectionView.contentSize.width - collectionView.mWidth {
                    //                collectionView.scrollRectToVisible(CGRect(x: CGFloat(index % realCount + realCount) * mWidth, y: 0, width: mWidth, height: mHeight), animated: false)
                    collectionView.contentOffset = CGPoint(x: CGFloat(index % realCount + realCount) * mWidth, y: 0)
                    _index = realCount
                }
            }
        }
    }
    
    public func reloadData() {
        collectionView.reloadData()
        collectionView.scrollRectToVisible(CGRect(x: CGFloat(realCount)*collectionView.mWidth, y: 0, width: collectionView.mWidth, height: collectionView.mHeight), animated: false)
    }
    
    public func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    public func dequeueReusableCell(withReuseIdentifier identifier: String, for index: Int) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: IndexPath(row: index, section: 0))
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = delegate?.numberOfLoopView(self) ?? 0
        realCount = count
        if loopEnable && count > 0 {
            if (count == 1 && loopIfOnlyOne) || count > 1 {
                count = count * 3
            }
        }
        return count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return delegate!.cellForIndexOfLoopView(self, indexPath.row % realCount)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectIndexOfLoopView?(self, indexPath.row % realCount)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x == scrollView.contentSize.width - scrollView.mWidth {
            adjustCollectionContent()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        _index = Int(scrollView.contentOffset.x/scrollView.mWidth)
        adjustCollectionContent()
        autoLoop = autoLoop ? true : false
        delegate?.didScrollToIndexOfLoopView?(self, self.index)
    }
    
    deinit {
        loopTimer?.invalidate()
    }

}
