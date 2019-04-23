
import UIKit
import RxSwift
import RxCocoa

enum NAArticleType {
    case all
    case favourite
}

class NAArticleTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var favouritesButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    lazy var articleListViewModel: NAArticleListViewModel! = NAArticleListViewModel()
    var articleType = NAArticleType.all
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItems = articleType == .all ? [favouritesButton] : [doneButton]
        if articleType == .favourite {
            self.navigationItem.title = "Favourite Headlines"
        } else {
            self.articleListViewModel.setup()
        }
        
        setupHeadlineConfiguration()
        setupCellConfiguration()
        setupCellTapHandling()
    }
    
    func setupHeadlineConfiguration() {
        self.articleListViewModel.articleViewModels.asObservable().subscribe(onNext: { articles in
            if self.articleType == .all {
                if articles.count != 0 {
                    DispatchQueue.main.async {
                        self.navigationItem.title = articles.first?.source.value
                        self.activityIndicatorView.stopAnimating()
                        self.tableView.isUserInteractionEnabled = true
                    }
                } else {
                    self.activityIndicatorView.startAnimating()
                    self.tableView.isUserInteractionEnabled = false
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func setupCellConfiguration() {
        if articleType == .all {
            self.articleListViewModel.articleViewModels.asObservable()
                .bind(to: self.tableView.rx.items(cellIdentifier: CellConstants.article, cellType: NAArticleTableViewCell.self)) { index, article, cell in
                    cell.configureWithArticle(article: article)
                }
                .disposed(by: disposeBag)
        } else {
            self.articleListViewModel.favouriteArticleViewModels.asObservable()
                .bind(to: self.tableView.rx.items(cellIdentifier: CellConstants.article, cellType: NAArticleTableViewCell.self)) { index, article, cell in
                    cell.configureWithArticle(article: article)
                }
                .disposed(by: disposeBag)
        }
    }
    
    func setupCellTapHandling() {
        self.tableView.rx.modelSelected(NAArticleViewModel.self).subscribe(onNext: { article in
            self.performSegue(withIdentifier: SegueIdentifiers.detailView, sender: article)
            if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: - Bar Button Item Methods

extension NAArticleTableViewController {
    @IBAction func clickFavouritesButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: SegueIdentifiers.favouritesView, sender: nil)
    }
    
    @IBAction func clickDoneButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}

// MARK: - Navigation

extension NAArticleTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.detailView {
            let articleDetailVC = segue.destination as? NAArticleDetailViewController
            let articleViewModel = sender as! NAArticleViewModel
            articleDetailVC?.articleViewModel = articleViewModel
        } else if segue.identifier == SegueIdentifiers.favouritesView {
            if let favouriteListTVC = (segue.destination as? UINavigationController)?.children.first as? NAArticleTableViewController {
                favouriteListTVC.articleType = .favourite
                favouriteListTVC.articleListViewModel = self.articleListViewModel
            }
        }
    }
}
