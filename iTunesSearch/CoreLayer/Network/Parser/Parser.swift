//
//  Parser.swift
//  KakacoCommerce
//
//  Created by 한상진 on 2021/04/08.
//

import Foundation

protocol ParserType {
    static func parse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?) -> Result<T, Error> 
}

enum Parser: ParserType {
    static func parse<T: Decodable>(
        data: Data?,
        response: URLResponse?, 
        error: Error?
    ) -> Result<T, Error> {
        if error.isSome {
            return .failure(NetworkError.fetchFailure)
        }
        
        guard let response = response as? HTTPURLResponse else { return .failure(NetworkError.fetchFailure) }

        Logger.info("response.statusCode: \(response.statusCode)")
        
        switch response.statusCode {
        case 200...299:
            guard let data = data else {
                return .failure(NetworkError.decodeFailure) 
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(T.self, from: data)
                return .success(result)
            } catch {
                return .failure(NetworkError.decodeFailure)
            }
        default:
//            if let networkError = NetworkError(rawValue: response.statusCode) {
//                return .failure(networkError)
//            }
            
            return .failure(NetworkError.decodeFailure)
        }
    }
}
