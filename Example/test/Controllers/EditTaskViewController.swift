//
//  EditTaskViewController.swift
//  test
//
//  Created by Chung Tran on 08/04/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import UIKit
import RxSwift

class EditTaskViewController: UIViewController, BindableType {
    @IBOutlet weak var titleView: UITextView!
    @IBOutlet weak var okButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var viewModel: EditTaskViewModel!
    
    let bag = DisposeBag()
    
    func bindViewModel() {
        titleView.text = viewModel.itemTitle
        cancelButton.rx.action = viewModel.onCancel
        okButton.rx.tap
            .withLatestFrom(titleView.rx.text.orEmpty)
            .map {["title": $0]}
            .subscribe(viewModel.onUpdate.inputs)
            .disposed(by: bag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleView.becomeFirstResponder()
    }

}
