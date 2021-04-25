//
//  SingerDetailVM.swift
//  iTunesSearch
//
//  Created by 한상진 on 2021/04/25.
//

import Foundation
import AVKit

import RxCocoa
import RxSwift

final class SingerDetailVM: ViewModelType {
    
    // MARK: Action
    
    let playAction: PublishRelay<Void> = .init()
    
    // MARK: State
    
    let URLRelay: BehaviorRelay<String?> = .init(value: nil)
    let playItemRelay: PublishRelay<AVPlayerItem> = .init()
    
    // MARK: Property
    
    private let provider: ServiceProviderType
    private let coordinator: SingerCoordinatorType
    
    private var disposeBag: DisposeBag = .init()
    private let model: Itunes
    
    // MARK: Init
    
    init(
        with model: Itunes,
        provider: ServiceProviderType,
        coordinator: SingerCoordinatorType
    ) {
        self.provider = provider
        self.coordinator = coordinator
        self.model = model
    }
    
    func start() {
        bindURL()
        bindPlayItem()
    }
}

// MARK: Binds

private extension SingerDetailVM {
    func bindURL() {
        guard let url = model.artworkUrl100 else { return }
        
        URLRelay.accept(url)
    }
    
    func bindPlayItem() {
        guard let urlStr = model.previewUrl,
              let url = URL(string: urlStr)
        else { return }
        
        let item = AVPlayerItem(url: url)
        
        playAction
            .asObservable()
            .map { item }
            .bind(to: playItemRelay)
            .disposed(by: disposeBag)
    }
}
