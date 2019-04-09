//
//  TasksTableViewController.swift
//  test
//
//  Created by Chung Tran on 09/04/2019.
//  Copyright (c) 2019 Chung Tran. All rights reserved.
//

import UIKit
import RxDataSources

class TasksTableViewController: ItemsTableViewController<Task>, UITableViewDelegate {
    var dataSource: RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, Task>>!
    
    @IBOutlet weak var newTaskButton: UIBarButtonItem!
    @IBOutlet weak var statisticsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.rx.setDelegate(self).disposed(by: bag)
        tableView.tableFooterView = UIView()
        
        configureDataSource()
        // Do any additional setup after loading the view.
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        // bind viewModel
        guard let viewModel = viewModel as? TasksViewModel else {return}
        
        viewModel.sectionedItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        newTaskButton.rx.action = viewModel.onCreate()
        
        tableView.rx.itemSelected
            .do(onNext: { [unowned self] indexPath in
                self.tableView.deselectRow(at: indexPath, animated: false)
            })
            .map {[unowned self] indexPath in
                try! self.dataSource.model(at: indexPath) as! Task
            }
            .subscribe(viewModel.editAction.inputs)
            .disposed(by: bag)
    }
    
    fileprivate func configureDataSource() {
        dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, Task>>(
            configureCell: {
                [weak self] dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
                if let viewModel = self?.viewModel as? TasksViewModel {
                    cell.update(with: item, action: viewModel.onToggleChecked(item))
                }
                return cell
            },

            titleForHeaderInSection: { dataSource, index in
                dataSource.sectionModels[index].model
            }
        )
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

}
