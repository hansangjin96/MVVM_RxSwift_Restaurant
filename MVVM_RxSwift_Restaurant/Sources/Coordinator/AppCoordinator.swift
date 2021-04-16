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
        let vm = AppContainer.shared.mainVM
        let vc = AppContainer.shared.mainVC
        vc.viewModel = vm
        
        let nav = UINavigationController(rootViewController: vc)
        
        window.rootViewController = nav
        window.makeKeyAndVisible()
    }
}
