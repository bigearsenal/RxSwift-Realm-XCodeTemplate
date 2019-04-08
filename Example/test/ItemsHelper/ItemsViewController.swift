//
//  ItemsListViewController.swift
//  Instagram
//
//  Created by Chung Tran on 03/04/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import UIKit
import RealmSwift
import Unbox
import RxSwift
import JGProgressHUD
import RxDataSources

class ItemsViewController<T>: UIViewController, BindableType where T: Object, T: IdentifiableType, T: Mockable {
    
    var viewModel: ItemsViewModel<T>!
    
    // dispose bag
    internal let bag = DisposeBag()

    // MARK: - Lifecycle
    func bindViewModel() {
        // for inheritting
    }
    
    func fetchNext() {
        self.viewModel.fetchNext()
            .subscribe(
                onCompleted: {
                    self.endRefreshing()
                },
                onError: { [weak self] error in
                    self?.endRefreshing()
                    print(error)
//                    guard let self = self else {return}
//                    let hud = JGProgressHUD(style: .dark)
//                    hud.textLabel.text = "Can not retrieve items.\nPlease check your internet connection"
//                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
//                    hud.isUserInteractionEnabled = true
//                    hud.show(in: self.view)
//                    hud.dismiss(afterDelay: 3)
            })
            .disposed(by: self.bag)
    }
    
    @objc func refresh() {
        self.viewModel.refreshFetcher()
        fetchNext()
    }
    
    func endRefreshing() {
        // for inheriting
    }
}
