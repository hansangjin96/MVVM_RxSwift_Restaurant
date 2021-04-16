//
//  ServiceProvider.swift
//  MVVM_RxSwift_Restaurant
//
//  Created by 한상진 on 2021/04/14.
//

import Foundation

protocol ServiceProviderType {
    var networkService: NetworkServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
    lazy var networkService: NetworkServiceType = NetworkService(provider: self)
}
