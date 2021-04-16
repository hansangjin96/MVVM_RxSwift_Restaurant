//
//  NetworkManager.swift
//  iTunesSearch
//
//  Created by 한상진 on 2021/04/16.
//

import Foundation

import RxSwift

protocol URLSessionType {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionType { }

protocol NetworkManagerType {
    func fetchData<T: Decodable>(
        endpoint: Endpoint,
        _ type: T.Type
    ) -> Single<T>
    func fetchDatas<T: Decodable>(
        endpoint: Endpoint,
        _ type: T.Type
    ) -> Single<[T]>
}

final class NetworkManager: NetworkManagerType {
    private let session: URLSessionType
    private var task: URLSessionTask?
    
    init(session: URLSessionType = URLSession.shared) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(
        endpoint: Endpoint,
        _ type: T.Type
    ) -> Single<T> {
        return Single.create { [weak self] single -> Disposable in
            guard let self = self else { return Disposables.create() }
            
            do {
                let request = try endpoint.asURLRequest()
                
                let test = URLSession(configuration: .default)
                
                self.task = test.dataTask(with: request) { data, response, error in
                    let result: Result<T, Error> = Parser.parse(data: data,
                                                                response: response, 
                                                                error: error)
                    
                    switch result {
                    case let .success(successResult):
                        single(.success(successResult))
                    case let .failure(error):
                        single(.failure(error))
                    }
                }
            } catch {
                single(.failure(error))
            }
            
            self.task?.resume()
            
            return Disposables.create { [weak self] in
                self?.task?.cancel()
            }
        }
    }
    
    func fetchDatas<T: Decodable>(
        endpoint: Endpoint,
        _ type: T.Type
    ) -> Single<[T]> {
        return Single.create { observer -> Disposable in
            
            
            
            return Disposables.create()
        }
    }
}

