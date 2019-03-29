import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {

    // Outlets
    @IBOutlet var featuredImageView: UIImageView!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var proceedButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    // Properties
    private let viewModel = HomeViewModel()
    private let bag = DisposeBag()
    
    // Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupActions()
        setupUI()
    }

    private func setupTableView() {
        Observable
            .of(viewModel.thumbnails)
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) {  row, element, cell in
                let imageView = cell.viewWithTag(10) as? UIImageView
                imageView?.image = element
            }
            .disposed(by: bag)
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
    
    private func setupActions() {
        resetButton.rx.tap
            .bind(to: viewModel.onResetTap)
            .disposed(by: bag)
        
        tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.onThumbnailTap)
            .disposed(by: bag)
    }
    
    private func setupUI() {
        viewModel.biggerDisplay
            .asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: featuredImageView.rx.image)
            .disposed(by: bag)
    }
}
