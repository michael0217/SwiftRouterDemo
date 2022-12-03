//
//  BuiltInBasicType.swift
//  swiftTest
//
//  Created by zhanggenlin on 2022/11/24.
//

import Foundation

// MARK: 基础类型转化协议
protocol BuiltInBasicTypeProtocol {
    static func transform(from object: Any) -> Self?
}

// MARK: Integer类型转化协议
protocol IntegerPropertyProtocol: BuiltInBasicTypeProtocol {
    init?(_ text: String, radix: Int)
    init(_ number: NSNumber)
}

extension IntegerPropertyProtocol {
    static func transform(from object: Any) -> Self? {
        switch object {
        case let str as String:
            return Self(str, radix: 10)
        case let num as NSNumber:
            return Self(num)
        default:
            return nil
        }
    }
}

extension Int: IntegerPropertyProtocol {}
extension UInt: IntegerPropertyProtocol {}
extension Int8: IntegerPropertyProtocol {}
extension Int16: IntegerPropertyProtocol {}
extension Int32: IntegerPropertyProtocol {}
extension Int64: IntegerPropertyProtocol {}
extension UInt8: IntegerPropertyProtocol {}
extension UInt16: IntegerPropertyProtocol {}
extension UInt32: IntegerPropertyProtocol {}
extension UInt64: IntegerPropertyProtocol {}

// MARK: Bool类型
extension Bool: BuiltInBasicTypeProtocol {
    static func transform(from object: Any) -> Bool? {
        switch object {
        case let str as NSString:
            let lowerCase = str.lowercased
            if ["0", "false"].contains(lowerCase) {
                return false
            }
            if ["1", "true"].contains(lowerCase) {
                return true
            }
            return nil
        case let num as NSNumber:
            return num.boolValue
        default:
            return nil
        }
    }
}

// MARK: 浮点型协议
protocol FloatPropertyProtocol: BuiltInBasicTypeProtocol, LosslessStringConvertible {
    init(_ number: NSNumber)
}

extension FloatPropertyProtocol {
    static func transform(from object: Any) -> Self? {
        switch object {
        case let str as String:
            return Self(str)
        case let num as NSNumber:
            return Self(num)
        default:
            return nil
        }
    }
}

extension Float: FloatPropertyProtocol {}
extension Double: FloatPropertyProtocol {}

fileprivate let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = false
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 16
    return formatter
}()

// MARK: String类协议
extension String: BuiltInBasicTypeProtocol {
    static func transform(from object: Any) -> String? {
        switch object {
        case let str as String:
            return str
        case let num as NSNumber:
            // Boolean Type Inside
            if NSStringFromClass(type(of: num)) == "__NSCFBoolean" {
                if num.boolValue {
                    return "true"
                } else {
                    return "false"
                }
            }
            return formatter.string(from: num)
        case _ as NSNull:
            return nil
        default:
            return "\(object)"
        }
    }
}

extension Optional: BuiltInBasicTypeProtocol {
    static func transform(from object: Any) -> Optional? {
        // Wrapped 包裹
        if let value = (Wrapped.self as? BuiltInBasicTypeProtocol.Type)?.transform(from: object) as? Wrapped {
            return Optional(value)
        } else if let value = object as? Wrapped {
            return Optional(value)
        }
        return nil
    }
}

// MARK: 集合类型 实现
extension Collection {
    /// [Iterator.Element] 是什么？
    static func collectionTransform(from object: Any) -> [Iterator.Element]? {
        guard let arr = object as? [Any] else {
            return nil
        }
        
        typealias Element = Iterator.Element
        var result: [Element] = [Element]()
        arr.forEach { (each) in
            if let element = (Element.self as? BuiltInBasicTypeProtocol.Type)?.transform(from: each) as? Element {
                result.append(element)
            } else if let element = each as? Element {
                result.append(element)
            }
        }
        return result
    }
}

extension Array: BuiltInBasicTypeProtocol {
    static func transform(from object: Any) -> [Element]? {
        return self.collectionTransform(from: object)
    }
}

extension Set: BuiltInBasicTypeProtocol {
    static func transform(from object: Any) -> Set<Element>? {
        if let arr = self.collectionTransform(from: object) {
            return Set(arr)
        }
        return nil
    }
}


extension Dictionary: BuiltInBasicTypeProtocol {
    static func transform(from object: Any) -> [Key: Value]? {
        guard let dict = object as? [String: Any] else {
            print("Expect object to be an NSDictionary but it's not")
            return nil
        }
        var result = [Key: Value]()
        for (key, value) in dict {
            if let sKey = key as? Key {
                if let nValue = (Value.self as? BuiltInBasicTypeProtocol.Type)?.transform(from: value) as? Value {
                    result[sKey] = nValue
                } else if let nValue = value as? Value {
                    result[sKey] = nValue
                }
            }
        }
        return result
    }
}
