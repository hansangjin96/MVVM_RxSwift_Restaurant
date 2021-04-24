//
//  Endpoint.swift
//  iTunesSearch
//
//  Created by 한상진 on 2021/04/17.
//

import Foundation

enum Endpoint: EndpointType {
    case fetchSinger(term: String,
                     entity: String = "song")
    
    var baseUrl: URL {
        guard let url = URL(string: Server.baseURL) else {
            fatalError("baseURL is wrong")
        }
        
        return url
    }
    
    var path: String? {
        switch self {
        case .fetchSinger:
            return nil
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetchSinger:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case let .fetchSinger(term, entity):
            return .request(urlParameters: ["term": term, "entity": entity])
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .fetchSinger:
            return nil
        }
    }
}

extension Endpoint {
    func asURLRequest() throws -> URLRequest {
        var url = self.baseUrl
        
        if let path = self.path {
            url.appendPathComponent(path)
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = self.httpMethod.rawValue
        request.allHTTPHeaderFields = self.headers
        request.setValue(HTTPHeaderField.ContentType.json, 
                         forHTTPHeaderField: HTTPHeaderField.contentType)
        
        do {
            switch self.task {
            case let .request(params):
                try configureParameters(parameters: params, request: &request)
            }
            
            return request
        } catch {
            throw error
        }
    }
    
    private func configureParameters(parameters: Parameters?, request: inout URLRequest) throws {
        do {
            if let parameters = parameters {
                try URLParameterEncoder.addQueryItem(urlRequest: &request, with: parameters)
            }
        } catch {
            throw error
        }
    }
}
