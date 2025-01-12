//
//  Settings.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/10.
//

import Foundation

struct Settings {
    static var shared = Settings()
    
    private let defaults = UserDefaults.standard
    
    private func archiveJSON<T: Encodable>(value: T, key: String) {
        let data = try! JSONEncoder().encode(value)
        let string = String(data: data, encoding: .utf8)
        defaults.set(string, forKey: key)
    }
    
    private func unarchiveJSON<T: Decodable>(key: String) -> T? {
        guard let string = defaults.string(forKey: key),
              let data = string.data(using: .utf8) else {
            return nil
        }
        return try! JSONDecoder().decode(T.self, from: data)
    }
}

extension Settings {
    var myList: [Video] {
        get {
            return unarchiveJSON(key: Setting.myList) ?? []
        }
        set {
            archiveJSON(value: newValue, key: Setting.myList)
        }
    }
    
    var watchHistory: [WatchHistory] {
        get {
            return unarchiveJSON(key: Setting.watchHistory) ?? []
        }
        set {
            archiveJSON(value: newValue, key: Setting.watchHistory)
        }
    }
    
    mutating func toggleMyList(_ video: Video) -> Bool {
        var myList = self.myList
        
        var added: Bool
        if myList.contains(video) {
            myList = myList.filter { $0 != video }
            added = false
        } else {
            myList.insert(video, at: 0)
            added = true
        }
        
        self.myList = myList
        return added
    }
    
    mutating func watched(videoId: Int, episodeNum: Int, timestampSec: Int) {
        var watched = self.watchHistory
        
        if let index = watched.firstIndex(where: { $0.videoId == videoId }) {
            watched[index].currentEpisodeNum = episodeNum
            watched[index].currentEpisodeTimestampSec = timestampSec
            watched[index].lastWatchedDate = Date.now
        } else {
            let history = WatchHistory(videoId: videoId, currentEpisodeNum: episodeNum, currentEpisodeTimestampSec: timestampSec, lastWatchedDate: Date.now)
            watched.append(history)
        }
        
        self.watchHistory = watched.sorted(by: <)
    }
}

struct Setting {
    static let myList = "myList";
    static let watchHistory = "watchHistory"
}
