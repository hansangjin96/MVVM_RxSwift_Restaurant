//
//  ViewController.swift
//  MVVM_RxSwift_Restaurant
//
//  Created by 한상진 on 2021/04/14.
//

import UIKit

import RxCocoa
import RxSwift

final class MainVC: UIViewController {
    
    // MARK: UI Property
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Property
    
    private var disposeBag: DisposeBag = .init()
    var viewModel: MainVM!
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
}

// MARK: Bind

extension MainVC {
    private func bindViewModel() {
        let viewWillApper = self.rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in }
            .asDriver { error -> Driver<()> in
                return Driver.empty()
            }
        
        let input = MainVM.Input(viewWillAppear: viewWillApper)
        
        let output = viewModel.transform(input)
        
        output.restaurants
            .drive(tableView.rx.items(cellIdentifier: "Cell")) { index, item, cell in
                cell.textLabel?.text = item.displayText
            }
            .disposed(by: disposeBag)
    }
}
