//
//  APIService.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/01.
//

import UIKit

struct VideosByIdsRequest: APIRequest {
    typealias Response = [Video]
    
    var path: String { "/api/videos" }
    var ids: [Int]
    var queryItems: [URLQueryItem]? {
        var items = [URLQueryItem]()
        for (index, id) in ids.enumerated() {
            items.append(URLQueryItem(name: "filters[id][$in][\(index)]", value: "\(id)"))
        }
        return items
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

struct SearchRequest: APIRequest {
    typealias Response = [Video]
    
    var path: String { "/api/videos" }
    var searchTerm: String
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "filters[title][$contains]", value: searchTerm)]
    }
}

struct TagSearchRequest: APIRequest {
    typealias Response = [Video]
    
    var path: String { "/api/videos" }
    var searchTerm: String
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "filters[tags][name][$eq]", value: searchTerm)]
    }
}

struct AllVideosRequest: APIRequest {
    typealias Response = [Video]
    
    var path: String { "/api/videos" }
}

struct ImageRequest: APIRequest {
    typealias Response = UIImage
    
    var imagePath: String
    
    var path: String { imagePath }
}
