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
    
    private enum Storyboard: String {
        case Singer
        case SingerDetail
    }
    
    var serviceProvider: ServiceProviderType {
        return ServiceProvider()
    }
    
    func getSingerVC(coordinator: SingerCoordinatorType) -> SingerVC {
        let storyboard = UIStoryboard(name: Storyboard.Singer.rawValue, bundle: .main)
        let vc = storyboard.instantiateViewController(identifier: SingerVC.reusableID) as! SingerVC
        vc.viewModel = SingerVM(provider: serviceProvider, coordinator: coordinator)
        return vc
    }
    
    func getSingerDetailVC(
        with model: MusicInfo,
        coordinator: SingerCoordinatorType
    ) -> SingerDetailVC {
        let storyboard = UIStoryboard(name: Storyboard.SingerDetail.rawValue, bundle: .main)
        let vc = storyboard.instantiateViewController(identifier: SingerDetailVC.reusableID) as! SingerDetailVC
        let vm = SingerDetailVM(
            with: model,
            provider: serviceProvider,
            coordinator: coordinator
        )
        vc.viewModel = vm
        return vc
    }
}
