
import UIKit

class NAArticleTableViewController: UITableViewController {
    var activityIndicatorView: UIActivityIndicatorView! = UIActivityIndicatorView(style: .gray)
    
    private var articleListViewModel: NAArticleListViewModel! = NAArticleListViewModel()

    override func loadView() {
        super.loadView()
        
        self.tableView.backgroundView = self.activityIndicatorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = self.articleListViewModel.title
        
        self.tableView.isUserInteractionEnabled = false
        self.activityIndicatorView.startAnimating()
        
        articleListViewModel.getArticles { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicatorView.stopAnimating()
                self?.tableView.isUserInteractionEnabled = true
                
                self?.navigationItem.title = self?.articleListViewModel.title
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - Table view data source

extension NAArticleTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListViewModel.articleViewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellConstants.article, for: indexPath) as? NAArticleTableViewCell else {
            fatalError("Not supposed to happen...")
        }
        
        let article = self.articleListViewModel.articleViewModels[indexPath.row]
        
        cell.articleTitle.text = article.title
        
        if let imageData = article.imageData {
            cell.articleImage.image = UIImage(data: imageData)
        } else {
            cell.activityIndicatorView.startAnimating()
            
            cell.articleImage.image = UIImage(named: bbcNewsTargetInfo.defaultImage)
            article.downloadImage { data, error in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.articleImage.image = UIImage(data: data)
                        cell.activityIndicatorView.stopAnimating()
                    }
                }
            }
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
