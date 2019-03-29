import Foundation
import Quick
import Nimble
import RxTest
import RxSwift

@testable import MemeGenerator

final class HomeViewModelTests: QuickSpec {
    
    override func spec() {
    
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        var sut_viewModel: HomeViewModel!
        var biggerDisplayObserver: TestableObserver<UIImage>!
        var thumbnailsObserver: TestableObserver<[UIImage]>!
        
        func makeBinds() {
            sut_viewModel
                .biggerDisplay
                //.asDriver()
                //.drive(biggerDisplayObserver)
                .bind(to: biggerDisplayObserver)
                .disposed(by: disposeBag)
        }
        
        describe("HomeViewModel") {
            
            beforeEach {
                scheduler = TestScheduler(initialClock: 0)
                disposeBag = DisposeBag()
                sut_viewModel = HomeViewModel()
                
                biggerDisplayObserver = scheduler.createObserver(UIImage.self)
                thumbnailsObserver = scheduler.createObserver([UIImage].self)
                
                makeBinds()
            }
            
            it("should start biggerDisplay with placeholder") {
                expect(biggerDisplayObserver.events) == [
                    .next(0, #imageLiteral(resourceName: "placeholder-meme"))
                ]
            }
            
            it("should start thumbnails with imagens") {
                expect(sut_viewModel.thumbnails) == [#imageLiteral(resourceName: "sandra-annerberg"), #imageLiteral(resourceName: "meme0"), #imageLiteral(resourceName: "meme1")]
            }
            
            describe("when onThumbnailTap emits") {
                
                beforeEach {
                    scheduler
                        .createColdObservable([
                            .next(10, 0),
                            .next(20, 1),
                            .next(30, 2),
                            .next(40, -1),
                            ])
                        .bind(to: sut_viewModel.onThumbnailTap)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                }
                
                it("then biggerDisplay should receive image") {
                    expect(biggerDisplayObserver.events) == [
                        .next(0, #imageLiteral(resourceName: "placeholder-meme")),
                        .next(10, #imageLiteral(resourceName: "sandra-annerberg")),
                        .next(20, #imageLiteral(resourceName: "meme0")),
                        .next(30, #imageLiteral(resourceName: "meme1"))
                    ]
                }
            }
            
            describe("when onResetTap emits") {
                
                beforeEach {
                    scheduler
                        .createColdObservable([
                            .next(10, ())
                            ])
                        .bind(to: sut_viewModel.onResetTap)
                        .disposed(by: disposeBag)
                    
                    scheduler.start()
                }
                
                
                
                it("then biggerDisplay should receive placeholder") {
                    expect(biggerDisplayObserver.events) == [
                        .next(0, #imageLiteral(resourceName: "placeholder-meme")),
                        .next(10, #imageLiteral(resourceName: "placeholder-meme")),
                    ]
                }
            }
        }
    }
}
