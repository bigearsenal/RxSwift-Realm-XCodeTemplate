//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxDataSources

class ___VARIABLE_entityName___sTableViewController: ItemsTableViewController<___VARIABLE_entityName___> {
    var dataSource: RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, ___VARIABLE_entityName___>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        #warning("edit row height")
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
        dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, ___VARIABLE_entityName___>>(
            configureCell: {
                [weak self] dataSource, tableView, indexPath, item in
                #warning("configure dataSource")
                return UITableViewCell()
            },

            titleForHeaderInSection: { dataSource, index in
                #warning("title for section")
//                dataSource.sectionModels[index].model
            }
        )
    }

}
