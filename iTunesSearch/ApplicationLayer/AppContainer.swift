//
//  AppContainer.swift
//  MVVM_RxSwift_Restaurant
//
//  Created by 한상진 on 2021/04/14.
//

import UIKit

class AppContainer {
    static let shared: AppContainer = .init()
    private init () {}
    
    var serviceProvider: ServiceProviderType {
        return ServiceProvider()
    }
    
    func getSingerVC(coordinator: SingerCoordinatorType) -> SingerVC {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyboard.instantiateInitialViewController() as! SingerVC
        vc.viewModel = SingerVM(provider: serviceProvider, coordinator: coordinator)
        return vc
    }
}
