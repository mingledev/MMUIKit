//
//  _Bundle+MMUIKit.swift
//  MMUIKit
//
//  Created by Mingle on 2022/3/2.
//

import Foundation

internal extension Bundle {
    
    static var mm_uiKit: Bundle? {
        return Bundle(path: Bundle(for: MMButton.self).path(forResource: "MMUIKit", ofType: "bundle")!)
    }
    
}
