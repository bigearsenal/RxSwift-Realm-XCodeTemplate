//
//  ItemsTableViewController.swift
//  Instagram
//
//  Created by Chung Tran on 07/04/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import UIKit
import RealmSwift
import RxDataSources

class ItemsTableViewController<T>: ItemsViewController<T> where T: Object, T: IdentifiableType {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func bindViewModel() {
        // bind refreshControll to tableView
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        
        // fetchNext when reach last 20 point to the bottom
        tableView.rx.contentOffset
            .filter {$0.y + self.tableView.frame.size.height + 100 > self.tableView.contentSize.height}
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (_) in
                self?.fetchNext()
            })
            .disposed(by: bag)
    }
    
    override func endRefreshing() {
        tableView.refreshControl?.endRefreshing()
    }
}
