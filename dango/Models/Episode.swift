//
//  Episode.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/05.
//

import Foundation

struct Episode: Codable {
    let id: Int
    let number: Int
    let title: String
    let duration: Int
    let description: String
    let thumbnailUrl: String
    let videoUrl: String
}

extension Episode: Identifiable { }

extension Episode: Equatable {
    static func == (lhs: Episode, rhs: Episode) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Episode: Comparable {
    static func < (lhs: Episode, rhs: Episode) -> Bool {
        return lhs.number < rhs.number
    }
}
