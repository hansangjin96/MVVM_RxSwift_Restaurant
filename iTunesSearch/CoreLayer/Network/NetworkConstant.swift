//
//  NetworkConstant.swift
//  iTunesSearch
//
//  Created by 한상진 on 2021/04/16.
//

import Foundation

enum Server {
    static let baseURL: String = "https://itunes.apple.com/search"
}

enum HTTPHeaderField {    
    static let authorization: String = "Authorization"
    static let contentType: String = "Content-Type"
    
    enum ContentType {
        static let json: String = "application/json"
    }
}

enum NetworkError: Error {
    case decodeFailure
    case fetchFailure
}
