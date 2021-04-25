//
//  SingerDetailVC.swift
//  iTunesSearch
//
//  Created by 한상진 on 2021/04/24.
//

import UIKit

import RxSwift
import RxCocoa

final class SingerDetailVC: UIViewController {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    var disposeBag: DisposeBag = .init()
    
    var model: Itunes? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind(with: model)
    }
    
    func bind(with model: Itunes?) {
        if let url = model?.artworkUrl100 {
            ImageLoader.shared.loadImage(from: url)
                .asDriver { error -> Driver<UIImage> in
                    return Driver.empty()
                }
                .drive(albumImageView.rx.image)
                .disposed(by: disposeBag)
        }
    }
}
