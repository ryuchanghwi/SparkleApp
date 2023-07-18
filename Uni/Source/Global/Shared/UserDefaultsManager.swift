//
//  UserDefaultsManager.swift
//  Uni
//
//  Created by 류창휘 on 2023/07/17.
//

import Foundation

enum Key: String {
    case hasOnboarded
    case hasCoupleCode
}

class UserDefaultsManager {
    
    let defaults = UserDefaults.standard
    static let shared = UserDefaultsManager()
    private init() {}
    
    var hasOnboarded: Bool {
        if load(.hasOnboarded) == nil {
            return false
        }
        else {
            return true
        }
    }
    var hasCoupleCode: Bool {
        if load(.hasCoupleCode) == nil {
            return false
        }
        else {
            return true
        }
    }
    
    func load(_ key: Key) -> Any? {
        switch key {
        case .hasOnboarded:
            return loadBool(key)
        case .hasCoupleCode:
            return loadBool(key)
        }
    }
    
    func loadBool(_ key: Key) -> Bool? {
        return defaults.object(forKey: key.rawValue) as? Bool
    }
    
    func save( value: Any, forkey key: Key) {
        defaults.set(value, forKey: key.rawValue)
    }
}
