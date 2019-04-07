//
//  TasksViewModel.swift
//  test
//
//  Created by Chung Tran on 07/04/2019.
//  Copyright (c) 2019 Chung Tran. All rights reserved.
//

import Foundation
import RxSwift
import Action
import Unbox
import RxDataSources

typealias TaskSection = AnimatableSectionModel<String, Task>

class TasksViewModel: ItemsViewModel<Task> {
    let sceneCoordinator: SceneCoordinatorType
    let service: TaskService
    let predicate: NSPredicate?
    
    required init(router: String, predicate: NSPredicate? = nil, sceneCoordinator: SceneCoordinator, service: TaskService) {
        self.sceneCoordinator = sceneCoordinator
        self.service = service
        self.predicate = predicate
        super.init(router: router)
    }
    
    override var sectionedItems: Observable<[TaskSection]>! {
        return self.service.list(predicate: predicate)
            .map { results in
                let dueTasks = results
                    .filter("checked == nil")
                    .sorted(byKeyPath: "added", ascending: false)

                let doneTasks = results
                    .filter("checked != nil")
                    .sorted(byKeyPath: "checked", ascending: false)

                return [
                    TaskSection(model: "Due Tasks", items: dueTasks.toArray()),
                    TaskSection(model: "Done Tasks", items: doneTasks.toArray())
                ]
        }
    }
    
//    func onCreate() -> CocoaAction {
//        return CocoaAction { _ in
//            return self.service
//                .create([:])
//                .flatMap { item -> Observable<Void> in
//                    #warning("Create EditViewModel and navigate to edit scene")
////                    let editViewModel = EditTaskViewModel(task: task,
////                                                          coordinator: self.sceneCoordinator,
////                                                          updateAction: self.onUpdateTitle(task: task),
////                                                          cancelAction: self.onDelete(task: task))
////                    return self.sceneCoordinator
////                        .transition(to: Scene.editTask(editViewModel), type: .modal)
////                        .asObservable().map { _ in }
//                }
//        }
//    }
    
    func onToggle(item: Task) -> CocoaAction {
        return CocoaAction {
            return self.service.toggle(item: item).map { _ in }
        }
    }
    
    func onUpdate(item: Task) -> Action<UnboxableDictionary, Void> {
        return Action { dict in
            return self.service.update(item, with: dict).map {_ in}
        }
    }
    
    func onDelete(item: Task) -> CocoaAction {
        return CocoaAction {
            return self.service.delete(item)
        }
    }
    
//    lazy var editAction: Action<Task, Swift.Never> = { this in
//        return Action { item in
//            #warning("navigate to EditItemVC")
////            let editViewModel = EditTaskViewModel(
////                task: task,
////                coordinator: this.sceneCoordinator,
////                updateAction: this.onUpdateTitle(task: task)
////            )
////            return this.sceneCoordinator
////                .transition(to: Scene.editTask(editViewModel), type: .modal)
////                .asObservable()
//        }
//    }(self)
}
