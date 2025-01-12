//
//  WatchHistory.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/12.
//

import Foundation

struct WatchHistory: Codable {
    let videoId: Int
    let currentEpisodeNum: Int
    let currentEpisodeTimestampSec: Int
    let lastWatchedDate: Date
}
