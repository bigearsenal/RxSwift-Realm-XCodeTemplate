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
    
    func onCreate() -> CocoaAction {
        return CocoaAction { _ in
            return self.service
                .create(["title": ""])
                .flatMap { item -> Observable<Void> in
                    let editViewModel = EditTaskViewModel(task: item,
                                                          coordinator: self.sceneCoordinator,
                                                          updateAction: self.onUpdate(item: item),
                                                          cancelAction: self.onDelete(item: item))
                    return self.sceneCoordinator
                        .transition(to: Scene.editTask(editViewModel), type: .modal)
                        .asObservable().map { _ in }
                }
        }
    }
    
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
    
    lazy var editAction: Action<Task, Swift.Never> = { this in
        return Action { item in
            let editViewModel = EditTaskViewModel(
                task: item,
                coordinator: this.sceneCoordinator,
                updateAction: this.onUpdate(item: item)
            )
            return this.sceneCoordinator
                .transition(to: Scene.editTask(editViewModel), type: .modal)
                .asObservable()
        }
    }(self)
}
