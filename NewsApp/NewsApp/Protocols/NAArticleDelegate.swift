
import Foundation

protocol NAArticleDelegate: class {
    func addToFavourites(articleViewModel: NAArticleViewModel)
    func removeFromFavourites(articleViewModel: NAArticleViewModel)
}
