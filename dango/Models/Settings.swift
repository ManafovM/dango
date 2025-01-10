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
    
    mutating func toggleMyList(_ video: Video) -> Bool {
        var myList = self.myList
        
        var added: Bool
        if myList.contains(video) {
            myList = myList.filter { $0 != video }
            added = false
        } else {
            myList.append(video)
            added = true
        }
        
        self.myList = myList
        return added
    }
}

struct Setting {
    static let myList = "myList";
}
