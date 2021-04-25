//
//  BaseVC.swift
//  iTunesSearch
//
//  Created by 한상진 on 2021/04/24.
//

import UIKit

import RxSwift
import RxCocoa

class BaseVC<VM: ViewModelType>: UIViewController {
    var disposeBag: DisposeBag = .init()
    var viewModel: VM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupUI()
    }
    
    func bindViewModel() {
        viewModel.start()
        eventBind()
        stateBind()
    }
    
    func eventBind() {
        // no - op
    }
    
    func stateBind() {
        // no - op
    }
    
    func setupUI() {
        // no - op
    }
}
