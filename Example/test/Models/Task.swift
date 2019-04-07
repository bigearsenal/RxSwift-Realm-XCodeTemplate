//
//  Task.swift
//  test
//
//  Created by Chung Tran on 07/04/2019.
//  Copyright (c) 2019 Chung Tran. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

final class Task: Object, Mockable {
    // MARK: - Object
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var added: Date = Date()
    @objc dynamic var checked: Date? = nil

    override class func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - Mockobject
    static func createMockingObjects() {
        let service = TaskService()
        
        ["Chapter 5: Filtering operators",
         "Chapter 4: Observables and Subjects in practice",
         "Chapter 3: Subjects",
         "Chapter 2: Observables",
         "Chapter 1: Hello, RxSwift"].enumerated().forEach {
            service.create(["title": $1, "id": $0])
        }
    }
}

extension Task: IdentifiableType {
    var identity: Int {
        return self.isInvalidated ? 0 : id
    }
}
