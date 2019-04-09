//
//  RepositoryFetcher.swift
//  github
//
//  Created by Chung Tran on 26/03/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

import Unbox

class ItemsFetcher<T> where T: Unboxable, T: Mockable {
    enum FetcherError: Error {
        case createRequestFailed, requestFailed
    }
    
    // MARK: - Init
    private var router: String
    init(router: String) {
        self.router = router
    }
    
    // MARK: - Subjects
    let list = BehaviorRelay<[T]>(value: [])
    let bag = DisposeBag()
    
    // MARK: - Methods
    var isFetching = false
    var reachedTheEnd = false
    var maxId: String?
    
    func refresh() {
        reachedTheEnd = false
        isFetching = false
        maxId = nil
    }
    
    func requestNext(mock: Bool = false) -> Single<[T]> {
        // check if request is dupplicated
        if self.isFetching || self.reachedTheEnd {
            return Single.never()
        }
        
        // mark as fetching
        self.isFetching = true
        
        // for testing, add mock objects
        if mock == true {
            self.isFetching = false
            self.reachedTheEnd = true
            T.createMockingObjects()
            return Single.just([T]())
        }
        
        // implement logic for retrieve real data (from network)
        #warning("implement logic for retrieve real data (from network)")
        return Single.just([T]())
    }
}
