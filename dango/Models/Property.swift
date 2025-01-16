//
//  Property.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/13.
//

import Foundation

struct Property {
    let key: String
    
    var value: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            fatalError("\(key) property is not set.")
        }
        return value
    }
}
