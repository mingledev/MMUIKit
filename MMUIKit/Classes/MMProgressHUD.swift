//
//  MMProgressHUD.swift
//  MMUIKit
//
//  Created by Mingle on 2022/3/1.
//

import UIKit

public class MMProgressHUD: UIView {
    
    enum MMProgressType {
        case activity
        case hud
        case progress
        case image
        case text
    }
    
    private static let `default`: MMProgressHUD = MMProgressHUD()
    
    private weak var _container: UIView?
    
    @objc public dynamic weak var container: UIView? {
        set {
            _container = newValue
        }
        get {
            return _container ?? UIApplication.shared.keyWindow
        }
    }
    
    /// 是否全屏展示（全屏展示会让用户无法进行ui交互）
    @objc public dynamic var isFullScreen: Bool = false
    
    @objc public dynamic var textFont: UIFont = .systemFont(ofSize: 15) {
        didSet {
            textLabel.font = textFont
        }
    }
    
    @objc public dynamic var textColor: UIColor = .white {
        didSet {
            textLabel.textColor = textColor
        }
    }
    
    @objc public dynamic var contentBackgroundColor: UIColor = UIColor("#000000", 0.8)
    
    private var type: MMProgressType?
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = contentBackgroundColor
        view.mCornerRadius = 8
        return view
    } ()
    
    private var contentLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    } ()
    
    private var activity: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        return view
    } ()
    
    private let hudLayerWidth: CGFloat = 50
    
    private lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: (widthOfType - hudLayerWidth) / 2, y: (widthOfType - hudLayerWidth) / 2, width: hudLayerWidth, height: hudLayerWidth)
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 4
        layer.strokeEnd = 0
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: hudLayerWidth, height: hudLayerWidth), cornerRadius: hudLayerWidth / 2)
        layer.path = path.cgPath
        return layer
    } ()
    
    private lazy var hudLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: (widthOfType - hudLayerWidth) / 2, y: (widthOfType - hudLayerWidth) / 2, width: hudLayerWidth, height: hudLayerWidth)
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 4
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: hudLayerWidth, height: hudLayerWidth), cornerRadius: hudLayerWidth / 2)
        layer.path = path.cgPath
        layer.strokeEnd = 0.8
        return layer
    } ()
    
    private lazy var textLabel: UILabel = {
        let view = UILabel()
        view.font = textFont
        view.numberOfLines = 2
        view.textColor = textColor
        view.textAlignment = .center
        return view
    } ()
    
    private var imageView: UIImageView = {
        let view = UIImageView()
        return view
    } ()
    
    private var widthOfType: CGFloat {
        switch type {
        case .activity, .hud, .progress, .image:
            return 120
        default:
            return (container?.mWidth ?? ScreenWidth) - 100
        }
    }
    
    public init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func keyboardWillChangeFrame(_ sender: Notification) {
        
    }
    
    private func setupViews() {
        addSubview(contentView)
        contentView.layer.addSublayer(contentLayer)
    }
    
    public func showActivity() {
        if type != .activity {
            contentView.subviews.forEach { item in
                item.removeFromSuperview()
            }
            type = .activity
            contentView.addSubview(activity)
            activity.startAnimating()
        }
        
        layoutContentView()
        show()
    }
    
    public class func showActivity() {
        self.default.showActivity()
    }

    public func showHUD(_ text: String? = nil) {
        if type != .hud {
            contentView.subviews.forEach { item in
                item.removeFromSuperview()
            }
            contentLayer.sublayers?.forEach({ item in
                item.removeFromSuperlayer()
            })
            type = .hud
            contentView.addSubview(textLabel)
            contentLayer.addSublayer(hudLayer)
            
            let rotationAni = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAni.duration = 1.2
            rotationAni.repeatCount = HUGE
            rotationAni.autoreverses = false
            rotationAni.fromValue = 0
            rotationAni.toValue = 2 * Double.pi
            rotationAni.beginTime = CACurrentMediaTime()
            rotationAni.fillMode = kCAFillModeForwards
            rotationAni.isRemovedOnCompletion = false
            rotationAni.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            self.hudLayer.add(rotationAni, forKey: "com.MMProgressHUD.rotation")
        }
        textLabel.text = text
        
        layoutContentView()
        show()
    }
    
    public class func showHUD(_ text: String? = nil) {
        self.default.showHUD(text)
    }
    
    public func showProgress(_ progress: CGFloat) {
        if type != .progress {
            contentView.subviews.forEach { item in
                item.removeFromSuperview()
            }
            contentLayer.sublayers?.forEach({ item in
                item.removeFromSuperlayer()
            })
            type = .progress
            contentView.addSubview(textLabel)
            contentLayer.addSublayer(progressLayer)
            progressLayer.strokeEnd = progress
        }
        textLabel.text = "\(Int(progress * 100))%"
        progressLayer.strokeEnd = progress == 0 ? 0.01 : progress
        
        layoutContentView()
        show()
    }
    
    public class func showProgress(_ progress: CGFloat) {
        self.default.showProgress(progress)
    }
    
    private var timer: Timer?
    
    public func showText(_ text: String?, _ duration: TimeInterval = 2) {
        if type != .text {
            contentView.subviews.forEach { item in
                item.removeFromSuperview()
            }
            contentLayer.sublayers?.forEach({ item in
                item.removeFromSuperlayer()
            })
            type = .text
            contentView.addSubview(textLabel)
        }
        textLabel.text = text
        
        layoutContentView()
        show()
        
        timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { [weak self] _ in
            self?.hide()
        })
    }
    
    public class func showText(_ text: String?, _ duration: TimeInterval = 2) {
        self.default.showText(text, duration)
    }
    
    public func showImage(_ image: UIImage?, _ text: String?) {
        if type != .image {
            contentView.subviews.forEach { item in
                item.removeFromSuperview()
            }
            contentLayer.sublayers?.forEach({ item in
                item.removeFromSuperlayer()
            })
            type = .image
            contentView.addSubview(textLabel)
            contentView.addSubview(imageView)
        }
        imageView.image = image
        textLabel.text = text
        
        layoutContentView()
        show()
    }
    
    public class func showImage(_ image: UIImage?, _ text: String?) {
        self.default.showImage(image, text)
    }
    
    public func showSuccess(_ text: String? = nil) {
        showImage(UIImage(named: "progress_success", in: Bundle.mm_uiKit, compatibleWith: nil), text)
    
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [weak self] _ in
            self?.hide()
        })
    }
    
    public class func showSuccess(_ text: String? = nil) {
        self.default.showSuccess(text)
    }
    
    public func showFail(_ text: String? = nil) {
        showImage(UIImage(named: "progress_fail", in: Bundle.mm_uiKit, compatibleWith: nil), text)
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [weak self] _ in
            self?.hide()
        })
    }
    
    public class func showFail(_ text: String? = nil) {
        self.default.showFail(text)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layoutContentView()
    }
    
    private func layoutContentView() {
        guard let `type` = type, let `container` = container else { return }
        contentView.backgroundColor = type == .activity ? .clear : contentBackgroundColor
        switch type {
        case .activity:
            contentView.mSize = CGSize(width: widthOfType, height: widthOfType)
            activity.center = CGPoint(x: widthOfType / 2, y: widthOfType / 2)
            break
        case .hud:
            if (textLabel.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
                hudLayer.frame = CGRect(x: (widthOfType - hudLayerWidth) / 2, y: 20 + hudLayer.lineWidth, width: hudLayerWidth, height: hudLayerWidth)
                textLabel.mSize = textLabel.sizeThatFits(CGSize(width: widthOfType - 20, height: 100))
                textLabel.mTop = hudLayerWidth + 20 + 15
                contentView.mSize = CGSize(width: widthOfType, height: textLabel.mBottom + 20)
                textLabel.mCenterX = contentView.mWidth / 2
            } else {
                hudLayer.frame = CGRect(x: (widthOfType - hudLayerWidth) / 2, y: (widthOfType - hudLayerWidth) / 2, width: hudLayerWidth, height: hudLayerWidth)
                contentView.mSize = CGSize(width: widthOfType, height: widthOfType)
            }
            break
        case .progress:
            progressLayer.frame = CGRect(x: (widthOfType - hudLayerWidth) / 2, y: (widthOfType - hudLayerWidth) / 2, width: hudLayerWidth, height: hudLayerWidth)
            textLabel.mSize = textLabel.sizeThatFits(CGSize(width: hudLayerWidth, height: hudLayerWidth))
            textLabel.center = CGPoint(x: widthOfType / 2, y: widthOfType / 2)
            contentView.mSize = CGSize(width: widthOfType, height: widthOfType)
            break
        case .text:
            textLabel.mSize = textLabel.sizeThatFits(CGSize(width: container.mWidth - 100, height: container.mHeight / 2))
            contentView.mSize = CGSize(width: textLabel.mWidth + 40, height: textLabel.mHeight + 20)
            textLabel.mCenter = CGPoint(x: contentView.mWidth / 2, y: contentView.mHeight / 2)
            break
        case .image:
            imageView.mSize = imageView.image?.size ?? .zero
            textLabel.mSize = textLabel.sizeThatFits(CGSize(width: max(imageView.mWidth, widthOfType - 20), height: 100))
            imageView.mTop = 20
            textLabel.mTop = imageView.mHeight > 0 ? (imageView.mBottom + 15) : 10
            contentView.mSize = CGSize(width: max(max(imageView.mWidth, textLabel.mWidth + 20), widthOfType), height: max(imageView.mHeight > 0 ? (textLabel.mBottom + 20) : textLabel.mBottom + 10, widthOfType))
            if imageView.mSize.height == 0 || textLabel.mHeight == 0 {
                imageView.mCenterY = contentView.mHeight / 2
                textLabel.mCenterY = contentView.mHeight / 2
            }
            imageView.mCenterX = contentView.mWidth / 2
            textLabel.mCenterX = contentView.mWidth / 2
            
            break
        }
        if isFullScreen {
            frame = container.bounds
        } else {
            mSize = contentView.mSize
            center = CGPoint(x: container.mWidth / 2, y: container.mHeight / 2)
        }
        contentView.center = CGPoint(x: mWidth / 2, y: mHeight / 2)
    }
    
    private func show() {
        timer?.invalidate()
        guard let _ = superview else {
            self.alpha = 0
            self.container?.addSubview(self)
            UIView.animate(withDuration: 0.25) {
                self.alpha = 1
            }
            return
        }
    }
    
    public func hide() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        } completion: { _ in
            if self.type == .progress {
                self.progressLayer.strokeEnd = 0
            }
            self.removeFromSuperview()
            self.alpha = 1
        }
    }
    
    public class func hide() {
        self.default.hide()
    }

}
