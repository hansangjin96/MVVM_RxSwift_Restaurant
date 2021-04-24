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
    
    // MARK: State
    
    let searchResultRelay: BehaviorRelay<[Itunes]> = .init(value: [])
    let queryRelay: BehaviorRelay<String> = .init(value: "")
    
    // MARK: Event
    
    let cellClickEvent: PublishRelay<Itunes> = .init()
    let errorEvent: PublishRelay<Error> = .init()
    
    private let provider: ServiceProviderType
    private let coordinator: SingerCoordinatorType
    
    private var disposeBag: DisposeBag = .init()
    
    init(
        provider: ServiceProviderType,
        coordinator: SingerCoordinatorType
    ) {
        self.provider = provider
        self.coordinator = coordinator
    }
    
    func start() {
        queryRelay
            .debounce(
                .milliseconds(100),
                scheduler: ConcurrentDispatchQueueScheduler.init(qos: .utility)
            )
            .flatMapLatest { [weak self] query -> Driver<[Itunes]> in
                guard let self = self else { return Driver.empty() }
                
                let endpoint: Endpoint = .fetchSinger(term: query)
                
                return self.provider.networkService
                    .fetchData(endpoint: endpoint, ResultBase.self)
                    .map { $0.results }
                    .asDriver { [weak self] error -> Driver<[Itunes]> in
                        self?.errorEvent.accept(error)
                        return Driver.empty()
                    }
            }
            .bind(to: searchResultRelay)
            .disposed(by: disposeBag)
        
        cellClickEvent
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] in
                print($0)
                self?.coordinator.toDetail()
            })
            .disposed(by: disposeBag)
    }
}
