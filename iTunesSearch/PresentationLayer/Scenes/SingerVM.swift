//
//  MainVM.swift
//  MVVM_RxSwift_Restaurant
//
//  Created by 한상진 on 2021/04/14.
//

import Foundation

import RxCocoa
import RxSwift

final class SingerVM: ViewModelType {
    struct Input {
        let viewWillAppear: Driver<Void>
    }
    
    struct Output {
        let restaurants: Driver<[Restaurant]>
    }
    
    private let provider: ServiceProviderType
    
    init(provider: ServiceProviderType) {
        self.provider = provider
    }
    
    func transform(_ input: Input) -> Output {
        let restaurants = input.viewWillAppear
            .flatMapLatest { [weak self] _ -> Driver<[Restaurant]> in
                guard let self = self else { return Driver.empty() }
                
                return self.provider.networkService.fetchRestaurant()
                    .asDriver(onErrorJustReturn: [])
            }
        
        return Output(restaurants: restaurants)
    }
    
    func fetchItunesResult() {
        
    }
}
