
import Foundation

/**
 * Delegation that manages the artcles array after the 'add to' and 'remove from' operations
 **/
protocol NAArticleFavouriteDelegate: class {
    func addToFavourites(articleViewModel: NAArticleViewModel)
    func removeFromFavourites(articleViewModel: NAArticleViewModel)
}
