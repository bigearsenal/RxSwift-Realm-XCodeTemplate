//
//  TaskService.swift
//  test
//
//  Created by Chung Tran on 07/04/2019.
//  Copyright (c) 2019 Chung Tran. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm
import Unbox

struct TaskService: ServiceType {
    enum TaskServiceError: Error {
        case toggleFailed(Task)
    }
    init() {
        // Create service
    }
    @discardableResult
    func create(_ dict: UnboxableDictionary) -> Observable<Task> {
        let result = withRealm("creating") { realm -> Observable<Task> in
            let item = Task()
            dict.keys.forEach {item.setValue(dict[$0], forKey: $0)}
            try realm.write {
                realm.add(item, update: true)
            }
            return .just(item)
        }
        return result ?? .error(ServiceError.creationFailed)
    }
    
    @discardableResult
    func delete(_ item: Task) -> Observable<Void> {
        let result = withRealm("deleting") { realm -> Observable<Void> in
            try realm.write {
                realm.delete(item)
            }
            return .empty()
        }
        return result ?? .error(ServiceError<Task>.deletionFailed(item))
    }
    
    @discardableResult
    func update(_ item: Task, with dict: UnboxableDictionary) -> Observable<Task> {
        let result = withRealm("updating") { realm -> Observable<Task> in
            try realm.write {
                dict.keys.forEach {item.setValue(dict[$0], forKey: $0)}
            }
            return .just(item)
        }
        return result ?? .error(ServiceError<Task>.updateFailed(item))
    }
    
    @discardableResult
    func toggle(item: Task) -> Observable<Task> {
        let result = withRealm("toggling") { realm -> Observable<Task> in
            try realm.write {
                if item.checked == nil {
                    item.checked = Date()
                } else {
                    item.checked = nil
                }
            }
            return .just(item)
        }
        return result ?? .error(TaskServiceError.toggleFailed(item))
    }
    
    func list(predicate: NSPredicate? = nil) -> Observable<Results<Task>> {
        let result = withRealm("getting") { realm -> Observable<Results<Task>> in
            var query = realm.objects(Task.self)
            if let predicate = predicate {query = query.filter(predicate)}
            return Observable.collection(from: query)
        }
        return result ?? .empty()
    }
}
