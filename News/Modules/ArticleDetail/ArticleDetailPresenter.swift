//
//  ArticleDetailPresenter.swift
//  News
//
//  Created by Владислав Кузьмичёв on 31.08.2022.
//

import Foundation
import SafariServices

protocol ArticleDetailViewProtocol: AnyObject {
    func setArticle(article: Article)
    func presentView(vc: UIViewController)
}

protocol ArticleDetailPresenterProtocol: AnyObject {
    init(view: ArticleDetailViewProtocol, article: Article)
    
    func setArticle()
    func sourceButtonTapped()
}

class ArticleDetailPresenter: ArticleDetailPresenterProtocol {
    
    // MARK: -  Properties
    private weak var view: ArticleDetailViewProtocol?
    private let article: Article
    
    // MARK: -  Init
    required init(view: ArticleDetailViewProtocol, article: Article) {
        self.view = view
        self.article = article
        
    }
    
    // MARK: -  Public methods
    func setArticle() {
        view?.setArticle(article: article)
    }
    
    func sourceButtonTapped() {
        guard let url = URL(string: article.url) else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        view?.presentView(vc: safariViewController)
        
    }
}
