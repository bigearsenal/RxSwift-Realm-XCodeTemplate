//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

struct ___VARIABLE_entityName___Service: ServiceType {
    init() {
        // Create service
    }
    @discardableResult
    func create(_ dict: AnyObject) -> Observable<___VARIABLE_entityName___> {
        let result = withRealm("creating") { realm -> Observable<___VARIABLE_entityName___> in
            let item = ___VARIABLE_entityName___()
            #warning("add code to create item and remove this line")
            
            try realm.write {
                realm.add(task)
            }
            return .just(task)
        }
        return result ?? .error(TaskServiceError.creationFailed)
    }
    
    @discardableResult
    func delete(_ item: ___VARIABLE_entityName___) -> Observable<Void> {
        let result = withRealm("deleting") { realm-> Observable<Void> in
            try realm.write {
                realm.delete(task)
            }
            return .empty()
        }
        return result ?? .error(ServiceError<___VARIABLE_entityName___>.deletionFailed(item))
    }
    
    @discardableResult
    func update(_ item: ___VARIABLE_entityName___, with dict: AnyObject) -> Observable<___VARIABLE_entityName___> {
        let result = withRealm("updating") { realm -> Observable<___VARIABLE_entityName___> in
            try realm.write {
                #warning("add code to update item and remove this line")
            }
            return .just(task)
        }
        return result ?? .error(TaskServiceError<___VARIABLE_entityName___>.updateFailed(item))
    }
    
    func list() -> Observable<Results<___VARIABLE_entityName___>> {
        let result = withRealm("getting") { realm -> Observable<Results<___VARIABLE_entityName___>> in
            let realm = try Realm()
            #warning("add predicate or/and remove this line")
            let items = realm.objects(___VARIABLE_entityName___.self)
            return Observable.collection(from: items)
        }
        return result ?? .empty()
    }
}
