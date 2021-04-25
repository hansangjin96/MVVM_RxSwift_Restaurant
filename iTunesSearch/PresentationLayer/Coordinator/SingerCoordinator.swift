//
//  SingerCoordinator.swift
//  iTunesSearch
//
//  Created by 한상진 on 2021/04/24.
//

import UIKit

protocol SingerCoordinatorType: CoordinatorType {
    func toDetail(with model: Itunes)
}

final class SingerCoordinator: SingerCoordinatorType {

    unowned let navi: UINavigationController
    
    init(navi: UINavigationController) {
        self.navi = navi
    }
    
    func start() {
        let vc = AppContainer.shared.getSingerVC(coordinator: self)
        navi.setViewControllers([vc], animated: true)
    }
    
    func toDetail(with model: Itunes) {
        let vc = AppContainer.shared.getSingerDetailVC(
            with: model,
            coordinator: self
        )
        navi.pushViewController(vc, animated: true)
    }
}
