//
//  WatchHistory.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/12.
//

import Foundation

struct WatchHistory: Codable {
    let videoId: Int
    var currentEpisodeNum: Int
    var episodesTimestamps: [Int: Int]
    var lastWatchedDate: Date
}

extension WatchHistory: Comparable {
    static func < (lhs: WatchHistory, rhs: WatchHistory) -> Bool {
        return lhs.lastWatchedDate > rhs.lastWatchedDate
    }
}
