//
//  ViewController.swift
//  MVVM_RxSwift_Restaurant
//
//  Created by 한상진 on 2021/04/14.
//

import UIKit

import RxCocoa
import RxSwift

final class SingerVC: UIViewController {
    
    // MARK: UI Property
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Property
    
    private var disposeBag: DisposeBag = .init()
    var viewModel: SingerVM!
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        bindViewModel()
    }
    
    // MARK: Method
    
    private func configureTableView() {
        let nib = UINib(nibName: SingerCell.reusableID, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: SingerCell.reusableID)
        tableView.rowHeight = 100
    }
}

// MARK: Bind

extension SingerVC {
    private func bindViewModel() {
        let viewWillApper = self.rx.viewWillAppear
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = SingerVM.Input(viewWillAppear: viewWillApper)
        
        let output = viewModel.transform(input)
        
        output.iTunes
            .drive(
                tableView.rx.items(
                    cellIdentifier: SingerCell.reusableID,
                    cellType: SingerCell.self)
            ) { index, item, cell in
                cell.bind(with: item)
            }
            .disposed(by: disposeBag)
    }
}
