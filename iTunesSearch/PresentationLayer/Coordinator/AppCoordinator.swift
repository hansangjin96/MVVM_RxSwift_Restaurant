//
//  AppCoordinator.swift
//  MVVM_RxSwift_Restaurant
//
//  Created by 한상진 on 2021/04/14.
//

import UIKit

final class AppCoordinator: CoordinatorType {
    private let window: UIWindow
    private let navi: UINavigationController = .init()
    
    var isLoggedIn: Bool = true
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = navi
        window.makeKeyAndVisible()
        
        if isLoggedIn {
            showSinger()
        } else {
            showLogin()
        }
    }
    
    private func showLogin() {
        
    }
    
    private func showSinger() {
        let coordinator = SingerCoordinator(navi: navi)
        coordinator.start()
    }
}
