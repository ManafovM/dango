//
//  Tag.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/01.
//

import Foundation

struct Tag: Codable {
    let name: String
    let description: String?
}

extension Tag: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.name == rhs.name
    }
}
