//
//  ModuleBuilder.swift
//  News
//
//  Created by Владислав Кузьмичёв on 31.08.2022.
//

import Foundation
import UIKit

protocol Builder {
    
    static func createArticleListModule() -> UIViewController
    static func createArticleDetailModule(article: Article) -> UIViewController
    static func createFavoriteArticelsModile() -> UIViewController
}

class ModuleBuilder: Builder {
    
    static func createArticleListModule() -> UIViewController {
        let view = ArticleListViewController()
        let networkService = NetworkService()
        let presenter = ArticleListPresenter(view: view, networkService: networkService, repository: AnyRepository<Article>())
        view.presenter = presenter
        
        return view
    }
    
    static func createArticleDetailModule(article: Article) -> UIViewController {
        let view = ArticleDetailViewController()
        let presenter = ArticleDetailPresenter(view: view, article: article)
        view.presenter = presenter
        
        return view
    }
    
    static func createFavoriteArticelsModile() -> UIViewController {
        let view = FavoriteArticlesViewController()
        let presenter = FavoriteArticlesPresenter(view: view, repository: AnyRepository<Article>())
        view.presenter = presenter
        
        return view
    }
}
