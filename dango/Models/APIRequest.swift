//
//  APIRequest.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/01.
//

import UIKit

protocol APIRequest {
    associatedtype Response
    
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var request: URLRequest { get }
    var postData: Data? { get }
    var urlString: String? { get }
}

extension APIRequest {
    var host: String { Property(key: "API_HOST").value }
    var port: Int { 1337 }
    var apiKey: String { Property(key: "API_KEY").value }
}

extension APIRequest {
    var queryItems: [URLQueryItem]? { nil }
    var postData: Data? { nil }
    var urlString: String? { nil }
}

extension APIRequest {
    var request: URLRequest {
        var components = URLComponents()
        
        if Property(key: "ENVIRONMENT").value == "local" {
            components.scheme = "http"
            components.port = port
        } else {
            components.scheme = "https"
        }
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        var request: URLRequest
        if let urlString,
           let url = URL(string: urlString) {
            request = URLRequest(url: url)
        } else {
            request = URLRequest(url: components.url!)
        }
        
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        if let data = postData {
            request.httpBody = data
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
        }
        
        return request
    }
}

enum APIRequestError: Error {
    case itemsNotFound
    case requestFailed
}

extension APIRequest where Response: Decodable {
    func send() async throws -> Response {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIRequestError.itemsNotFound
        }
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Response.self, from: data)
        
        return decoded
    }
}

enum ImageRequestError: Error {
    case couldNotInitializeFromData
    case imageDataMissing
}

extension APIRequest where Response == UIImage {
    func send() async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ImageRequestError.imageDataMissing
        }
        
        guard let image = UIImage(data: data) else {
            throw ImageRequestError.couldNotInitializeFromData
        }
        
        return image
    }
}
