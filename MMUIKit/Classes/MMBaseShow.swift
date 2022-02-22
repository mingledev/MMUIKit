//
//  MMBaseShow.swift
//  MMUIKit
//
//  Created by Mingle on 2022/2/21.
//

import UIKit

public protocol MMBaseShowProtocol {
    
    var backgroundView: UIView { get set }
    var contentView: UIView { get set }
    
    var isVisible: Bool { get set }
    
    func show()
    func hide()
}

public class MMBaseShowView: UIView, MMBaseShowProtocol {
    
    public var backgroundView: UIView
    
    public var contentView: UIView
    
    public var isVisible: Bool
    
    init() {
        backgroundView = UIView()
        backgroundView.backgroundColor = .black
        contentView = UIView()
        isVisible = false
        
        super.init(frame: UIScreen.main.bounds)
        
        addSubview(backgroundView)
        addSubview(contentView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let _ = superview else { return }
        frame = superview!.bounds
        backgroundView.frame = self.bounds
        layoutContentView()
    }
    
    public func layoutContentView() {
        
    }
    
    public func show() {
        
    }
    
    public func hide() {
        
    }
    
}

