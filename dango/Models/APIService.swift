//
//  APIService.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/01.
//

import UIKit

struct VideoByIdRequest: APIRequest {
    typealias Response = [Video]
    
    var path: String { "/api/videos" }
    var id: Int
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "filters[id][$eq]", value: "\(id)")]
    }
}

struct FeaturedVideosRequest: APIRequest {
    typealias Response = [Video]
    
    var path: String { "/api/featured" }
}

struct RecentlyPlayedVideosRequest: APIRequest {
    typealias Response = [Video]
    
    var path: String { "/api/videos/recently-played" }
}

struct RecommendationsRequest: APIRequest {
    typealias Response = [Recommendation]
    
    var path: String { "/api/recommendations" }
}

struct RelatedVideosRequest: APIRequest {
    typealias Response = [Video]
    
    var path: String { "api/related" }
}

struct ImageRequest: APIRequest {
    typealias Response = UIImage
    
    var imagePath: String
    
    var path: String { imagePath }
}
