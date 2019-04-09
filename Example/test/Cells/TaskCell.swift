//
//  TaskCell.swift
//  test
//
//  Created by Chung Tran on 09/04/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import UIKit
import Action
import RxSwift

class TaskCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    var bag = DisposeBag()
    
    func update(with task: Task, action: CocoaAction) {
        checkButton.rx.action = action
        task.rx.observe(String.self, "title")
            .asDriver(onErrorJustReturn: nil)
            .drive(titleLabel.rx.text)
            .disposed(by: bag)
        
        task.rx.observe(Date.self, "checked")
            .subscribe(onNext: { [weak self] date in
                let image = UIImage(named: date == nil ? "ItemNotChecked": "ItemChecked")
                self?.checkButton.setImage(image, for: .normal)
            })
            .disposed(by: bag)
    }
    
    override func prepareForReuse() {
        checkButton.rx.action = nil
        bag = DisposeBag()
        super.prepareForReuse()
    }
    
}
