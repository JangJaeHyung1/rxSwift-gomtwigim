//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by jh on 2021/02/09.
//  Copyright © 2021 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

class MenuListViewModel{
    
    
    //    lazy var menuObservable = Observable.just(menuArray)
    
    var menuObservable = BehaviorRelay<[Menu]>(value: []) // 에러가 발생해도 서브젝트가 끊어지지 않도록
    
    lazy var itemsCount = menuObservable.map{
        $0.map{ $0.count }.reduce(0, +)
    }
    lazy var totalPrice = menuObservable.map{
        $0.map{ $0.price * $0.count }.reduce(0, +)
    }
    //    var totalPrice: PublishSubject<Int> = PublishSubject()
    //    var totalPrice: Observable<Int> = Observable.just(10_000)
    
    init(){
        
        _ = APIService.fetchAllMenuArrayRx()
            .map { data -> [MenuItem] in
                struct Response: Decodable {
                    var menus: [MenuItem] //JSON 데이터의 배열이름과 동일해야 하는듯.
                }
                let response = try! JSONDecoder().decode(Response.self, from: data)
                return response.menus
            }
            
            .map { menuItems -> [Menu] in
                var menuArray: [Menu] = []
                menuItems.enumerated().forEach { (index, item) in
                    let menu = Menu.fromMenuItems(id: index, item: item)
                    menuArray.append(menu)
                }
                return menuArray
//                menuItems.map
//                { Menu.fromMenuItems(id: 0, item: $0)}
            }
            .take(1)
            .bind(to: menuObservable)
        //        let menuArray: [Menu] = [
        //            Menu(id: 0, name: "튀김1", price: 100, count: 0),
        //            Menu(id: 1, name: "튀김1", price: 100, count: 0),
        //            Menu(id: 2, name: "튀김1", price: 100, count: 0),
        //            Menu(id: 3, name: "튀김1", price: 100, count: 0),
        //            Menu(id: 4, name: "튀김1", price: 100, count: 0)
        //        ]
        
        //        menuObservable.onNext(menuArray)
    }
    
    func onOrder(){
        
    }
    
    func clearAllItemSelections() {
        _ = menuObservable
            .map{ menuArray in
                menuArray.map { m in
                    Menu(id: m.id, name: m.name, price: m.price, count: 0)
                }
            }
            .take(1) // observable 이 단한번만 실행되도록
            .subscribe(onNext:{
//                self.menuObservable.onNext($0)
                self.menuObservable.accept($0) //에러나 컴플릿 없이 오로지 받는 작업뿐. subject 대신 relay
            })
    }
    
    
    func changeCount(item: Menu, increase: Int){
        _ = menuObservable
            .map{ menuArray in
                menuArray.map { m -> Menu in
                    if m.id == item.id{
                        if m.id == item.count{
                        }
                        return Menu(id: m.id, name: m.name, price: m.price, count: max(m.count + increase,0))
                    }else{
                        return Menu(id: m.id, name: m.name, price: m.price, count: m.count)
                    }
                }
            }
            .take(1) // observable 이 단한번만 실행되도록
            .subscribe(onNext:{
//                self.menuObservable.onNext($0)
                self.menuObservable.accept($0)
            })
    }
}
