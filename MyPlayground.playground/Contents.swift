import UIKit
import RxSwift

let bag = DisposeBag()

struct DataSource {
    let socket = PublishSubject<Int>()
}

let google = DataSource()
let bing = DataSource()

let dataSources = PublishSubject<DataSource>()

dataSources
.flatMapLatest {
    $0.socket
}.subscribe {
    print($0)
}.disposed(by: bag)

dataSources.onNext(google)
google.socket.onNext(1)

dataSources.onNext(bing)
bing.socket.onNext(2)

google.socket.onNext(3)
bing.socket.onNext(4)
