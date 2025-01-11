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
    
    var watchHistory: [Video] {
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
    
    mutating func watched(_ video: Video) {
        var watched = self.watchHistory
        
        if !watched.contains(video) {
            watched.insert(video, at: 0)
        }
        
        self.watchHistory = watched
    }
}

struct Setting {
    static let myList = "myList";
    static let watchHistory = "watchHistory"
}
