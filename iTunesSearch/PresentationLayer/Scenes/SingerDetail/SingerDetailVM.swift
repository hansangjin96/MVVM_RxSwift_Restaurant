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

// MARK: Constant

struct MusicInfo {
    let index: IndexPath
    let musics: [Itunes]
}

final class SingerDetailVM: ViewModelType {
    
    // MARK: Action
    
    let nextAction: PublishRelay<Void> = .init()
    let prevAction: PublishRelay<Void> = .init()
    let isSelectedAction: PublishRelay<Bool> = .init()
    
    // MARK: State
    
    let titleRelay: BehaviorRelay<String?> = .init(value: "")
    let URLRelay: BehaviorRelay<String?> = .init(value: nil)
    
    let playProgressRelay: BehaviorRelay<Float?> = .init(value: 0)
    let currentTimeRelay: BehaviorRelay<String> = .init(value: "00:00")
    let totalTimeRelay: BehaviorRelay<String> = .init(value: "-:-")
    
    let avPlayerRelay: PublishRelay<AVPlayer?> = .init()
    
    // MARK: Property
    
    private let provider: ServiceProviderType
    private let coordinator: SingerCoordinatorType
    
    private var disposeBag: DisposeBag = .init()
    private let avPlayer: AVPlayer = .init()
    private let model: MusicInfo
    
    // TODO: Relay로?
    private var currentIndex: Int

    // MARK: Init
    
    init(
        with model: MusicInfo,
        provider: ServiceProviderType,
        coordinator: SingerCoordinatorType
    ) {
        self.provider = provider
        self.coordinator = coordinator
        self.model = model
        self.currentIndex = model.index.row
    }
    
    func start() {
        bindTitle()
        bindURL()
        bindPlayButton()
        bindPrevButton()
        bindNextButton()
    }
}

// MARK: Binds

private extension SingerDetailVM {
    func bindTitle() {
        let title = currentMusic().trackName
        Observable.just(title)
            .bind(to: titleRelay)
            .disposed(by: disposeBag)
    }
    
    func bindURL() {
        guard let url = currentMusic().artworkUrl100 else { return }
        
        URLRelay.accept(url)
    }
    
    func bindPlayButton() {
        bindAvPlayer()
        bindPlayTime()
    }
    
    func bindAvPlayer() {        
        guard let urlStr = currentMusic().previewUrl,
              let url = URL(string: urlStr)
        else { return }
        
        let item = AVPlayerItem(url: url)
        
        avPlayer.replaceCurrentItem(with: item)
        
        isSelectedAction
            .asObservable()
            .map { [weak self] isSelected -> AVPlayer? in
                guard let self = self else { return nil }
                
                isSelected ? self.avPlayer.play() : self.avPlayer.pause()
                return self.avPlayer
            }
            .bind(to: avPlayerRelay)
            .disposed(by: disposeBag)
    }
    
    func bindPlayTime() {
        let itemObservable = Observable<Int>.interval(
            .milliseconds(100),
            scheduler: MainScheduler.instance
        )
        .withLatestFrom(isSelectedAction)
        .map { [weak self] _ -> AVPlayer? in
            guard let self = self else { return nil }
            return self.avPlayer
        }
        .share(replay: 1)
        
        itemObservable
            .compactMap { $0 }
            .map { player -> Float in
                let time = player.currentTime()
                guard let duration = player.currentItem?.duration else { return 0.0 }
                
                return Float(CMTimeGetSeconds(time)/CMTimeGetSeconds(duration))
            }
            .bind(to: playProgressRelay)
            .disposed(by: disposeBag)
        
        itemObservable
            .compactMap { $0 }
            .map { player -> String in 
                let time = player.currentTime()
                let currentTime = CMTimeGetSeconds(time).rounded()
                
                if currentTime.isZero || currentTime.isNaN {
                    return "00:00"
                }
                
                let intTime = Int(currentTime)
                
                return intTime >= 10 ? "00:\(intTime)" : "00:0\(intTime)" 
            }
            .bind(to: currentTimeRelay)
            .disposed(by: disposeBag)
        
        itemObservable
            .compactMap { $0 }
            .map { player -> String in 
                guard let time = player.currentItem?.duration else  { return "-:-" }
                let totalTime = CMTimeGetSeconds(time).rounded()
                
                if totalTime.isZero || totalTime.isNaN {
                    return "-:-"
                }
                
                return "00:\(Int(totalTime))" 
            }
            .bind(to: totalTimeRelay)
            .disposed(by: disposeBag)
    }
    
    
    // TODO: 어떻게 잘 하면 합칠 수 있을거 같은데
    func bindPrevButton() {
        prevAction
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.changeMusice(next: false)
            })
            .disposed(by: disposeBag)
    }
    
    func bindNextButton() {
        nextAction
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.changeMusice(next: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Method

private extension SingerDetailVM {
    func currentMusic() -> Itunes {
        return model.musics[currentIndex]
    }
    
    func changeMusice(next: Bool) {
        calculateIndex(next: next)
        avPlayer.pause()
        disposeBag = DisposeBag()
        start()
        isSelectedAction.accept(true)
    }
    
    func calculateIndex(next: Bool) {
        if next {
            guard currentIndex < model.musics.count - 1 else { return }
            currentIndex += 1
        } else {
            guard currentIndex >= 1 else { return }
            currentIndex -= 1    
        }
    }
}
