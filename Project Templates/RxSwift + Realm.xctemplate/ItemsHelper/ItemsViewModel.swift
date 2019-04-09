//
//  ReposListViewModel.swift
//  github
//
//  Created by Chung Tran on 26/03/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import Foundation

import RealmSwift
import RxSwift
import RxRealm
import RxCocoa
import RxDataSources

import Unbox

class ItemsViewModel<T> where T: Object, T: IdentifiableType, T: Mockable {
    
    internal let bag = DisposeBag()
    let fetcher: ItemsFetcher<T>
    
    var sectionedItems: Observable<[AnimatableSectionModel<String, T>]>! {
        return nil
    }
    
    var realm: Realm?
    
    init(router: String) {
        fetcher = ItemsFetcher<T>(router: router)
    }
    
    internal func save(_ newItems: [T]) {
        if realm == nil {
            realm = try? Realm()
        }
        guard let realm = realm else {return}
        do {
            try realm.write {
                realm.add(newItems, update: true)
            }
        } catch let e {
            print(e)
        }
        
    }
    
    func fetchNext() -> Completable {
        return Completable.create {completable in
            let disposable = Disposables.create()
            #warning("Remove mocke = true when testing done")
            self.fetcher.requestNext(mock: true)
                .subscribe(onSuccess: { newItems in
                    self.save(newItems)
                    completable(.completed)
                }, onError: { (error) in
                    completable(.error(error))
                })
                .disposed(by: self.bag)
            return disposable
        }
    }
    
    @objc func refreshFetcher() {
        fetcher.refresh()
    }
}
