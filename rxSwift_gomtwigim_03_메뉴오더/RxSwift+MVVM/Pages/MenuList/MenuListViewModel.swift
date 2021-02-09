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
    var menuArray: [Menu] = [
        Menu(name: "튀김1", price: 100, count: 0),
        Menu(name: "튀김1", price: 100, count: 0),
        Menu(name: "튀김1", price: 100, count: 0),
        Menu(name: "튀김1", price: 100, count: 0),
        Menu(name: "튀김1", price: 100, count: 0)
    ]
    
    var itemsCount: Int = 5
    var totalPrice: PublishSubject<Int> = PublishSubject()
//    var totalPrice: Observable<Int> = Observable.just(10_000)
    
    
    
    
}
