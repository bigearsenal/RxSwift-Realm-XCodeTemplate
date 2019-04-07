//
//  ItemsCollectionViewController.swift
//  Instagram
//
//  Created by Chung Tran on 07/04/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import UIKit
import RealmSwift
import RxDataSources

class ItemsCollectionViewController<T>: ItemsViewController<T> where T: Object, T: IdentifiableType, T: Mockable {
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // set layout for collectionView
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = layoutForCollectionView()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        // device rotation
        NotificationCenter.default.rx.notification(Notification.Name("UIDeviceOrientationDidChangeNotification"))
            .subscribe(onNext: { [weak self] (_) in
                guard let strongSelf = self else {return}
                strongSelf.collectionView.collectionViewLayout = strongSelf.layoutForCollectionView()
            })
            .disposed(by: bag)
        
        // bind refreshControll to collectionView
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        // fetchNext when reach last 20 point to the bottom
        collectionView.rx.contentOffset
            .filter {$0.y + self.collectionView.frame.size.height + 100 > self.collectionView.contentSize.height}
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (_) in
                self?.fetchNext()
            })
            .disposed(by: bag)
    }
    
    func layoutForCollectionView() -> UICollectionViewFlowLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        return layout
    }
    
    override func endRefreshing() {
        collectionView.refreshControl?.endRefreshing()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
