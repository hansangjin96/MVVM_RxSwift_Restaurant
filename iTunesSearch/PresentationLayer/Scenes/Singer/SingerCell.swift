//
//  SingerCell.swift
//  MVVM_RxSwift_Restaurant
//
//  Created by 한상진 on 2021/04/16.
//

import UIKit

import RxSwift
import RxCocoa

final class SingerCell: UITableViewCell {
    @IBOutlet weak var singerImage: UIImageView!
    @IBOutlet weak var singerName: UILabel!
    @IBOutlet weak var songName: UILabel!
    
    private var disposeBag: DisposeBag = .init()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        disposeBag = .init()
    }
    
    func bind(with item: Itunes) {
        if let url = item.artworkUrl100 {
            ImageLoader.shared.loadImage(from: url)
                .asDriver { error -> Driver<UIImage> in
                    return Driver.empty()
                }
                .drive(singerImage.rx.image)
                .disposed(by: disposeBag)
        }
        
        singerName.text = item.artistName
        songName.text = item.trackName
    }
}
