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
//        static let pause: UIImage? = UIImage(named: "pause.fill")
    }
    
    // MARK: UI Property
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var playTimeLabel: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: Property
    
    private let avPlayer: AVPlayer = .init()
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Bind
    
    override func eventBind() {
        // 이전 버튼
        prevButton.rx.tap
            .mapToVoid()
            .bind(to: viewModel.prevAction)
            .disposed(by: disposeBag)
        
        // 다음 버튼
        nextButton.rx.tap
            .mapToVoid()
            .bind(to: viewModel.nextAction)
            .disposed(by: disposeBag)
        
        // 재생 버튼 
        playButton.rx.tap
            .map { [unowned self] _ -> Bool in 
                return !self.playButton.isSelected
            }
            .bind(to: viewModel.isSelectedAction)
            .disposed(by: disposeBag)
        
        viewModel.isSelectedAction
            .bind(to: playButton.rx.isSelected)
            .disposed(by: disposeBag)
        
    }
    
    override func stateBind() {
        
        // 제목
        viewModel.titleRelay
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        // 이미지
        viewModel.URLRelay
            .compactMap { $0 }
            .asDriverOnErrorJustComplete()
            .flatMapLatest { url -> Driver<UIImage> in
                // TODO: 이미지를 로드하는 것을 뷰에서 하기엔 로직 같고
                // 뷰모델에서 하기엔 UIImage를 뿌려주는 것은 UIKit을 상속해야하는데
                // UIImage를 UI로 볼 것인가 Data로 볼 것인가?
                ImageLoader.shared.loadImage(from: url)
                    .asDriverOnErrorJustComplete()
            }
            .drive(albumImageView.rx.image)
            .disposed(by: disposeBag)
        
        // 프로그래스 바
        viewModel.playProgressRelay
            .compactMap { $0 }
            .asDriverOnErrorJustComplete()
            .drive(progressBar.rx.value)
            .disposed(by: disposeBag)
        
        // 재생한 시간
        viewModel.currentTimeRelay
            .asDriverOnErrorJustComplete()
            // TODO: 얘 뷰모델로 올려야함
            .do(onNext: { [unowned self] time in
                guard let current = time.split(separator: ":").last,
                      let time = Double(current)
                      else { return }
                
                if time > 29.5 { self.playButton.isSelected = false }
            })
            .drive(currentTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 총 미리듣기 시간
        viewModel.totalTimeRelay
            .asDriverOnErrorJustComplete()
            .drive(playTimeLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

// MARK: Methods

private extension SingerDetailVC {

}
