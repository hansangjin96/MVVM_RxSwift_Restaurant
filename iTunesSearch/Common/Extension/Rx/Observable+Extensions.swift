//
//  Observable+Extension.swift
//  KakacoCommerce
//
//  Created by 한상진 on 2021/04/09.
//

import RxCocoa
import RxSwift

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            Logger.info(error)
            
            return Driver.empty()
        }
    }
}
