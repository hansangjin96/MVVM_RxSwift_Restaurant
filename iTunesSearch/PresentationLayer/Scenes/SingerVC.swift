//
//  ViewController.swift
//  MVVM_RxSwift_Restaurant
//
//  Created by 한상진 on 2021/04/14.
//

import UIKit

import RxCocoa
import RxSwift

final class SingerVC: BaseVC<SingerVM> {
    
    // MARK: UI Property
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Property
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupUI()
    }
}

// MARK: Bind

private extension SingerVC {
    func bindViewModel() {
        eventBind()
        stateBind()
    }
    
    func eventBind() {
        // searchController 
        
        // TODO: ObservableType만 bind 가능한 지 다시 찾아보기
        tableView.rx.modelDeleted(Itunes.self)
            .bind(to: viewModel.cellClickEvent)
            .disposed(by: disposeBag)
    }
    
    func stateBind() {
        viewModel.searchResultRelay
            .asDriver()
            .drive(
                tableView.rx.items(
                    cellIdentifier: SingerCell.reusableID,
                    cellType: SingerCell.self
                )
            ) { index, item, cell in
                cell.bind(with: item)
            }
            .disposed(by: disposeBag)
        
        viewModel.errorEvent
            .asDriverOnErrorJustComplete()
            .drive(onNext: {
                Logger.info($0)
                // ErrorHandler
            })
            .disposed(by: disposeBag)
    }
}

// MARK: UI

private extension SingerVC {
    func setupUI() {
        configureTableView()
    }
    
    func configureTableView() {
        let nib = UINib(nibName: SingerCell.reusableID, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: SingerCell.reusableID)
        tableView.rowHeight = 100
    }
}
