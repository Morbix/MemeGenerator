import RxSwift
import RxCocoa

final class HomeViewModel {
    
    // Binds
    let biggerDisplay: Observable<UIImage>
    let onResetTap = PublishSubject<Void>()
    let onThumbnailTap = PublishSubject<Int>()
    let thumbnails = [#imageLiteral(resourceName: "sandra-annerberg"), #imageLiteral(resourceName: "meme0"), #imageLiteral(resourceName: "meme1")]
    
    // Properties
    private let selectedImage = BehaviorRelay<UIImage?>(value: nil)
    private let bag = DisposeBag()
    private let scheduler: SchedulerType
    
    init(scheduler: SchedulerType = MainScheduler.instance) {
        self.scheduler = scheduler
        
        biggerDisplay = selectedImage
            .map { $0 ?? Placeholder() }
            .asObservable()
        
        bindLogics()
    }
    
    private func bindLogics() {
        onResetTap
            .map { nil }
            .bind(to: selectedImage)
            .disposed(by: bag)
        
        onThumbnailTap
            .map { [thumbnails] in thumbnails[safe: $0] }
            .flatMap { $0.map(Observable.just) ?? Observable.empty() }
            .bind(to: selectedImage)
            .disposed(by: bag)
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
