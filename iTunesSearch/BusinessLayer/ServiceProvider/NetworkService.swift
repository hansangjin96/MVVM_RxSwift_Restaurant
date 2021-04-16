//
//  NetworkService.swift
//  MVVM_RxSwift_Restaurant
//
//  Created by 한상진 on 2021/04/14.
//

import Foundation

import RxSwift

protocol NetworkServiceType {
    
}

struct NetworkService: NetworkServiceType {
    private let provider: ServiceProviderType
    
    init(provider: ServiceProviderType) {
        self.provider = provider
    }
}
