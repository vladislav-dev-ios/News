//
//  FavoriteArticlesViewController.swift
//  News
//
//  Created by Владислав Кузьмичёв on 01.09.2022.
//

import Foundation
import UIKit

class FavoriteArticlesViewController: UIViewController {
    
    // MARK: -  Properties
    var presenter: FavoriteArticlesPresenterProtocol?
    
    private lazy var articleTableView: UITableView = {
        let table = UITableView()
        table.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = #colorLiteral(red: 0.1333171129, green: 0.133343339, blue: 0.1333138049, alpha: 1)
        return table
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites"
        view.backgroundColor = #colorLiteral(red: 0.1333171129, green: 0.133343339, blue: 0.1333138049, alpha: 1)
        
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.white]
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.getArticles()
    }
    
    
}

extension FavoriteArticlesViewController {
    private func configure() {
        view.addSubviews([
            articleTableView
        ])
        NSLayoutConstraint.activate([
            articleTableView.topAnchor.constraint(equalTo: view.safeTopAnchor),
            articleTableView.leftAnchor.constraint(equalTo: view.safeLeftAnchor),
            articleTableView.rightAnchor.constraint(equalTo: view.safeRightAnchor),
            articleTableView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FavoriteArticlesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.returnCountOfArticles() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.identifier, for: indexPath) as! ArticleTableViewCell
        
        cell.prepareForReuse()
        
        let article = presenter?.getArticle(at: indexPath.row)
        
        if let article = article {
            cell.configure(article: article)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.cellDidSelect(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

// MARK: - FavoriteArticles ViewProtocol
extension FavoriteArticlesViewController: FavoriteArticlesViewProtocol {
    func reloadArticles() {
        articleTableView.reloadData()
    }
    
    func openModule(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
