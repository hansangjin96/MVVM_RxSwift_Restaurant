//
//  Encoder.swift
//  KakacoCommerce
//
//  Created by 한상진 on 2021/04/10.
//

import Foundation

protocol ParameterEncoder {
    static func addQueryItem(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

enum URLParameterEncoder: ParameterEncoder {
    static func addQueryItem(
        urlRequest: inout URLRequest,
        with parameters: Parameters
    ) throws {
        guard let url = urlRequest.url else { return }
                
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
           !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters.compactMapValues({ $0 }) {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                
                urlComponents.queryItems?.append(queryItem)
            }
            
            urlRequest.url = urlComponents.url
            
            Logger.info(urlRequest.url)
        }
    }
}
