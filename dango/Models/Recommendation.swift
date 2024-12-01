//
//  Recommendation.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/01.
//

import Foundation

struct Recommendation: Codable {
    let name: String
    let description: String
    let videos: [Video]
}
