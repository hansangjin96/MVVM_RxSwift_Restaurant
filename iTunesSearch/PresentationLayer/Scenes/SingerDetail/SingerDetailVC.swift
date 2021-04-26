//
//  SingerDetailVC.swift
//  iTunesSearch
//
//  Created by 한상진 on 2021/04/24.
//

import UIKit
import AVKit

import RxSwift
import RxCocoa

final class SingerDetailVC: BaseVC<SingerDetailVM> {
    
    // MARK: Constant
    
    private enum Image {
        static let pause: UIImage? = UIImage(named: "pause.fill")
    }
    
    // MARK: UI Property
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    // MARK: Property
    
    private let avPlayer: AVPlayer = .init()
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Bind
    
    override func eventBind() {
        playButton.rx.tap
            .do(onNext: { [unowned self] _ in
                self.togglePlayState()
            })
            .mapToVoid()
            .bind(to: viewModel.playAction)
            .disposed(by: disposeBag)
            
    }
    
    override func stateBind() {
        viewModel.URLRelay
            .compactMap { $0 }
            .asDriverOnErrorJustComplete()
            .flatMapLatest { url -> Driver<UIImage> in
                ImageLoader.shared.loadImage(from: url)
                    .asDriverOnErrorJustComplete()
            }
            .drive(albumImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.playItemRelay
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [unowned self] item in
                avPlayer.replaceCurrentItem(with: item)
            })
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
    }
}

// MARK: Methods

private extension SingerDetailVC {
    func togglePlayState() {
        if playButton.isSelected {
            avPlayer.pause()
        } else {
            avPlayer.play()
        }
        
        playButton.isSelected.toggle()
    }
}
