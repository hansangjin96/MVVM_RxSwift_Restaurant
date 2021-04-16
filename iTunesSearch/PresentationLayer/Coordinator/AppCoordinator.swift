//
//  AppCoordinator.swift
//  MVVM_RxSwift_Restaurant
//
//  Created by 한상진 on 2021/04/14.
//

import UIKit

final class AppCoordinator: CoordinatorType {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = AppContainer.shared.singerNavi
        window.makeKeyAndVisible()
    }
}
