//
//  APIService.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/01.
//

import Foundation

struct VideoRequest: APIRequest {
    typealias Response = [String: [Video]]
    
    var tag: String?
    
    var path: String { "/videos" }
}
