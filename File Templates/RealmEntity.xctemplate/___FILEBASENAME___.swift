//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import RealmSwift
import Unbox
import RxDataSources

final class ___VARIABLE_entityName___: Object, Unboxable, Mockable {
    // MARK: - Object
    @objc dynamic var id: Int = 0

    override class func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - Unboxable
    convenience required init(unboxer: Unboxer) throws {
        self.init()
        #warning("Implement init with unboxer and remove this line")
    }
    
    // MARK: - Mockobject
    static func mockingObjects() -> [___VARIABLE_entityName___] {
        #warning("Add mocking objects here")
        return [___VARIABLE_entityName___]()
    }
}

extension ___VARIABLE_entityName___: IdentifiableType {
    var identity: Int {
        return self.isInvalidated ? 0 : id
    }
}
