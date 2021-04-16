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
    
    var singerNavi: UINavigationController {
        let vc = singerVC
        vc.viewModel = singerVM
        let navi = UINavigationController(rootViewController: vc)
        return navi
    }
    
    var singerVC: SingerVC {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyboard.instantiateInitialViewController() as! SingerVC
        
        return vc
    }
    
    var singerVM: SingerVM {
        return SingerVM(provider: serviceProvider)
    }
}
