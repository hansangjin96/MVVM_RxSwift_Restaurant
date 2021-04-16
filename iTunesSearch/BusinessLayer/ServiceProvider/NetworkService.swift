//
//  NetworkService.swift
//  MVVM_RxSwift_Restaurant
//
//  Created by 한상진 on 2021/04/14.
//

import Foundation

import RxSwift

enum NetworkError: Error {
    case decodeError
    case fetchError
}

protocol NetworkServiceType {
    func fetchRestaurant() -> Single<[Restaurant]>
}

final class NetworkService: NetworkServiceType {
    private let provider: ServiceProviderType 
    
    init(provider: ServiceProviderType) {
        self.provider = provider
    }
    
    func fetchRestaurant() -> Single<[Restaurant]> {
        return Single.create { observer -> Disposable in
            
            guard let path = Bundle.main.path(forResource: "members", ofType: "json") else {
                observer(.failure(NetworkError.fetchError))
                return Disposables.create()
            }
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let restaurants = try JSONDecoder().decode([Restaurant].self, from: data)
                observer(.success(restaurants))
            } catch {
                observer(.failure(NetworkError.decodeError))
            }
            
            return Disposables.create()
        }
    }
}
