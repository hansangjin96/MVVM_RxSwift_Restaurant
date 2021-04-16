//
//  UIView+isNotHidden.swift
//  KakacoCommerce
//
//  Created by 한상진 on 2021/04/11.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UIImageView {
    var isNotHidden: Binder<Bool> {
        return Binder(self.base) { view, bool in 
            view.isHidden = !bool
        }
    }
}
