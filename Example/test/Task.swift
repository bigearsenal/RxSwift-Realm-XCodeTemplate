//
//  Task.swift
//  test
//
//  Created by Chung Tran on 09/04/2019.
//  Copyright (c) 2019 Chung Tran. All rights reserved.
//

import Foundation
import RealmSwift
import Unbox
import RxDataSources

class Task: Object, Unboxable, Mockable {
    // MARK: - Object
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var added: Date = Date()
    @objc dynamic var checked: Date? = nil

    override class func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - Unboxable
    convenience required init(unboxer: Unboxer) throws {
        self.init()
        id = try unboxer.unbox(key: "id")
        title = try unboxer.unbox(key: "title")
    }
    
    // MARK: - Mockobject
    static func createMockingObjects() {
        let service = TaskService()
        ["chap1","chap2","chap3","chap4","chap5"]
            .enumerated()
            .forEach {service.create(["title": $1, "id": $0])}
    }
}

extension Task: IdentifiableType {
    var identity: Int {
        return self.isInvalidated ? 0 : id
    }
}
