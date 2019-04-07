//
//  ItemsTableViewController.swift
//  Instagram
//
//  Created by Chung Tran on 07/04/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import UIKit
import RealmSwift
import Unbox
import RxRealmDataSources

class ItemsTableViewController<T>: ItemsViewController<T> where T: Object, T: Unboxable {
    
    var dataSource: RxTableViewRealmDataSource<T>! {
        return nil
    }
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        tableView.estimatedRowHeight = 145
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func bindUI() {
        super.bindUI()
        
        // bind refreshControll to collectionView
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // bind viewModel
        viewModel.items
            .bind(to: tableView.rx.realmChanges(dataSource))
            .disposed(by: bag)
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
