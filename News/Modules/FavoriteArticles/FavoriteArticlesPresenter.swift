//
//  FavoriteArticlesPresenter.swift
//  News
//
//  Created by Владислав Кузьмичёв on 01.09.2022.
//

import Foundation
import UIKit

protocol FavoriteArticlesViewProtocol: AnyObject {
    func reloadArticles()
    
    func openModule(vc: UIViewController)
}

protocol FavoriteArticlesPresenterProtocol {
    init(view: FavoriteArticlesViewProtocol, repository: AnyRepository<Article>)
    func getArticles()
    
    func returnCountOfArticles() -> Int
    func getArticle(at row: Int) -> Article?
    func cellDidSelect(at row: Int)
    
    var articles: [Article]? { get set }
}

class FavoriteArticlesPresenter: FavoriteArticlesPresenterProtocol {
    
    // MARK: -  Properties
    private weak var view: FavoriteArticlesViewProtocol?
    private let repository: AnyRepository<Article>
    
    var articles: [Article]?
    
    // MARK: -  Init
    required init(view: FavoriteArticlesViewProtocol, repository: AnyRepository<Article>) {
        self.view = view
        self.repository = repository        
    }
    
    // MARK: -  Public methods
    func getArticles() {
        articles = repository.getAll()
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.reloadArticles()
        }
    }
    
    func returnCountOfArticles() -> Int {
        return articles?.count ?? 0
    }
    
    func getArticle(at row: Int) -> Article? {
        return articles?[row]
    }
    
    func cellDidSelect(at row: Int) {
        let article = articles?[row]
        
        if let article = article {
            let detailModule = ModuleBuilder.createArticleDetailModule(article: article)
            
            view?.openModule(vc: detailModule)
        }
    }
    
}
