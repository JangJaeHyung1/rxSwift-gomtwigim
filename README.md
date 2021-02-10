# rxSwift-gomtwigim

rxSwift의 권위자 곰튀김님의 
### **RxSwift+MVVM** 
강의를 수강, 정리한 내용
> [링크](https://github.com/iamchiwon/RxSwift_In_4_Hours)

1. Observable
- Observable create
- subscribe 로 데이터 사용
- Disposable 로 작업 취소


2.Sugar API
- 간단한 생성 : just, from
- 필터링 : filter, take
- 데이터 변형 : map, flatMap

3.Observable Life-Cycle
- Subscribed
- Next
- Completed / Error
- Disposabled


4.순환참조와 메모리 관리
- Unfinished Observable / Memory Leak


5.쓰레드 분기
- DispatchQueue, OperationQueue
- observeOn, subscribeOn




**RxSwift 활용범위 넓히기 - UI 컴포넌트와의 연동**

6.Subject
- Data Control
- Hot Observable / Cold Observable


7.RxCocoa
- UI 작업의 특징
- Observable / Driver
- Subject / Relay
