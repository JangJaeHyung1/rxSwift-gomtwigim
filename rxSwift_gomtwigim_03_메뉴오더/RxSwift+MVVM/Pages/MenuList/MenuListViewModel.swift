//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by jh on 2021/02/09.
//  Copyright © 2021 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift

class MenuListViewModel{
    
    
//    lazy var menuObservable = Observable.just(menuArray)
    
    var menuObservable = BehaviorSubject<[Menu]>(value: [])
    
    lazy var itemsCount = menuObservable.map{
        $0.map{ $0.count }.reduce(0, +)
    }
    lazy var totalPrice = menuObservable.map{
        $0.map{ $0.price * $0.count }.reduce(0, +)
    }
//    var totalPrice: PublishSubject<Int> = PublishSubject()
//    var totalPrice: Observable<Int> = Observable.just(10_000)
    
    init(){
        let menuArray: [Menu] = [
            Menu(name: "튀김1", price: 100, count: 0),
            Menu(name: "튀김1", price: 100, count: 0),
            Menu(name: "튀김1", price: 100, count: 0),
            Menu(name: "튀김1", price: 100, count: 0),
            Menu(name: "튀김1", price: 100, count: 0)
        ]
        
        menuObservable.onNext(menuArray)
    }
    
    
}
