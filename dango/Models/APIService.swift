//
//  APIService.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/01.
//

import Foundation

struct FeaturedVideosRequest: APIRequest {
    typealias Response = [Video]
    
    var path: String { "/api/videos/featured" }
}

struct RecentlyPlayedVideosRequest: APIRequest {
    typealias Response = [Video]
    
    var path: String { "/api/videos/recently-played" }
}

struct RecommendationsRequest: APIRequest {
    typealias Response = [Recommendation]
    
    var path: String { "/api/recommendations" }
}
