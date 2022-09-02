//
//  ArticleListPresenter.swift
//  News
//
//  Created by Владислав Кузьмичёв on 31.08.2022.
//

import Foundation
import UIKit

protocol ArticleListViewProtocol: AnyObject {
    func succes()
    func failure(error: Error)
    
    func openModule(vc: UIViewController)
}

protocol ArticleListPresenterProtocol: AnyObject {
    init(view: ArticleListViewProtocol, networkService: NetworkService, repository: AnyRepository<Article>)
    
    func getArticles()
    
    func returnCountOfArticles() -> Int
    func getArticle(at row: Int) -> Article?
    func cellDidSelect(at row: Int)
    func favoriteButtonTapped(at row: Int)
    func filterArticles(with text: String)
    
    var articles: [Article]? { get set }
}

class ArticleListPresenter: ArticleListPresenterProtocol {
    
    // MARK: -  Properties
    private weak var view: ArticleListViewProtocol?
    private let networkService: NetworkService!
    private let repository: AnyRepository<Article>
    
    var articles: [Article]?
    var searchArticles: [Article]?
    
    // MARK: -  Init
    required init(view: ArticleListViewProtocol, networkService: NetworkService, repository: AnyRepository<Article>) {
        self.view = view
        self.networkService = networkService
        self.repository = repository
        
        getArticles()
    }
    
    // MARK: -  Public methods
    func getArticles() {
        networkService.fetchArticles { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    self.articles = articles
                    self.searchArticles = articles
                    self.view?.succes()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func returnCountOfArticles() -> Int {
        return searchArticles?.count ?? 0
    }
    
    func getArticle(at row: Int) -> Article? {
        return searchArticles?[row]
    }
    
    func cellDidSelect(at row: Int) {
        let article = articles?[row]
        
        if let article = article {
            let detailModule = ModuleBuilder.createArticleDetailModule(article: article)
            
            view?.openModule(vc: detailModule)
        }
    }
    
    func favoriteButtonTapped(at row: Int) {
        let article = articles?[row]
        let favoriteArticles = repository.getAll()
        
        for favoriteArticle in favoriteArticles {
            if article?.title == favoriteArticle.title {
                return
            }
        }
        
        if let article = article {
            try? repository.insert(item: article)
        }
    
    }
    
    func filterArticles(with text: String) {
        if text.isEmpty {
            searchArticles = articles
        } else {
            searchArticles = articles.flatMap({ $0 })?.filter({
                $0.title.lowercased().contains(text.lowercased())
            })
        }
      
        
        DispatchQueue.main.async { [weak self] in
            self?.view?.succes()
        }
    }
}
