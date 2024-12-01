//
//  Video.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/01.
//

import Foundation

struct Video {
    let title: String
    let year: Int
    let duration: Int
    let description: String
    let synopsis: String
    let genres: [Genre]
    let cast: [Artist]
    let thumbnailUrl: String
    let videoUrl: String
}
