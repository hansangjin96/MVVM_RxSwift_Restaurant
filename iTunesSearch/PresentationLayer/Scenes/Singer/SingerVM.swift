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
    
    // MARK: Action
    
    let cellClickEvent: PublishRelay<(IndexPath, [Itunes])> = .init()
    let queryRelay: PublishRelay<String> = .init()
    
    // MARK: State
    
    let searchResultRelay: BehaviorRelay<[Itunes]> = .init(value: [])
    let errorEvent: PublishRelay<Error> = .init()
    
    // MARK: Property
    
    private let provider: ServiceProviderType
    private let coordinator: SingerCoordinatorType
    
    private var disposeBag: DisposeBag = .init()
    
    // MARK: Init
    
    init(
        provider: ServiceProviderType,
        coordinator: SingerCoordinatorType
    ) {
        self.provider = provider
        self.coordinator = coordinator
    }
    
    func start() {
        bindQuery()
        bindError()
    }
}

// MARK: binds

private extension SingerVM {
    func bindQuery() {
        queryRelay
            .debounce(
                .milliseconds(100),
                scheduler: ConcurrentDispatchQueueScheduler.init(qos: .utility)
            )
            .flatMapLatest { fetchSingerWithQuery(query: $0) }
            .bind(to: searchResultRelay)
            .disposed(by: disposeBag)
        
        // TODO: 중첩 함수에서 self는 weak처리 안해도 되려나?
        
        func fetchSingerWithQuery(query: String) -> Driver<[Itunes]> {
            let endpoint: Endpoint = .fetchSinger(term: query)
            
            return self.provider.networkService
                .fetchData(endpoint: endpoint, ResultBase.self)
                .map { $0.results }
                .asDriver { [weak self] error -> Driver<[Itunes]> in
                    self?.errorEvent.accept(error)
                    return Driver.empty()
                }
        }
    }
    
    func bindError() {
        cellClickEvent
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] in
                self?.coordinator.toDetail(with: MusicInfo(index: $0, musics: $1))
            })
            .disposed(by: disposeBag)
    }
}
