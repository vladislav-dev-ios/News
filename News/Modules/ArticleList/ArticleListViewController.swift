//
//  ArticleViewController.swift
//  News
//
//  Created by Владислав Кузьмичёв on 31.08.2022.
//

import Foundation
import UIKit

class ArticleListViewController: UIViewController {
    
    // MARK: -  Properties
    var presenter: ArticleListPresenterProtocol?
    
    private lazy var articleTableView: UITableView = {
        let table = UITableView()
        table.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = #colorLiteral(red: 0.1333171129, green: 0.133343339, blue: 0.1333138049, alpha: 1)
        return table
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .default
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.barStyle = .black
        return searchBar
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "News"
        view.backgroundColor = #colorLiteral(red: 0.1333171129, green: 0.133343339, blue: 0.1333138049, alpha: 1)
        
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.white]
        
        configure()
        hideKeyboardWhenTappedAround()
    }
}

extension ArticleListViewController {
    func configure() {
        view.addSubviews([
            articleTableView,
            searchBar
        ])
        NSLayoutConstraint.activate([
            searchBar.leftAnchor.constraint(equalTo: view.safeLeftAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeTopAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.safeRightAnchor),
            
            articleTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            articleTableView.leftAnchor.constraint(equalTo: view.safeLeftAnchor),
            articleTableView.rightAnchor.constraint(equalTo: view.safeRightAnchor),
            articleTableView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -10)
        ])
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)
    }
    
    @objc
    private func dismissKeyboard() {
           view.endEditing(true)
       }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ArticleListViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { [weak self] action, index in
            self?.presenter?.favoriteButtonTapped(at: indexPath.row)
        }
        
        favorite.backgroundColor = .orange
        return [favorite]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

// MARK: - UISearchBarDelegate
extension ArticleListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.filterArticles(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}

// MARK: - ArticleListView Protocol
extension ArticleListViewController: ArticleListViewProtocol {
    
    func succes() {
        articleTableView.reloadData()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
    func openModule(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}
