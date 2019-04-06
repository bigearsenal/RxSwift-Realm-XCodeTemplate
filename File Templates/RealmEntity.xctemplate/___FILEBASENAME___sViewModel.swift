//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import RxSwift
import Action
import Unbox

struct ___VARIABLE_entityName___sViewModel: ItemsViewModel<___VARIABLE_entityName___> {
    let sceneCoordinator: SceneCoordinatorType
    let service: ___VARIABLE_entityName___Service
    
    required init(router: String, predicate: NSPredicate? = nil, sceneCoordinator: SceneCoordinator, service: ___VARIABLE_entityName___Service) {
        self.sceneCoordinator = sceneCoordinator
        self.service = service
        super.init(router: router, predicate: predicate)
    }
    
    func onCreate() -> CocoaAction {
        return CocoaAction { _ in
            return self.service
                .create([:])
                .flatMap { item -> Observable<Void> in
                    #warning("Create EditViewModel and navigate to edit scene")
//                    let editViewModel = EditTaskViewModel(task: task,
//                                                          coordinator: self.sceneCoordinator,
//                                                          updateAction: self.onUpdateTitle(task: task),
//                                                          cancelAction: self.onDelete(task: task))
//                    return self.sceneCoordinator
//                        .transition(to: Scene.editTask(editViewModel), type: .modal)
//                        .asObservable().map { _ in }
                }
        }
    }
    
    func onUpdate(item: ___VARIABLE_entityName___) -> Action<UnboxableDictionary, Void> {
        return Action { dict in
            return self.service.update(item, with: dict).map {_ in}
        }
    }
    
    func onDelete(item: ___VARIABLE_entityName___) -> CocoaAction {
        return CocoaAction {
            return self.service.delete(item)
        }
    }
    
    lazy var editAction: Action<___VARIABLE_entityName___, Swift.Never> = { this in
        return Action { item in
            #warning("navigate to EditItemVC")
//            let editViewModel = EditTaskViewModel(
//                task: task,
//                coordinator: this.sceneCoordinator,
//                updateAction: this.onUpdateTitle(task: task)
//            )
//            return this.sceneCoordinator
//                .transition(to: Scene.editTask(editViewModel), type: .modal)
//                .asObservable()
        }
    }(self)
}
