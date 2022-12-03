//
//  RouterUtil.swift
//  SwiftProduct
//
//  Created by zhanggenlin on 2022/11/18.
//

import Foundation
import CoreFoundation
import UIKit

enum RouterType: String {
    typealias RawValue = String
    
    case setting
    case webView
    
    func getController() -> UIViewController {
        switch self {
        case .setting:
            return UserSettingViewController.init()
        default:
            return UIViewController.init()
        }
    }
}

//let array: [BaseViewController.Type] = [UserSettingViewController.Type,AccountSafeVC.Type]

struct RouterUtil {
    
    
    static func pushVC(target: RouterType, params:[String: Any]?) {
        let vc = target.getController()
        guard let para = params else {
            // 没有参数 - 直接跳转
            UIViewController.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        /// 借鉴HandyJSON的赋值方式
        /// 对对象内存地址直接操作赋值
        /// 依赖Metadata数据格式
        PropertyUtil.transform(dict: para, to: vc)
        
        UIViewController.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func pushVC(target: String, params: [String: Any]?) {
        
        guard let tar = RouterType(rawValue: target) else { return }
        let vc = tar.getController()
        
        
        guard let para = params else {
            // 没有参数 - 直接跳转
            UIViewController.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        
        
        /// 借鉴HandyJSON的赋值方式
        /// 对对象内存地址直接操作赋值
        /// 依赖Metadata数据格式
        PropertyUtil.transform(dict: para, to: vc)
        
        /// kvc的方式赋值，虽然效率最高，但是需要类型匹配，否则会闪退
        /// 且属性值前面需要加 @objc 用来标识
//        let vcKeys = RouterUtil.getAllPropertys(vc)
//        para.allKeys().forEach { key in
//            if vcKeys.contains(key) {
//                // 有这个值
//                let value = para[key]
//                // MARK: 该方法需要vc实现 setValue:forUndefinedKey: 方法
//                vc.setValue(value, forKeyPath: key)
//            }
//        }
        
        UIViewController.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: 私有扩展
extension RouterUtil {
    // MARK: 获取控制器的属性列表
    /// - Parameter vc: 控制器
    /// - Returns: 返回属性列表数组
    private static func getAllPropertys(_ vc: UIViewController) -> [String] {
        let mirror = Mirror(reflecting: vc)
        var result = [String]()
        
        for child in mirror.children {
            if let label = child.label {
                result.append(label)
            }
        }
        return result
    }
    
}

extension UIViewController {
    /// 获取顶部控制器
    /// - Returns: VC
    static func topViewController() -> UIViewController? {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first, let rootVC = window.rootViewController  else {
            return nil
        }
        return top(rootVC: rootVC)
    }
    
    private static func top(rootVC: UIViewController?) -> UIViewController? {
        if let presentedVC = rootVC?.presentedViewController {
            return top(rootVC: presentedVC)
        }
        if let nav = rootVC as? UINavigationController,
            let lastVC = nav.viewControllers.last {
            return top(rootVC: lastVC)
        }
        if let tab = rootVC as? UITabBarController,
            let selectedVC = tab.selectedViewController {
            return top(rootVC: selectedVC)
        }
        return rootVC
    }
    
}




