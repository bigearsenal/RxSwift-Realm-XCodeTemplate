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
import Unbox

struct ___VARIABLE_entityName___Service: ServiceType {
    init() {
        // Create service
    }
    @discardableResult
    func create(_ dict: UnboxableDictionary) -> Observable<___VARIABLE_entityName___> {
        let result = withRealm("creating") { realm -> Observable<___VARIABLE_entityName___> in
            var modifiedDict = dict
            if !modifiedDict.keys.contains("id") {
                modifiedDict["id"] = (realm.objects(___VARIABLE_entityName___.self).max(ofProperty: "id") ?? 0) + 1
            }
            
            let item = try ___VARIABLE_entityName___(unboxer: Unboxer(dictionary: modifiedDict))
            
            try realm.write {
                realm.add(item, update: true)
            }
            return .just(item)
        }
        return result ?? .error(ServiceError.creationFailed)
    }
    
    @discardableResult
    func delete(_ item: ___VARIABLE_entityName___) -> Observable<Void> {
        let result = withRealm("deleting") { realm -> Observable<Void> in
            try realm.write {
                realm.delete(item)
            }
            return .empty()
        }
        return result ?? .error(ServiceError<___VARIABLE_entityName___>.deletionFailed(item))
    }
    
    @discardableResult
    func update(_ item: ___VARIABLE_entityName___, with dict: UnboxableDictionary) -> Observable<___VARIABLE_entityName___> {
        let result = withRealm("updating") { realm -> Observable<___VARIABLE_entityName___> in
            try realm.write {
                dict.keys.forEach {item.setValue(dict[$0], forKey: $0)}
            }
            return .just(item)
        }
        return result ?? .error(ServiceError<___VARIABLE_entityName___>.updateFailed(item))
    }
    
    func list(predicate: NSPredicate? = nil) -> Observable<Results<___VARIABLE_entityName___>> {
        let result = withRealm("getting") { realm -> Observable<Results<___VARIABLE_entityName___>> in
            var query = realm.objects(___VARIABLE_entityName___.self)
            if let predicate = predicate {query = query.filter(predicate)}
            return Observable.collection(from: query)
        }
        return result ?? .empty()
    }
}
