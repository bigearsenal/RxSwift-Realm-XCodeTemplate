//
//  EditTaskViewModel.swift
//  test
//
//  Created by Chung Tran on 09/04/2019.
//  Copyright (c) 2019 Chung Tran. All rights reserved.
//

import UIKit
import RxSwift
import Action
import Unbox


struct EditTaskViewModel {
    let bag = DisposeBag()
    
    let itemTitle: String
    let onUpdate: Action<UnboxableDictionary, Void>
    let onCancel: CocoaAction
    
    init(task: Task, coordinator: SceneCoordinatorType, updateAction: Action<UnboxableDictionary, Void>, cancelAction: CocoaAction? = nil) {
        itemTitle = task.title
        onUpdate = updateAction
        onCancel = CocoaAction {
            if let cancelAction = cancelAction {
                cancelAction.execute()
            }
            return coordinator.pop()
                .asObservable()
                .map {_ in}
        }
        onUpdate.executionObservables
            .take(1)
            .subscribe(onNext: {_ in
                coordinator.pop()
            })
            .disposed(by: bag)
    }
}
