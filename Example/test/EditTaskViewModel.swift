//
//  EditTaskViewModel.swift
//  test
//
//  Created by Chung Tran on 08/04/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import Foundation
import RxSwift
import Action
import Unbox

struct EditTaskViewModel {
    let itemTitle: String
    let onUpdate: Action<UnboxableDictionary, Void>
    let onCancel: CocoaAction!
    let bag = DisposeBag()
    
    init(task: Task, coordinator: SceneCoordinatorType, updateAction: Action<UnboxableDictionary, Void>, cancelAction: CocoaAction? = nil) {
        itemTitle = task.title
        onUpdate = updateAction
        
        onUpdate.executionObservables
            .subscribe(onError: { (error) in
                print(error)
            })
            .disposed(by: bag)
        onCancel = CocoaAction {
            if let cancelAction = cancelAction {
                cancelAction.execute()
            }
            return coordinator.pop()
                .asObservable().map {_ in}
        }
        
        onUpdate.executionObservables
            .take(1)
            .subscribe(onNext: { _ in
                coordinator.pop()
            })
            .disposed(by: bag)
    }
}
