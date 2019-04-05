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
            guard let item = try? ___VARIABLE_entityName___(unboxer: Unboxer(dictionary: dict)) else {
                return .error(ServiceError.creationFailed)
            }
            
            try realm.write {
                realm.add(item)
            }
            return .just(item)
        }
        return result ?? .error(ServiceError.creationFailed)
    }
    
    @discardableResult
    func delete(_ item: ___VARIABLE_entityName___) -> Observable<Void> {
        let result = withRealm("deleting") { realm-> Observable<Void> in
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
                #warning("add code to update item and remove this line")
            }
            return .just(item)
        }
        return result ?? .error(ServiceError<___VARIABLE_entityName___>.updateFailed(item))
    }
    
    func list(predicate: NSPredicate? = nil) -> Observable<(AnyRealmCollection<___VARIABLE_entityName___>, RealmChangeset?)> {
        let result = withRealm("getting") { realm -> Observable<(AnyRealmCollection<___VARIABLE_entityName___>, RealmChangeset?)> in
            var query = realm.objects(___VARIABLE_entityName___.self)
            if let predicate = predicate {query = query.filter(predicate)}
            return Observable.changeset(from: query).share()
        }
        return result ?? .empty()
    }
}
