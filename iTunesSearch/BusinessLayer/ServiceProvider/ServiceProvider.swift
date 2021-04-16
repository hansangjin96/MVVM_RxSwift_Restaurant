//
//  ServiceProvider.swift
//  MVVM_RxSwift_Restaurant
//
//  Created by 한상진 on 2021/04/14.
//

import Foundation

protocol ServiceProviderType {
    var networkService: NetworkManagerType { get }
}

final class ServiceProvider: ServiceProviderType {
    lazy var networkService: NetworkManagerType = NetworkManager()
}
