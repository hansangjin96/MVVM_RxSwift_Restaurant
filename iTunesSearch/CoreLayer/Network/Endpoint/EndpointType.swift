//
//  EndpointType.swift
//  iTunesSearch
//
//  Created by 한상진 on 2021/04/17.
//

import Foundation

typealias HTTPHeaders = [String: String]
typealias Parameters = [String: Any?]

protocol EndpointType {
    var baseUrl: URL { get }
    var path: String? { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    func asURLRequest() throws -> URLRequest
}

enum HTTPMethod: String {
    case get = "GET"
}

enum HTTPTask {
    case request(urlParameters: Parameters)
}
