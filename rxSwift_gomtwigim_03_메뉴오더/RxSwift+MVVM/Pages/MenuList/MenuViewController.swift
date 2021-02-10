//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa // rxSwift 의 요소들을 UIKit View 들에 Extension 하여 접목시킨 라이브러리입니다. (.rx)

class MenuViewController: UIViewController {
    // MARK: - Life Cycle

    let cellId = "MenuItemTableViewCell"
    let viewModel = MenuListViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.dataSource = nil
        
        viewModel.menuObservable
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: cellId, cellType: MenuItemTableViewCell.self)){ index, item, cell in
                 
                cell.title.text = item.name
                cell.price.text = "\(item.price)"
                cell.count.text = "\(item.count)"
                
                cell.onChange = { [weak self] increase in
                    self?.viewModel.changeCount(item: item, increase: increase)
                }
//                self.viewModel.increase
                
                
            }
            .disposed(by: disposeBag)
        
        viewModel.itemsCount
            .map{ "\($0)" }
//            .subscribe(onNext: {
//                self.itemCountLabel.text = $0
//            })
            .asDriver(onErrorJustReturn: "") // 에러가 발생해도 스트림이 끊어지지 않도록 
            .drive(itemCountLabel.rx.text)
//            .catchErrorJustReturn("")
//            .observeOn(MainScheduler.instance)
//            .bind(to: itemCountLabel.rx.text) // 순환참조 없이 사용가능
            .disposed(by: disposeBag)
        
        viewModel.totalPrice
            .map{ $0.currencyKR() }
            .observeOn(MainScheduler.instance)
//            .subscribe(onNext:{ [weak self] in
//                self?.totalPrice.text = $0
//            })
            .bind(to: totalPrice.rx.text)
            .disposed(by: disposeBag)
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let identifier = segue.identifier ?? ""
//        if identifier == "OrderViewController",
//            let orderVC = segue.destination as? OrderViewController {
//            // TODO: pass selected menus
//        }
//    }

    func showAlert(_ title: String, _ message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true, completion: nil)
    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var itemCountLabel: UILabel!
    @IBOutlet var totalPrice: UILabel!

    @IBAction func onClear() {
        viewModel.clearAllItemSelections()
        
    }

    @IBAction func onOrder(_ sender: UIButton) {
        // TODO: no selection
        // showAlert("Order Fail", "No Orders")
//        performSegue(withIdentifier: "OrderViewController", sender: nil)
        
//        viewModel.totalPrice.onNext(100)
        
//        viewModel.menuObservable.onNext([
//        Menu(name: "changed", price: 100, count: 2)])
        
        viewModel.onOrder()
    }

}

//extension MenuViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.menuArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell") as! MenuItemTableViewCell
//
//        let menu = viewModel.menuArray[indexPath.row]
//
//
//        return cell
//    }
//}
