//
//  PropertyUtil.swift
//  swiftTest
//
//  Created by zhanggenlin on 2022/11/24.
//

import Foundation
import UIKit

typealias Byte = Int8

struct PropertyUtil { }

extension PropertyUtil {
    static func transform(dict: [String: Any], to instance: UIViewController) {
        let type = type(of: instance)
        /// 获取类型所有的属性
        guard let properties = getProperties(forType: type) else {
            return
        }
        
        /// 获取对象内存中的head节点
        let rawPointer = instance.headPointerOfClass()
        
        properties.forEach { property in
            /// 属性在内存中的地址
            let propAddr = rawPointer.advanced(by: property.offset)
            
            let detail = PropertyInfo(key: property.key, type: property.type, address: propAddr)
            
            /// 从字典中获取对应值
            if let rawValue = dict[property.key] {
                /// 把值转成需要的类型，比如 需要string，后台给了Int 直接赋值会失败，需要转成string
                if let convertedValue = convertValue(rawValue: rawValue, property: detail) {
                    /// 写入对应内存地址内
                    extensions(of: property.type).write(convertedValue, to: detail.address)
                }
            }
        }
    }
}


fileprivate func convertValue(rawValue: Any, property: PropertyInfo) -> Any? {
    
    /// 需要转化时
    if let transformType = property.type as? BuiltInBasicTypeProtocol.Type {
        /// 转换结果， 比如需要Int，但是后台给了string
        return transformType.transform(from: rawValue)
    } else {
        return extensions(of: property.type).takeValue(from: rawValue)
    }
}

struct PropertyInfo {
    let key: String
    let type: Any.Type
    let address: UnsafeMutableRawPointer
}


extension UIViewController {
    /// 得到VC对象内存中的head节点
    fileprivate func headPointerOfClass() -> UnsafeMutablePointer<Int8> {
        let opaquePointer = Unmanaged.passUnretained(self).toOpaque()
        let mutableTypedPointer = opaquePointer.bindMemory(to: Int8.self, capacity: MemoryLayout<Self>.stride)
        return UnsafeMutablePointer<Int8>(mutableTypedPointer)
    }
}
