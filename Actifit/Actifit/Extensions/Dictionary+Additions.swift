//
//  Dictionary+Additions.swift
//  Actifit
//
//  Created by Hitender kumar on 29/06/18.
//  Copyright © 2018 actifit.io. All rights reserved.
//

import Foundation
import UIKit

extension Dictionary {
    mutating public func setValue(value: Any, forKeyPath keyPath: String) {
        var keys = keyPath.components(separatedBy: ".")
        guard let first = keys.first as? Key else { print("Unable to use string as key on type: \(Key.self)"); return }
        keys.remove(at: 0)
        if keys.isEmpty, let settable = value as? Value {
            self[first] = settable
        } else {
            let rejoined = keys.joined(separator: ".")
            var subdict: [NSObject : AnyObject] = [:]
            if let sub = self[first] as? [NSObject : AnyObject] {
                subdict = sub
            }
            subdict.setValue(value: value, forKeyPath: rejoined)
            if let settable = subdict as? Value {
                self[first] = settable
            } else {
                print("Unable to set value: \(subdict) to dictionary of type: \(type(of: self))")
            }
        }
        
    }
    
    public func valueForKeyPath(keyPath: String) -> Any? {
        var keys = keyPath.components(separatedBy: ".")
        guard let first = keys.first as? Key else { print("Unable to use string as key on type: \(Key.self)"); return nil }
        guard let value = self[first] else { return nil }
        keys.remove(at: 0)
        if !keys.isEmpty, let subDict = value as? [NSObject : AnyObject] {
            let rejoined = keys.joined(separator: ".")
            
            return subDict.valueForKeyPath(keyPath: rejoined)
        }
        return value
    }
}

extension Dictionary {
    
    // string value, default is empty string
    func stringValue(forKey aKey: String) -> String {
        if let value = self.valueForKeyPath(keyPath: aKey) {
            if value is NSNull {
                return ""
            } else if let s = value as? String {
                if s == "<null>" {
                    return ""
                }
            }
            return "\(value)"
        }
        return ""
    }
    
    //optional string
    func string(forKey aKey: String) -> String? {
        if let value = self.valueForKeyPath(keyPath: aKey) {
            if value is NSNull {
                return nil
            } else if let optionalString = value as? String {
                if optionalString == "<null>" {
                    return nil
                } else {
                    return optionalString
                }
            }
        }
        return nil
    }
    
    // int value, default is 0
    func intValue(forKey aKey: String) -> Int {
        if let value = self.valueForKeyPath(keyPath: aKey) {
            if value is NSNull {
                return 0
            } else if let v = value as? String {
                if v == "<null>" {
                    return 0
                }
            } else if let intVal = value as? Int {
                return intVal
            }
        }
        return 0
    }
    
    // optional int value
    func int(forKey aKey: String) -> Int? {
        if let value = self.valueForKeyPath(keyPath: aKey) {
            return value as? Int
        }
        return nil
    }
    
    // bool value, default is false
    func boolValue(forKey aKey: String) -> Bool {
        if let value = self.valueForKeyPath(keyPath: aKey) {
            if value is NSNull {
                return false
            } else if let v = value as? String {
                if v == "<null>" {
                    return false
                }
            } else if let boolVal = value as? Bool {
                return boolVal
            }
        }
        return false
    }
    
    // optional bool value
    func bool(forKey aKey: String) -> Bool? {
        if let value = self.valueForKeyPath(keyPath: aKey) {
            return value as? Bool
        }
        return nil
    }
    
    // double value, default is 0.0
    func doubleValue(forKey aKey: String) -> Double {
        if let value = self.valueForKeyPath(keyPath: aKey) {
            if value is NSNull {
                return 0.0
            } else if let v = value as? String {
                if v == "<null>" {
                    return 0.0
                }
            } else if let doubleVal = value as? Double {
                return doubleVal
            }
        }
        return 0.0
    }
    
    // optional double value
    func double(forKey aKey: String) -> Double? {
        if let value = self.valueForKeyPath(keyPath: aKey) {
            return value as? Double
        }
        return nil
    }
    
    // float value, default is 0.0
    func floatValue(forKey aKey: String) -> CGFloat {
        if let value = self.valueForKeyPath(keyPath: aKey) {
            if value is NSNull {
                return 0.0
            } else if let v = value as? String {
                if v == "<null>" {
                    return 0.0
                }
            } else if let floatVal = value as? CGFloat {
                return floatVal
            }
        }
        return 0.0
    }
    
    // optional float value
    func float(forKey aKey: String) -> CGFloat? {
        if let value = self.valueForKeyPath(keyPath: aKey) {
            return value as? CGFloat
        }
        return nil
    }
    
    
    //error message
    
    func errorMessage() -> String {
        var errorMsg = Messages.InternalServerError
        if let errorInfo = self.valueForKeyPath(keyPath: "errors") as? [String : Any] {
            if let errors = (errorInfo.values.first as? [String]) {
                if errors.count > 0 {
                    errorMsg = errors[0]
                }
            }
        } else if let message = self.valueForKeyPath(keyPath: "message") as? String {
            errorMsg  = message
        }
        return errorMsg
    }
}
