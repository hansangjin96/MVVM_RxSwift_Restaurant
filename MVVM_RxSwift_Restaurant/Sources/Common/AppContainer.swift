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
    
    var mainVC: MainVC {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyboard.instantiateInitialViewController() as! MainVC
        
        return vc
    }
    
    var mainVM: MainVM {
        return MainVM(provider: serviceProvider)
    }
}
