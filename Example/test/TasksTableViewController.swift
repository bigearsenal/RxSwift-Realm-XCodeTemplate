//
//  TasksTableViewController.swift
//  test
//
//  Created by Chung Tran on 07/04/2019.
//  Copyright (c) 2019 Chung Tran. All rights reserved.
//

import UIKit
import RxDataSources

class TasksTableViewController: ItemsTableViewController<Task> {
    var dataSource: RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, Task>>!
    @IBOutlet var statisticsLabel: UILabel!
    @IBOutlet var newTaskButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        configureDataSource()
        // Do any additional setup after loading the view.
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        // bind viewModel
        viewModel.sectionedItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    fileprivate func configureDataSource() {
        dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, Task>>(
            configureCell: {
                [weak self] dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaskItemCell", for: indexPath) as! TaskItemTableViewCell
                
                if let strongSelf = self,
                    let viewModel = strongSelf.viewModel as? TasksViewModel{
                    cell.configure(with: item, action: viewModel.onToggle(item: item))
                }
                return cell
            },

            titleForHeaderInSection: { dataSource, index in
                dataSource.sectionModels[index].model
            }
        )
    }

}
