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
        let iTunes: Driver<[Itunes]>
        let errorResult: Driver<Error>
    }
    
    private let provider: ServiceProviderType
    
    init(provider: ServiceProviderType) {
        self.provider = provider
    }
    
    func transform(_ input: Input) -> Output {
        let errorSubject: PublishSubject<Error> = .init() 
        
        let iTunes = input.viewWillAppear
            .flatMapLatest { [weak self] _ -> Driver<[Itunes]> in
                guard let self = self else { return Driver.empty() }
                
                let endpoint: Endpoint = .fetchSinger(term: "Ed+Sheeran", entity: "song") 
                return self.provider.networkService
                    .fetchData(endpoint: endpoint, ResultBase.self)
                    .map { $0.results }
                    .asDriver { error -> Driver<[Itunes]> in
                        errorSubject.onNext(error)
                        return Driver.empty()
                    }
            }
        
        let errorResult = errorSubject.asDriverOnErrorJustComplete()
        
        return Output(
            iTunes: iTunes,
            errorResult: errorResult
        )
    }
    
    func fetchItunesResult() {
        
    }
}
