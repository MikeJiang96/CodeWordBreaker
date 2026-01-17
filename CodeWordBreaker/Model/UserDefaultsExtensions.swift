//
//  UserDefaultsExtensions.swift
//  CodeWordBreaker
//
//  Created by Mike Jiang on 2026/1/17.
//

import Foundation

extension UserDefaults {
    static func incrementInt(forKey key: String, defaultValue: Int = 1) -> Int {
        return standard.incrementInt(forKey: key, defaultValue: defaultValue)
    }

    static func setInt(forKey key: String, value: Int) {
        standard.set(value, forKey: key)
    }

    func incrementInt(forKey key: String, defaultValue: Int) -> Int {
        let current: Int

        if object(forKey: key) == nil {
            current = defaultValue
        } else {
            current = integer(forKey: key) + 1
        }

        set(current, forKey: key)

        return current
    }

    func setInt(forKey key: String, value: Int) {
        set(value, forKey: key)
    }
}
