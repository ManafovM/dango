//
//  Artist.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/01.
//

import Foundation

struct Artist: Codable, Identifiable {
    let id: Int
    let name: String
    let stageName: String?
    let role: String
}
