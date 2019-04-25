
import UIKit
import RxSwift
import RxCocoa

// Type of Article to show (normal or favourited)
enum NAArticleType {
    case all
    case favourite
}

class NAArticleTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    // shown when an internet request is being made
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // allows the user to go to the favourite headlines list
    @IBOutlet weak var favouritesButton: UIBarButtonItem!
    
    // allows the user to return to the headlines lisrt
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    // allows the user to make another request when the previous one failed
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    lazy var articleListViewModel: NAArticleListViewModel! = NAArticleListViewModel()
    
    // since the view controller is shared through two types of headlines (all and favourited), this variable distinguishes both
    var articleType = NAArticleType.all
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshButton.isEnabled = false
        switch articleType {
        case .favourite:
            self.navigationItem.rightBarButtonItems = [doneButton]
            self.navigationItem.leftBarButtonItems = []
            self.navigationItem.title = "Favourite Headlines"
            self.articleListViewModel.setupFavourites()
        default:
            self.navigationItem.rightBarButtonItems = [favouritesButton]
            self.setupStart()
        }
        
        setupHeadlineConfiguration()
        setupCellConfiguration()
        setupCellTapHandling()
    }
    
    func setupStart() {
        self.activityIndicatorView.startAnimating()
        self.tableView.isUserInteractionEnabled = false
        self.articleListViewModel.setup { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicatorView.stopAnimating()
                self?.tableView.isUserInteractionEnabled = true
                self?.navigationItem.title = "No Results"
                self?.refreshButton.isEnabled = true
            }
            
        }
    }
    
    /**
     * Handles the present of values to display on the list (for the main Headline List)
     **/
    func setupHeadlineConfiguration() {
        self.articleListViewModel.articleViewModels.asObservable().subscribe(onNext: { [weak self] articles in
            if self?.articleType == .all {
                DispatchQueue.main.async {
                    if (articles.count != 0) {
                        self?.navigationItem.title = articles.first?.source.value
                        self?.activityIndicatorView.stopAnimating()
                        self?.tableView.isUserInteractionEnabled = true
                    }
                }
            }
        }).disposed(by: disposeBag)
    }
    
    /**
     * Setups the TableViewCell to display the required info
     **/
    func setupCellConfiguration() {
        switch self.articleType {
        case .favourite:
            self.articleListViewModel.favouriteArticleViewModels.asObservable()
                .bind(to: self.tableView.rx.items(cellIdentifier: CellConstants.article, cellType: NAArticleTableViewCell.self)) { index, article, cell in
                    cell.configureWithArticle(article: article)
                }
                .disposed(by: disposeBag)
        default:
            self.articleListViewModel.articleViewModels.asObservable()
                .bind(to: self.tableView.rx.items(cellIdentifier: CellConstants.article, cellType: NAArticleTableViewCell.self)) { index, article, cell in
                    cell.configureWithArticle(article: article)
                }
                .disposed(by: disposeBag)
        }
    }
    
    /**
     * Configures the tap handling of the TableViewCell
     **/
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
    /**
     * Goes to the Favourites Headlines List
     **/
    @IBAction func clickFavouritesButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: SegueIdentifiers.favouritesView, sender: nil)
    }
    
    /**
     * Returns to the Main Headlines List
     **/
    @IBAction func clickDoneButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    /**
     * Makes a new NewsAPI request
     **/
    @IBAction func clickRefreshButton(_ sender: UIBarButtonItem) {
        self.refreshButton.isEnabled = false
        self.setupStart()
    }
}

// MARK: - NAArticle Delegate

extension NAArticleTableViewController: NAArticleFavouriteDelegate {
    /**
     * Handles the headline favourite operation to both article arrays
     **/
    func addToFavourites(articleViewModel: NAArticleViewModel) {
        let currentFavourites = self.articleListViewModel.favouriteArticleViewModels.value + [articleViewModel]
        self.articleListViewModel.favouriteArticleViewModels.accept(currentFavourites)
        
        let article = self.articleListViewModel.articleViewModels.value.filter { $0.title.value == articleViewModel.title.value }.first
        if let article = article {
            article.isFavourite.accept(true)
        }
    }
    
    /**
     * Handles the headline unfavourite operation to both article arrays
     **/
    func removeFromFavourites(articleViewModel: NAArticleViewModel) {
        let currentFavourites = self.articleListViewModel.favouriteArticleViewModels.value.filter { $0.title.value != articleViewModel.title.value }
        self.articleListViewModel.favouriteArticleViewModels.accept(currentFavourites)
        
        let article = self.articleListViewModel.articleViewModels.value.filter { $0.title.value == articleViewModel.title.value }.first
        if let article = article {
            article.isFavourite.accept(false)
        }
    }
}


// MARK: - Navigation

extension NAArticleTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.detailView {    // go to details view
            let articleDetailVC = segue.destination as? NAArticleDetailViewController
            let articleViewModel = sender as! NAArticleViewModel
            articleDetailVC?.articleViewModel = articleViewModel
            articleDetailVC?.delegate = self
        } else if segue.identifier == SegueIdentifiers.favouritesView { // go to favourites list view
            if let favouriteListTVC = (segue.destination as? UINavigationController)?.children.first as? NAArticleTableViewController {
                favouriteListTVC.articleType = .favourite
                favouriteListTVC.articleListViewModel = self.articleListViewModel
            }
        }
    }
}
