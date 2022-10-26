//
//  DeviceInfo.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/12.
//

import UIKit

struct DeviceInfo {
    static var screenWidth: CGFloat     { return UIScreen.main.bounds.width }
    static var screenHeight: CGFloat    { return UIScreen.main.bounds.height }
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    static var bottomSafeAreaInset: CGFloat { return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0 }
    static var topSafeAreaInset: CGFloat    { return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 }
}
