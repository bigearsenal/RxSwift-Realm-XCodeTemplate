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

class ___VARIABLE_entityName___: Object, Unboxable {
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
}

extension ___VARIABLE_entityName___: IdentifiableType {
    var identity: Int {
        return self.isInvalidated ? 0 : id
    }
}
