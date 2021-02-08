//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxSwift
import SwiftyJSON
import UIKit

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

//클로저를 입력받고 때가됐을때 클로저를 실행
//class 나중에생기는데이터<T>{
//    private let task: (@escaping (T) -> Void) -> Void
//
//    init(task: @escaping (@escaping (T) -> Void) -> Void) {
//        self.task = task
//    }
//    func 나중에오면(_ f: @escaping (T) -> Void){
//        task(f)
//    }
//}

class ViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var editView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
    }
    
    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            v?.isHidden = !s
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }
    
    // 본체함수가 끝나고 나서 나중에 실행되는 함수다(메인안에것) = escaping
    func downloadJson(_ url: String) -> Observable<String> {
        // 1. 비동기로 생기는 데이터를 Observable로 감싸서 리턴하는 방법
        //MARK: sugar API
//        return Observable.just("Hi")
//        return Observable.from(["Hi","World"])
        return Observable.create { (emitter) -> Disposable in
//            emitter.onNext("hi")
//            emitter.onCompleted()
//            return Disposables.create()
//        }
//    }
        
        
            let url = URL(string: url)!

            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                guard error == nil else{
                    emitter.onError(error!)
                    return
                }

                if let data = data, let json = String(data: data, encoding: .utf8){
                    emitter.onNext(json)
                }

                emitter.onCompleted()

            }
            task.resume()

            return Disposables.create(){
                task.cancel()
            }
        }
    }
        
        
//        return Observable.create(){ f in
//            DispatchQueue.global().async {
//                let url = URL(string: url)!
//                let data = try! Data(contentsOf: url)
//                let json = String(data: data, encoding: .utf8)
//                DispatchQueue.main.async {
//                    f.onNext(json)
//                    f.onCompleted()
//                }
//            }
//
//            return Disposables.create()
//        }
//    }
    
    // MARK: SYNC
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func onLoad() {
        editView.text = ""
        self.setVisibleWithAnimation(self.activityIndicator, true)
        
        
        
        let jsonObservable = downloadJson(MEMBER_LIST_URL)
        let helloObservable = Observable.just("hello")
        Observable.zip(jsonObservable, helloObservable){ $1 + "\n" + $0 }
        
            //sugar api
//            .subscribe(onNext: {print($0)}, onCompleted: {print("com")} )
            // 2. Observable로 오는 데이터를 받아서 처리하는 방법
//            .subscribe { (event) in
//                switch event{
//
//                case .next(let json):
//                    print(json)
//                    break
//                case .error(_):
//                    break
//                case .completed:
//                    break
//                }
//            }
//        disposable.dispose()
        
        
        
        //sugar api main.async
            
//            .map({ (json)  in json?.count ?? 0 }) // sugar : operator
//            .filter({ (cnt) -> Bool in cnt > 0 }) // sugar : operator
//            .map({ "\($0)" }) // sugar : operator
            .observeOn(MainScheduler.instance) // sugar : operator
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default)) // 위치랑 상관없이 첫번째에서 동작 (어느 쓰레드에서 동작할건지 지정하는 오퍼레이터)
            .subscribe { (json) in
                self.editView.text = json
                self.setVisibleWithAnimation(self.activityIndicator, false)
            } onError: { (error) in
                
            } onCompleted: {
                
            } onDisposed: {
                
            }.disposed(by: disposeBag)

//            .debug()
//            .subscribe{ event in
//                switch event {
//                case .next(let json):
//                    DispatchQueue.main.async {
//                        self.editView.text = json
//                        self.setVisibleWithAnimation(self.activityIndicator, false)
//                    }
//
//
//                case .completed:
//                    //순환참조 제거 f.onCompleted()가 시행되면서 클로저가 사라지면서 self에 대한 reference count가 제거됨
//                    break
//                case .error(_):
//                    break
//                }
//            }
        
//        끝나지 않았어도 취소가 됨
//        disposable.dispose()
        
        
        // MARK: rxSwift 사용방법
        // 1. 비동기로 생기는 데이터를 Observable로 감싸서 리턴하는 방법
        // 2. Observable로 오는 데이터를 받아서 처리하는 방법
        
    }
}

