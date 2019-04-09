//
//  EditTaskViewController.swift
//  test
//
//  Created by Chung Tran on 09/04/2019.
//  Copyright (c) 2019 Chung Tran. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class EditTaskViewController: UIViewController, BindableType {
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var okButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var viewModel: EditTaskViewModel!
    
    let bag = DisposeBag()
    
    func bindViewModel() {
        titleTextView.text = viewModel.itemTitle
        cancelButton.rx.action = viewModel.onCancel
        
        okButton.rx.tap
            .withLatestFrom(titleTextView.rx.text.orEmpty)
            .map {["title": $0]}
            .subscribe(viewModel.onUpdate.inputs)
            .disposed(by: bag)
    }
    
}
